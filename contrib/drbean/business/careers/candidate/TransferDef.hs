module TransferDef where

import PGF (Tree)
import Candidate   -- generated from GF

transfer :: Tree -> Tree
transfer = gf . answer . fg

answer :: GEvent -> GEvent
answer p = case p of
  GStatement x y -> GStatement Gdr_bean (GPositing Gthink (GIs x Ggood) )
  GIs Gdr_bean y  -> GIs (GThe Gresult) y
  _   -> GIs (GThe Gresult) Gbad

data Term = Const Entity | Var Int | Struct String [Term]
        deriving (Eq)

data LF = NonProposition
        | Rel String [Term]
        | Eq   Term Term
        | Neg  LF
        | Impl LF LF
        | Equi LF LF
        | Conj [LF]
        | Disj [LF]
        | Forall (Term -> LF)
        | Exists (Term -> LF)
        | Single (Term -> LF)
        | The (Term -> LF)
        | Several (Term -> LF)
        | Many (Term -> LF)
        | Most (Term -> LF)
        | WH (Term -> LF)
--      deriving Eq

instance Show Term where
  show (Const name) = show name
  show (Var i)      = 'x': show i
  show (Struct s []) = s
  show (Struct s ts) = s ++ show ts

LogicalForm.hs                                                                                                            54,1            4%
-- VISUAL --                                                                                                                     66
ishow (Disj []) i     = "false"
ishow (Disj lfs) i    = "disj" ++ "[" ++ ishowForms lfs i ++ "]"
ishow (Forall scope) i = "Forall x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (Exists scope) i = "Exists x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (Single scope) i = "Single x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (The scope) i = "The x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (Several scope) i = "Several x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (Many scope) i = "Many x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (Most scope) i = "Most x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))
ishow (WH scope) i = "WH x" ++ show i ++ (' ' :
                        (ishow (scope (Var i)) (i+1)))

ishowForms :: [LF] -> Int -> String
ishowForms [] _ = ""
ishowForms [f] i = ishow f i
ishowForms (f:fs) i = ishow f i ++ "," ++ ishowForms fs i

relname :: LF -> String
relname (Rel name _) = name
relname lf = error ( (show lf) ++ " not a relation" )


transGS :: GEvent -> Bool
transGS x y = transGItem x) transGPredicate y)

transGItem :: GItem -> kkkk
--value :: GObject -> Int
--value e = case e of
--  GNumber (GInt i) -> fromIntegral i

--test :: (Int -> Bool) -> GObject -> GAnswer
--test f x = if f (value x) then GYes else GNo

prime :: Int -> Bool
prime x = elem x primes where
  primes = sieve [2 .. x]
  sieve (p:xs) = p : sieve [ n | n <- xs, n `mod` p > 0 ]
  sieve [] = []
