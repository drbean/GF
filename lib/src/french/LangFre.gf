--# -path=.:../romance:../abstract:../common:../api

concrete LangFre of Lang = 
  GrammarFre,
  LexiconFre
  ,DocumentationFre
  ,ConstructionFre
  ** {

flags startcat = Phr ; unlexer = text ; lexer = text ;

} ;
