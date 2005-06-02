----------------------------------------------------------------------
-- |
-- Module      : MkConcrete
-- Maintainer  : AR
-- Stability   : (stable)
-- Portability : (portable)
--
-- > CVS $Date: 
-- > CVS $Author: 
-- > CVS $Revision: 
--
-- Compile a gfl file into a concrete syntax by using the parser on a resource grammar.
-----------------------------------------------------------------------------

module GF.Compile.MkConcrete (mkConcrete) where

import GF.Grammar.Values (Tree,tree2exp)
import GF.Grammar.PrGrammar (prt_)
import GF.Compile.ShellState (absId,firstStateGrammar)
import GF.API
import qualified GF.Embed.EmbedAPI as EA

import GF.Data.Operations
import GF.Infra.UseIO
import GF.Infra.Option

import Data.Char
import Control.Monad

-- translate strings into lin rules by parsing in a resource
-- grammar. AR 2/6/2005

-- Format of rule (on one line):
--    lin F x y = in C "ssss" ;
-- Format of resource path (on first line):
--    --# -resource=PATH
-- Other lines are copied verbatim.
-- Assumes: resource has been built with 
--    i -src -optimize=share SOURCE
-- because mcfg parsing is used.


mkConcrete :: FilePath -> IO ()
mkConcrete file = do
  cont <- liftM lines $ readFileIf file
  let res = getResPath cont
  egr <- appIOE $ optFile2grammar (options [useOptimizer "share"]) res --- for -mcfg
  gr  <- err (\s -> putStrLn s >> error "resource file rejected") return egr
  let abs = prt_ $ absId gr
  let parser cat = errVal ([],"No parse") . 
                   optParseArgErrMsg (options [newMParser, firstCat cat, beVerbose]) gr
  let morpho = isKnownWord gr
  writeFile (suffixFile "gf" (justModuleName file)) $ unlines $ 
    map (mkCnc parser morpho) cont

getResPath :: [String] -> String
getResPath s = case head (dropWhile (all isSpace) s) of
  '-':'-':'#':path -> reverse (takeWhile (not . (=='=')) (reverse path))
  _ -> error "first line must be --# -resource=<PATH>" 

mkCnc :: (String -> String -> ([Tree],String)) -> (String -> Bool) -> String -> String
mkCnc parser morpho line = case words line of
  "lin" : rest -> mkLinRule rest
  _ -> line
 where
   mkLinRule s = 
    let
       (pre,str)  = span (/= "in") s
       ([cat],rest) = splitAt 1 $ tail str
       lin        = init (tail (unwords (init rest))) -- unquote
       def 
        | last pre /= "=" = line  -- ordinary lin rule
        | otherwise  = case parser cat lin of 
           ([t],_)  -> "lin " ++ unwords pre +++ prt_ (tree2exp t) +++ ";" 
           (t:_,_)  -> "lin " ++ unwords pre +++ prt_ (tree2exp t) +++ "{- AMBIGUOUS -} ;"
           ([],msg) -> "{-" ++ line ++++ morph lin ++++ "-}" 
    in
     def
   morph s = case [w | w <- words s, not (morpho w)] of
     [] -> ""
     ws -> "unknown words: " ++ unwords ws
