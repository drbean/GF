module Main where

import PGF
import Candidate

import Data.List
import Data.Char

main :: IO () 
main = do
  gr <- readPGF "/home/drbean/bett/branch/gf/bin/Candidate.pgf"
  s <- getLine
  let l = lc_first s
  let ls = linear transform gr (parses l gr)
  putStrLn (concat ls)

parses :: String -> PGF -> [Tree]
parses s gr = concat ( parseAll gr (startCat gr) s )

transform :: Tree -> Tree
transform = gf . answer . fg

answer :: GCl -> GCl
answer = id

linear :: (Tree -> Tree) -> PGF -> [Tree] -> [ String ]
linear tr gr ps = concat $ map ((linearizeAll gr) . tr) ps

lc_first :: String -> String
lc_first str@(s:ss) = case ( or $ map (flip isPrefixOf str) ["Barbara", "Tadeusz", "Eva", "Dr Bean"] ) of
	True  -> (s:ss)
	False -> ((toLower s):ss)

chomp :: String -> String
chomp str = let rev@(c:cs) = reverse string
		in dot = case (c:cs) of
			'.':_ -> cs
			otherwise -> rev
