module TransferDef where

import PGF (Tree)
import Candidate   -- generated from GF

transfer :: Tree -> Tree
transfer = gf . answer . fg

answer :: GEvent -> GEvent
answer p = case p of
  GS x y | value y == "go"-> GS (Geva ) (GHappening Gexpand)
  -- GS x y -> GS (GPN2NP (Gdr_bean)) (GPositing Gthink (GIs x Ggood) )
  GIs Geva y  -> GIs (GThe Gresult) y
  _  -> GIs (GThe Gresult) Gbad
  -- GS x y | y == 

value :: GPredicate -> String
value e = case e of
  GHappening (Ggo) -> "go"

--test :: (Int -> Bool) -> GObject -> GAnswer
--test f x = if f (value x) then GYes else GNo

prime :: Int -> Bool
prime x = elem x primes where
  primes = sieve [2 .. x]
  sieve (p:xs) = p : sieve [ n | n <- xs, n `mod` p > 0 ]
  sieve [] = []
