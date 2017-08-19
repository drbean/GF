{-# LANGUAGE DeriveDataTypeable, ExistentialQuantification #-}

#include <pgf/pgf.h>
#include <gu/exn.h>
#include <sg/sg.h>

module SG( SG, openSG, closeSG
         , beginTrans, commit, rollback, inTransaction
         , SgId
         , insertExpr, getExpr, queryExpr
         , updateFtsIndex
         , queryLinearization
         , readTriple, showTriple
         , insertTriple, getTriple
         , queryTriple
         , query
         ) where

import Foreign hiding (unsafePerformIO)
import Foreign.C
import SG.FFI
import PGF2.FFI
import PGF2.Expr

import Data.Typeable
import Control.Exception(Exception,SomeException,catch,throwIO)
import System.IO.Unsafe(unsafePerformIO,unsafeInterleaveIO)

-----------------------------------------------------------------------
-- Global database operations and types

newtype SG = SG {sg :: Ptr SgSG}

openSG :: FilePath -> IO SG
openSG fpath =
  withCString fpath $ \c_fpath ->
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg <- sg_open c_fpath exn
    failed <- gu_exn_is_raised exn
    if failed
      then do is_errno <- gu_exn_caught exn gu_exn_type_GuErrno
              if is_errno
                then do perrno <- (#peek GuExn, data.data) exn
                        errno  <- peek perrno
                        ioError (errnoToIOError "openSG" (Errno errno) Nothing (Just fpath))
                else do is_sgerr <- gu_exn_caught exn gu_exn_type_SgError
                        if is_sgerr
                          then do c_msg <- (#peek GuExn, data.data) exn
                                  msg <- peekUtf8CString c_msg
                                  throwIO (SGError msg)
                          else throwIO (SGError "The database cannot be opened")
      else return (SG sg)

closeSG :: SG -> IO ()
closeSG (SG sg) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg <- sg_close sg exn
    handle_sg_exn exn

beginTrans :: SG -> IO ()
beginTrans (SG sg) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg <- sg_begin_trans sg exn
    handle_sg_exn exn

commit :: SG -> IO ()
commit (SG sg) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg <- sg_commit sg exn
    handle_sg_exn exn

rollback :: SG -> IO ()
rollback (SG sg) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg <- sg_rollback sg exn
    handle_sg_exn exn

inTransaction :: SG -> IO a -> IO a
inTransaction sg f =
  catch (beginTrans sg >> f >>= \x -> commit sg >> return x)
        (\e -> rollback sg >> throwIO (e :: SomeException))

-----------------------------------------------------------------------
-- Expressions

insertExpr :: SG -> Expr -> IO SgId
insertExpr (SG sg) (Expr expr touch) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    id <- sg_insert_expr sg expr 1 exn
    touch
    handle_sg_exn exn
    return id

getExpr :: SG -> SgId -> IO (Maybe Expr)
getExpr (SG sg) id = do
  exprPl  <- gu_new_pool
  exprFPl <- newForeignPtr gu_pool_finalizer exprPl
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    c_expr <- sg_get_expr sg id exprPl exn
    handle_sg_exn exn
    if c_expr == nullPtr
      then do touchForeignPtr exprFPl
              return Nothing
      else do return $ Just (Expr c_expr (touchForeignPtr exprFPl))

queryExpr :: SG -> Expr -> IO [(SgId,Expr)]
queryExpr (SG sg) (Expr query touch) =
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    res <- sg_query_expr sg query tmpPl exn
    touch
    handle_sg_exn exn
    fetchResults res exn
  where
    fetchResults res exn = do
      exprPl <- gu_new_pool
      (key,c_expr) <- alloca $ \pKey -> do
                        c_expr <- sg_query_next sg res pKey exprPl exn
                        key <- peek pKey
                        return (key,c_expr)
      failed <- gu_exn_is_raised exn
      if failed
        then do gu_pool_free exprPl
                sg_query_close sg res exn
                handle_sg_exn exn
                return []
        else if c_expr == nullPtr
               then do gu_pool_free exprPl
                       sg_query_close sg res exn
                       return []
               else do exprFPl <- newForeignPtr gu_pool_finalizer exprPl
                       rest <- fetchResults res exn
                       return ((key,Expr c_expr (touchForeignPtr exprFPl)) : rest)

updateFtsIndex :: SG -> PGF -> IO ()
updateFtsIndex (SG sg) p = do
  withGuPool $ \tmpPl -> do
    exn <- gu_new_exn tmpPl
    sg_update_fts_index sg (pgf p) exn
    handle_sg_exn exn

queryLinearization :: SG -> String -> IO [Expr]
queryLinearization (SG sg) query = do
  exprPl  <- gu_new_pool
  exprFPl <- newForeignPtr gu_pool_finalizer exprPl
  (withGuPool $ \tmpPl -> do
     c_query <- newUtf8CString query tmpPl
     exn <- gu_new_exn tmpPl
     seq <- sg_query_linearization sg c_query tmpPl exn
     handle_sg_exn exn
     len <- (#peek GuSeq, len) seq
     ids <- peekArray (fromIntegral (len :: CInt)) (seq `plusPtr` (#offset GuSeq, data))
     getExprs exprFPl exprPl exn ids)
  where
    getExprs exprFPl exprPl exn []       = return []
    getExprs exprFPl exprPl exn (id:ids) = do
      c_expr <- sg_get_expr sg id exprPl exn
      handle_sg_exn exn
      if c_expr == nullPtr
        then getExprs exprFPl exprPl exn ids
        else do let e = Expr c_expr (touchForeignPtr exprFPl)
                es <- getExprs exprFPl exprPl exn ids
                return (e:es)

-----------------------------------------------------------------------
-- Triples

readTriple :: String -> Maybe (Expr,Expr,Expr)
readTriple str =
  unsafePerformIO $
    do exprPl <- gu_new_pool
       withGuPool $ \tmpPl ->
         withTriple $ \triple ->
           do c_str <- newUtf8CString str tmpPl
              guin <- gu_string_in c_str tmpPl
              exn <- gu_new_exn tmpPl
              ok <- pgf_read_expr_tuple guin 3 triple exprPl exn
              status <- gu_exn_is_raised exn
              if (ok == 1 && not status)
                then do c_expr1 <- peekElemOff triple 0
                        c_expr2 <- peekElemOff triple 1
                        c_expr3 <- peekElemOff triple 2
                        exprFPl <- newForeignPtr gu_pool_finalizer exprPl
                        let touch = touchForeignPtr exprFPl
                        return $ Just (Expr c_expr1 touch,Expr c_expr2 touch,Expr c_expr3 touch)
                else do gu_pool_free exprPl
                        return Nothing

showTriple :: Expr -> Expr -> Expr -> String
showTriple (Expr expr1 touch1) (Expr expr2 touch2) (Expr expr3 touch3) =
  unsafePerformIO $
    withGuPool $ \tmpPl ->
      withTriple $ \triple -> do
         (sb,out) <- newOut tmpPl
         let printCtxt = nullPtr
         exn <- gu_new_exn tmpPl
         pokeElemOff triple 0 expr1
         pokeElemOff triple 1 expr2
         pokeElemOff triple 2 expr3
         pgf_print_expr_tuple 3 triple printCtxt out exn
         touch1 >> touch2 >> touch3
         s <- gu_string_buf_freeze sb tmpPl
         peekUtf8CString s

insertTriple :: SG -> Expr -> Expr -> Expr -> IO SgId
insertTriple (SG sg) (Expr expr1 touch1) (Expr expr2 touch2) (Expr expr3 touch3) =
  withGuPool $ \tmpPl -> 
  withTriple $ \triple -> do
    exn <- gu_new_exn tmpPl
    pokeElemOff triple 0 expr1
    pokeElemOff triple 1 expr2
    pokeElemOff triple 2 expr3
    id <- sg_insert_triple sg triple exn
    touch1 >> touch2 >> touch3
    handle_sg_exn exn
    return id

getTriple :: SG -> SgId -> IO (Maybe (Expr,Expr,Expr))
getTriple (SG sg) id = do
  exprPl <- gu_new_pool
  exprFPl <- newForeignPtr gu_pool_finalizer exprPl
  let touch = touchForeignPtr exprFPl
  withGuPool $ \tmpPl ->
   withTriple $ \triple -> do
     exn <- gu_new_exn tmpPl
     res <- sg_get_triple sg id triple exprPl exn
     handle_sg_exn exn
     if res /= 0
       then do c_expr1 <- peekElemOff triple 0
               c_expr2 <- peekElemOff triple 1
               c_expr3 <- peekElemOff triple 2
               return (Just (Expr c_expr1 touch
                            ,Expr c_expr2 touch
                            ,Expr c_expr3 touch
                            ))
       else do touch
               return Nothing

queryTriple :: SG -> Maybe Expr -> Maybe Expr -> Maybe Expr -> IO [(SgId,Expr,Expr,Expr)]
queryTriple (SG sg) mb_expr1 mb_expr2 mb_expr3 =
  withGuPool $ \tmpPl ->
  withTriple $ \triple -> do
    exn <- gu_new_exn tmpPl
    pokeElemOff triple 0 (toCExpr mb_expr1)
    pokeElemOff triple 1 (toCExpr mb_expr2)
    pokeElemOff triple 2 (toCExpr mb_expr3)
    res <- sg_query_triple sg triple exn
    handle_sg_exn exn
    unsafeInterleaveIO (fetchResults res)
  where
    toCExpr Nothing              = nullPtr
    toCExpr (Just (Expr expr _)) = expr

    fromCExpr c_expr touch Nothing  = Expr c_expr touch
    fromCExpr c_expr touch (Just e) = e

    fetchResults res = do
      exprPl  <- gu_new_pool
      alloca $ \pKey ->
       withGuPool $ \tmpPl ->
        withTriple $ \triple -> do
          exn <- gu_new_exn tmpPl
          r <- sg_triple_result_fetch res pKey triple exprPl exn
          failed <- gu_exn_is_raised exn
          if failed
            then do gu_pool_free exprPl
                    sg_triple_result_close res exn
                    handle_sg_exn exn
                    return []
            else if r == 0
                   then do gu_pool_free exprPl
                           sg_triple_result_close res exn
                           return []
                   else do exprFPl <- newForeignPtr gu_pool_finalizer exprPl
                           let touch = touchForeignPtr exprFPl
                           c_expr1 <- peekElemOff triple 0
                           c_expr2 <- peekElemOff triple 1
                           c_expr3 <- peekElemOff triple 2
                           key <- peek pKey
                           rest <- unsafeInterleaveIO (fetchResults res)
                           return ((key,fromCExpr c_expr1 touch mb_expr1
                                       ,fromCExpr c_expr2 touch mb_expr2
                                       ,fromCExpr c_expr3 touch mb_expr3) : rest)


query :: SG -> String -> IO [[Expr]]
query (SG sg) str =
  withGuPool $ \tmpPl ->
    do c_str <- newUtf8CString str tmpPl
       guin <- gu_string_in c_str tmpPl
       exn <- gu_new_exn tmpPl
       seq <- pgf_read_expr_matrix guin 3 tmpPl exn
       if seq /= nullPtr
         then do count <- (#peek GuSeq, len) seq
                 q <- sg_query sg (count `div` 3) (seq `plusPtr` (#offset GuSeq, data)) exn
                 handle_sg_exn exn
                 n_cols <- sg_query_result_columns q
                 unsafeInterleaveIO (fetchResults q n_cols)
         else return []
  where
    fetchResults q n_cols =
      withGuPool $ \tmpPl -> do
        exn    <- gu_new_exn tmpPl
        pExprs <- gu_malloc tmpPl ((#size PgfExpr) * n_cols)
        exprPl <- gu_new_pool
        res <- sg_query_result_fetch q pExprs exprPl exn
        failed <- gu_exn_is_raised exn
        if failed
          then do gu_pool_free exprPl
                  sg_query_result_close q exn
                  handle_sg_exn exn
                  return []
          else if res /= 0
                 then do exprFPl <- newForeignPtr gu_pool_finalizer exprPl
                         let touch = touchForeignPtr exprFPl
                         row  <- fmap (map (flip Expr touch)) $ peekArray (fromIntegral n_cols) pExprs
                         rows <- unsafeInterleaveIO (fetchResults q n_cols)
                         return (row:rows)
                 else do gu_pool_free exprPl
                         sg_query_result_close q exn
                         return []

-----------------------------------------------------------------------
-- Exceptions

newtype SGError = SGError String
     deriving (Show, Typeable)

instance Exception SGError

handle_sg_exn exn = do
  failed <- gu_exn_is_raised exn
  if failed
    then do is_sgerr <- gu_exn_caught exn gu_exn_type_SgError
            if is_sgerr
              then do c_msg <- (#peek GuExn, data.data) exn
                      msg <- peekUtf8CString c_msg
                      throwIO (SGError msg)
              else throwIO (SGError "Unknown database error")
    else return ()

-----------------------------------------------------------------------
