module Main where

import PGF
import Candidate

main :: IO () 
main = do
  gr <- readPGF "Candidate.pgf"
  putStrLn $ unwords $ map showCId ( categories gr )
  loop (translate transfer gr)

loop :: (String -> String) -> IO ()
loop trans = do 
  s <- getLine
  if s == "quit" then putStrLn "bye" else do  
    putStrLn $ trans s
    loop trans

translate :: (Tree -> Tree) -> PGF -> String -> String
translate tr gr s = (show (fmap (showCId . fst) (unApp (gf Geva)))) ++ (show $ head ( parseAll gr (startCat gr) s ) )
--translate tr gr s = case parseAllLang gr (startCat gr) s of
--  (lg,t:_):_ -> linearize gr lg (tr t)
--  -- (lg,t:_):_ -> showCId t
--  _ -> "NO PARSE"


transfer :: Tree -> Tree
transfer = gf . answer . fg

answer :: GCl -> GCl
answer = id
--answer :: GCl -> String
--answer p = case p of
--  GS x y -> linearize GS x y
--  -- GS x y -> GS (GPN2NP (Gdr_bean)) (GPositing Gthink (GIs x Ggood) )
--  -- GIs Geva y  -> GIs (GThe Gresult) y
--  _  -> GIs (GThe Gresult) Gbad
--  -- GS x y | y == 

value :: GVP -> String
value e = case e of
  GHappening (Ggo) -> "go"
  GHappening (Gexpand) -> "expand"

--test :: (Int -> Bool) -> GObject -> GAnswer
--test f x = if f (value x) then GYes else GNo

prime :: Int -> Bool
prime x = elem x primes where
  primes = sieve [2 .. x]
  sieve (p:xs) = p : sieve [ n | n <- xs, n `mod` p > 0 ]
  sieve [] = []
