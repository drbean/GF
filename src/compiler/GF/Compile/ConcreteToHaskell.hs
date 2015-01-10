module GF.Compile.ConcreteToHaskell where
import Data.List(sort,sortBy)
import Data.Function(on)
import qualified Data.Map as M
import qualified Data.Set as S
import GF.Data.ErrM
import GF.Data.Utilities(mapSnd)
import GF.Text.Pretty
import GF.Grammar.Grammar
import GF.Grammar.Lookup(lookupFunType,lookupOrigInfo,allOrigInfos)--,allParamValues
import GF.Grammar.Macros(typeForm,collectOp,mkAbs,mkApp)
import GF.Grammar.Lockfield(isLockLabel)
import GF.Grammar.Predef(cPredef,cInts)
import GF.Compile.Compute.Predef(predef)
import GF.Compile.Compute.Value(Predefined(..))
import GF.Infra.Ident(Ident,identS,prefixIdent) --,moduleNameS
import GF.Infra.Option
import GF.Compile.Compute.ConcreteNew(normalForm,resourceValues)
import Debug.Trace

concretes2haskell opts absname gr =
  [(cncname,concrete2haskell opts gr cenv absname cnc cncmod)
     | let cenv = resourceValues gr,
       cnc<-allConcretes gr absname,
       let cncname = render cnc ++ ".hs"
           Ok cncmod = lookupModule gr cnc
  ]

concrete2haskell opts gr cenv absname cnc modinfo =
    render $
      haskPreamble absname cnc $$ "" $$
      "--- Parameter types ---" $$
      vcat (neededParamTypes S.empty (params defs)) $$ "" $$
      "--- Type signatures for linearization functions ---" $$
      vcat (map signature (S.toList allcats)) $$ "" $$
      "--- Linearization functions for empty categories ---" $$
      vcat emptydefs $$ "" $$
      "--- Linearization types and linearization functions ---" $$
      vcat (map ppDef defs) $$ "" $$
      "--- Type classes for projection functions ---" $$
      vcat (map labelClass (S.toList (S.unions (map S.fromList rs)))) $$ "" $$
      "--- Record types ---" $$
      vcat (map recordType rs)
  where
    rs = S.toList (S.insert [ident2label (identS "s")] (records rhss))
    rhss = map (snd.snd) defs
    defs = sortBy (compare `on` fst) .
           concatMap (toHaskell gId gr absname cenv) . 
           M.toList $
           jments modinfo

    signature c = "lin"<>c<+>"::"<+>"A."<>gId c<+>"->"<+>"Lin"<>c

    emptydefs = map emptydef (S.toList emptyCats)
    emptydef c = "lin"<>c<+>"_"<+>"="<+>"undefined"

    emptyCats = allcats `S.difference` cats
    cats = S.fromList [c|(Just c,_)<-defs]
    allcats = S.fromList [c|((_,c),AbsCat (Just _))<-allOrigInfos gr absname]
            
    params = S.toList . S.unions . map params1
    params1 (Nothing,(_,rhs)) = paramTypes gr rhs
    params1 (_,(_,rhs)) = tableTypes gr [rhs]

    ppDef (Nothing,(lhs,rhs)) = hang (lhs<+>"=") 4 (convType gId rhs)
    ppDef (_,(lhs,rhs)) = hang (lhs<+>"=") 4 (convert gId gr rhs)

    gId :: Ident -> Doc
    gId = if haskellOption opts HaskellNoPrefix then pp else  ("G"<>).pp

    neededParamTypes have [] = []
    neededParamTypes have (q:qs) =
        if q `S.member` have
        then neededParamTypes have qs
        else let ((got,need),def) = paramType gId gr q
             in def:neededParamTypes (S.union got have) (S.toList need++qs)

haskPreamble :: ModuleName -> ModuleName -> Doc
haskPreamble absname cncname =
  "{-# LANGUAGE MultiParamTypeClasses, FunctionalDependencies, FlexibleInstances, LambdaCase #-}" $$
  "module" <+> cncname <+> "where" $$
  "import Prelude hiding (Ordering(..))" $$
  "import Control.Applicative((<$>),(<*>))" $$
  "import qualified Data.Map as M" $$
  "import Data.Map((!))" $$
  "import qualified" <+> absname <+> "as A" $$
  "" $$
  "--- Standard definitions ---" $$
  "class EnumAll a where enumAll :: [a]" $$
  "type Str = [Tok] -- token sequence" $$
  "type Prefix = String -- to match with prefix of following token" $$
  "type Simple = [String] -- Simple token sequence" $$
  hang "data Tok = TK String | TP [([Prefix],Simple)] Simple" 4
       "deriving (Eq,Ord,Show)" $$
  "linString (A.GString s) = R_s [TK s]" $$
  "linInt (A.GInt i) = R_s [TK (show i)]" $$
  "linFloat (A.GFloat x) = R_s [TK (show x)]" $$
  "" $$
--"table is vs = let m = M.fromList (zip is vs) in (m!)" $$
  "table vs = let m = M.fromList (zip enumAll vs) in (m!)" $$
  "" $$
  "----------------------------------------------------" $$
  "-- Automatic translation from GF to Haskell follows" $$
  "----------------------------------------------------"

toHaskell gId gr absname cenv (name,jment) =
  case jment of
    CncCat (Just (L loc typ)) _ _ pprn _ ->
        [(Nothing,("type"<+>"Lin"<>name,nf loc typ))]
    CncFun (Just r@(cat,ctx,lincat)) (Just (L loc def)) pprn _ ->
--      trace (render (name<+>hcat[parens (x<>"::"<>t)|(_,x,t)<-ctx]<+>"::"<+>cat)) $
        [(Just cat,("lin"<>cat<+>lhs,coerce [] lincat rhs))]
      where
        Ok abstype = lookupFunType gr absname name
        (absctx,abscat,absargs) = typeForm abstype

        e' = unAbs (length params) $
             nf loc (mkAbs params (mkApp def (map Vr args)))
        params = [(b,prefixIdent "g" x)|(b,x,_)<-ctx]
        args = map snd params
        abs_args = map ("abs_"<>) args
        lhs = if null args then aId name else parens (aId name<+>hsep abs_args)
        rhs = foldr letlin e' (zip args absctx)
        letlin (a,(_,_,at)) =
           Let (a,(Just (con ("Lin"++render at)),(App (con ("lin"++render at)) (con ("abs_"++render a)))))
    AnyInd _ m  -> case lookupOrigInfo gr (m,name) of
                     Ok (m,jment) -> toHaskell gId gr absname cenv (name,jment)
                     _ -> []
    _ -> []
  where
    nf loc = normalForm cenv (L loc name)
    aId n = "A."<>gId n

    unAbs 0 t = t
    unAbs n (Abs _ _ t) = unAbs (n-1) t
    unAbs _ t = t


con = Cn . identS

tableTypes gr ts = S.unions (map tabtys ts)
  where
    tabtys t =
      case t of
        V t cc -> S.union (paramTypes gr t) (tableTypes gr cc)
        T (TTyped t) cs -> S.union (paramTypes gr t) (tableTypes gr (map snd cs))
        _ -> collectOp tabtys t

paramTypes gr t =
  case t of
    RecType fs -> S.unions (map (paramTypes gr.snd) fs)
    Table t1 t2 -> S.union (paramTypes gr t1) (paramTypes gr t2)
    App tf ta -> S.union (paramTypes gr tf) (paramTypes gr ta)
    Sort _ -> S.empty
    EInt _ -> S.empty
    Q q -> lookup q
    QC q -> lookup q
    FV ts -> S.unions (map (paramTypes gr) ts)
    _ -> ignore
  where
    lookup q = case lookupOrigInfo gr q of
                 Ok (_,ResOper  _ (Just (L _ t))) ->
                                       S.insert q (paramTypes gr t)
                 Ok (_,ResParam {}) -> S.singleton q
                 _ -> ignore

    ignore = trace ("Ignore: "++show t) S.empty



records ts = S.unions (map recs ts)
  where
    recs t =
      case t of
        R r -> S.insert (labels r) (records (map (snd.snd) r))
        RecType r -> S.insert (labels r) (records (map snd r))
        _ -> collectOp recs t

    labels = sort . filter (not . isLockLabel) . map fst


coerce env ty t =
  case (ty,t) of 
    (_,Let d t) -> Let d (coerce (extend env d) ty t)
    (_,FV ts) -> FV (map (coerce env ty) ts)
    (Table ti tv,V _ ts) -> V ti (map (coerce env tv) ts)
    (Table ti tv,T (TTyped _) cs) -> T (TTyped ti) (mapSnd (coerce env tv) cs)
    (RecType rt,R r) ->
      R [(l,(Just ft,coerce env ft f))|(l,(_,f))<-r,Just ft<-[lookup l rt]]
    (RecType rt,Vr x)->
      case lookup x env of
        Just ty' | ty'/=ty -> -- better to compare to normal form of ty'
          --trace ("coerce "++render ty'++" to "++render ty) $
          App (to_rcon (map fst rt)) t
        _ -> trace ("no coerce to "++render ty) t
    _ -> t
  where
    extend env (x,(Just ty,rhs)) = (x,ty):env
    extend env _ = env

convert gId = convert' False gId
convertA gId = convert' True gId

convert' atomic gId gr = if atomic then ppA else ppT
  where
    ppT = ppT' False
    ppT' loop t =
      case t of
        Let (x,(_,xt)) t -> sep ["let"<+>x<+>"="<+>ppT xt,"in"<+>ppT t]
        Abs b x t -> "\\"<+>x<+>"->"<+>ppT t
--      V ty ts -> hang "table" 4 (sep [list (enumAll ty),list ts])
        V ty ts -> hang "table" 4 (dedup ts)
        T (TTyped ty) cs -> hang "\\case" 2 (vcat (map ppCase cs))
        S t p -> hang (ppB t) 4 (ppA p)
        C t1 t2 -> hang (ppA t1<+>"++") 4 (ppA t2)
        _ -> ppB' loop t

    ppCase (p,t) = hang (ppP p <+> "->") 4 (ppT t)

    ppB = ppB' False
    ppB' loop t =
      case t of
        App f a -> ppB f<+>ppA a
        R r -> rcon (map fst r)<+>fsep (fields r)
        P t l -> ppB (proj l)<+>ppA t
        FV [] -> "error"<+>doubleQuotes "empty variant"
        _ -> ppA' loop t

    ppA = ppA' False

    ppA' True t = error $ "Missing case in convert': "++show t
    ppA' loop t =
      case t of
        Vr x -> pp x
        Cn x -> pp x
        Con c -> gId c
        Sort k -> pp k
        EInt n -> pp n
        Q (m,n) -> if m==cPredef
                   then ppPredef token n
                   else pp (qual m n)
        QC (m,n) -> gId (qual m n)
        K s -> token s
        Empty -> pp "[]"
        FV (t:ts) -> "{-variants-}"<>ppA t -- !!
        Alts t' vs -> alts t' vs
        _ -> parens (ppT' True t)

    ppPredef tok n =
      case predef n of
        Ok BIND -> tok "&+"
        Ok SOFT_BIND -> tok "SOFT_BIND" -- hmm
        Ok CAPIT -> tok "CAPIT" -- hmm
        _ -> pp n

    ppP p =
      case p of
        PC c ps -> gId c<+>fsep (map ppAP ps)
        PP (_,c) ps -> gId c<+>fsep (map ppAP ps)
        PR r -> rcon (map fst r)<+>fsep (map (ppAP.snd) (filter (not.isLockLabel.fst) r))
        _ -> ppAP p

    ppAP p =
      case p of
        PW -> pp "_"
        PV x -> pp x
        PString s -> doubleQuotes s
        PInt i -> pp i
        PFloat x -> pp x
        PT _ p -> ppAP p
        PAs x p -> x<>"@"<>ppAP p
        _ -> parens (ppAP p)
        
    token s = brackets ("TK"<+>doubleQuotes s)

    alts t' vs = brackets ("TP" <+> list' (map alt vs) <+> simple t')
      where
        alt (t,p) = parens (show (pre p)<>","<>simple t)

        simple (K s) = brackets (doubleQuotes s)
        simple (C t1 t2) = parens (simple t1 <+>"++"<+>simple t2)
        simple (Q (m,n)) = if m==cPredef
                           then ppPredef simp n
                           else pp (qual m n) -- hmm !!
        simp op = brackets (doubleQuotes op)

        pre (K s) = [s]
        pre (Strs ts) = concatMap pre ts
        pre (EPatt p) = pat p
        pre t = error $ "pre "++show t

        pat (PString s) = [s]
        pat (PAlt p1 p2) = pat p1++pat p2
        pat p = error $ "pat "++show p

    fields = map (ppA.snd.snd) . sort . filter (not.isLockLabel.fst)

--  enumAll ty = case allParamValues gr ty of Ok ts -> ts

    list = brackets . fsep . punctuate "," . map ppT
    list' = brackets . fsep . punctuate ","

    dedup ts =
        if M.null dups
        then list ts
        else parens $
             "let"<+>vcat [ev i<+>"="<+>ppT t|(i,t)<-defs] $$
             "in"<+>list' (zipWith entry ts is)
      where
        entry t i = maybe (ppT t) ev (M.lookup i dups)
        ev i = "e'"<>i

        defs = [(i1,t)|(t,i1:_:_)<-ms]
        dups = M.fromList [(i2,i1)|(_,i1:is@(_:_))<-ms,i2<-i1:is]
        ms = M.toList m
        m = fmap sort (M.fromListWith (++) (zip ts [[i]|i<-is]))
        is = [0..]::[Int]

convType = convType' False
convTypeA = convType' True

convType' atomic gId = if atomic then ppA else ppT
  where
    ppT = ppT' False
    ppT' loop t =
      case t of
        Table ti tv -> ppB ti <+> "->" <+> ppT tv
        _ -> ppB' loop t

    ppB = ppB' False
    ppB' loop t =
      case t of
        RecType rt -> rcon (map fst rt)<+>fsep (fields rt)
        App tf ta -> ppB tf <+> ppA ta
        FV [] -> pp "({-empty variant-})"
        _ -> ppA' loop t

    ppA = ppA' False
    ppA' True t = error $ "Missing case in convType for: "++show t
    ppA' loop t =
      case t of
        Sort k -> pp k
        EInt n -> parens ("{-"<>n<>"-}") -- type level numeric literal
        FV (t:ts) -> "{-variants-}"<>ppA t -- !!
        QC (m,n) -> gId (qual m n)
        Q (m,n) -> gId (qual m n)
        _ -> {-trace (show t) $-} parens (ppT' True t)

    fields = map (ppA.snd) . sort . filter (not.isLockLabel.fst)

proj l = con ("proj_"++render l)
rcon = con . rcon_name
rcon_name ls = "R"++concat (sort ['_':render l|l<-ls,not (isLockLabel l)])
to_rcon = con . ("to_"++) . rcon_name

recordType ls =
    "data"<+>app<+>"="<+>app <+> "deriving (Eq,Ord,Show)" $$
    enumAllInstance $$
    vcat (zipWith projection vs ls) $$
    to_rcon ls<+>"r"<+>"="<+>cn<+>fsep [parens (proj l<+>"r")|l<-ls] $$ ""
  where
    cn = rcon ls
 -- Not all record labels are syntactically correct as type variables in Haskell
 -- app = cn<+>ls
    app = cn<+>hsep vs -- don't reuse record labels
    vs = ["t"<>i|i<-[1..n]]
    n = length ls

    projection v l =
       hang ("instance"<+>"Has_"<>l<+>parens app<+>v<+>"where") 4
            (proj l<+>parens app<+>"="<+>v)

    enumAllInstance =
       hang ("instance"<+>ctx<+>"EnumAll"<+>parens app<+>"where") 4
            ("enumAll"<+>"="<+>enumCon cn n)
      where
        ctx = if n==0
              then empty
              else parens (fsep (punctuate "," ["EnumAll"<+>v|v<-vs]))<+>"=>"

labelClass l =
    hang ("class"<+>"Has_"<>l<+>"r"<+>"a"<+>"| r -> a"<+>"where") 4
         (proj l<+>"::"<+>"r -> a")

paramType gId gr q@(_,n) =
    case lookupOrigInfo gr q of
      Ok (m,ResParam (Just (L _ ps)) _)
       {- - | m/=cPredef && m/=moduleNameS "Prelude"-} ->
         ((S.singleton (m,n),argTypes ps),
          "data"<+>gId (qual m n)<+>"="<+>
               sep [fsep (punctuate " |" (map (param m) ps)),
                    pp "deriving (Eq,Ord,Show)"] $$
          hang ("instance EnumAll"<+>gId (qual m n)<+>"where") 4
               ("enumAll"<+>"="<+>sep (punctuate " ++" (map (enumParam m) ps)))
         )
      Ok (m,ResOper  _ (Just (L _ t)))
        | m==cPredef && n==cInts ->
           ((S.singleton (m,n),S.empty),
            "type"<+>gId (qual m n)<+>"n = Int")
        | otherwise ->
           ((S.singleton (m,n),paramTypes gr t),
            "type"<+>gId (qual m n)<+>"="<+>convType gId t)
      _ -> ((S.empty,S.empty),empty)
  where
    param m (n,ctx) = gId (qual m n)<+>[convTypeA gId t|(_,_,t)<-ctx]
    argTypes = S.unions . map argTypes1
    argTypes1 (n,ctx) = S.unions [paramTypes gr t|(_,_,t)<-ctx]

    enumParam m (n,ctx) = enumCon (gId (qual m n)) (length ctx)

enumCon name arity =
    if arity==0
    then brackets name
    else parens $
         fsep ((name<+>"<$>"):punctuate " <*>" (replicate arity (pp "enumAll")))

qual :: ModuleName -> Ident -> Ident
qual m = prefixIdent (render m++"_")
