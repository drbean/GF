module WordsCharacters where 

import qualified Data.Map as Map

gfWords = Map.fromList [("A",a), ("Det",det), ("N",n), ("PN",pn), ("V",v) ]
wordlist = concat ( map (gfWords Map.!) (Map.keys gfWords) )
posMap = Map.fromList [
	("A","Adjective"),
	("Det","Determiner"),
	("N","Noun"),
	("PN","Proper Noun"),
	("V","Verb")
	]

a = [
	"ambitious",
	"bad",
	"competitive",
	"confident",
	"difficult",
	"each",
	"fast",
	"few",
	"five",
	"good",
	"hard",
	"honest",
	"local",
	"long",
	"next",
	"other",
	"outgoing",
	"past",
	"patient",
	"Polish",
	"poor",
	"possible",
	"realistic",
	"safe",
	"successful",
	"true",
	"unable",
	"various"
	]

det = [ "a", "the" ]

n = [
	"ability",
	"administration",
	"aim",
	"club",
	"company",
	"training",
	"course",
	"department",
	"director",
	"effort",
	"sales",
	"experience",
	"hand",
	"head",
	"job",
	"judgement",
	"learner",
	"lot",
	"main",
	"market",
	"material",
	"pair",
	"people",
	"personality",
	"respect",
	"result",
	"risk",
	"sales",
	"share",
	"system",
	"sales",
	"team",
	"term",
	"thing",
	"time",
	"top",
	"way",
	"year"
	]

pn = [
	"Barbara",
	"Dr Bean",
	"Eva",
	"Fast-Track",
	"Tadeusz"
	]


v = [
	"allow",
	"for",
	"can",
	"become",
	"choose",
	"enjoy",
	"expand",
	"feel",
	"improve",
	"increase",
	"go",
	"have",
	"help",
	"know",
	"lead",
	"must",
	"think",
	"want"
	]

