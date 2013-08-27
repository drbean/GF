module Main where

import PGF
import Candidate

main :: IO () 
main = do
  gr <- readPGF "Candidate.pgf"
  s <- getLine
  putStrLn ((translate transfer gr) s)

translate :: (Tree -> Tree) -> PGF -> String -> String
translate tr gr s = show $ concat ( parseAll gr (startCat gr) s )

transfer :: Tree -> Tree
transfer = gf . answer . fg

answer :: GCl -> GCl
answer = id
