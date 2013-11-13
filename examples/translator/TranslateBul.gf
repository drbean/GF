--# -path=.:alltenses:../phrasebook:../../lib/src/english:../../lib/src/bulgarian

concrete TranslateBul of Translate = 
  ParseBul, 
  PhrasebookBul - [PSentence, PQuestion, PGreetingMale, PGreetingFemale, GObjectPlease]
   ** open SyntaxBul, (E = ExtraBul), Prelude in {

flags
  literal = Symb ;

lin
  PPhr p = lin Text p ;
  NP_Person np = {name = lin NP np ; isPron = False ; poss = mkQuant he_Pron} ;
  NP_Object np = lin NP np ;
  NP_Item np = lin NP np ;
  NP_Place np0 = let np = lin NP np0 in 
                 {name = np ; at = SyntaxBul.mkAdv in_Prep np ; to = SyntaxBul.mkAdv to_Prep np} ;

--- to remove Phrasebook punctuation, which makes the output in Translate heterogeneous

    PSentence s = lin Text (mkUtt s) ; 
    PQuestion s = lin Text (mkUtt s) ; 
    PGreetingMale, PGreetingFemale = \g -> lin Text g ;
    GObjectPlease o = lin Text (mkUtt o) ;
  
}