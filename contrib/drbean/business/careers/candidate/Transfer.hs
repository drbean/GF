module Main where

import PGF
import Candidate
import WordsCharacters

import Data.List
import Data.Char

main :: IO () 
main = do
  gr <- readPGF "/home/drbean/GF/contrib/drbean/business/careers/candidate/Candidate.pgf"
  s <- getLine
  let l = (chomp . lc_first) s
  putStrLn ("Unknown_words: " ++ (unknown l) )
  let ls = linear transform gr (parses l gr)
  putStrLn ("Parsed: " ++ (concat ls) )

unknown :: String -> String
unknown str = unwords ( filter (\x -> not (elem x wordlist)) (words str) )

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
chomp str = let rev@(c:cs) = reverse str
		in case (c:cs) of
			'.':_ -> reverse cs
			otherwise -> reverse rev
