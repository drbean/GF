concrete CandidateEng of Candidate = CatEng -[S] **
  open SyntaxEng, ParadigmsEng, IrregEng, Prelude in {

-- lincat Quality, Kind, Phrase = {s : Str} ;
lincat
	Event	= Cl;
	Item	= NP;
	Quality	= AP;
	Kind	= CN;
	Act	= V;
	Act_on	= V2;
	Act_on_to	= V2V;
	Att	= VV;
	Express	= VS;
	Predicate	= VP;
lin
	Is item quality =	mkCl item quality;
	Happening action =	mkVP action;
	Changing action patient =	mkVP action patient;
	Causative causal patient predicate =	mkVP causal patient predicate;
	Intens predicate	= mkVP predicate;
	Positing posit event =	mkVP posit (mkS event);
	S subject predicate = mkCl subject predicate;

	An kind =	mkNP a_Det kind ;
	The kind =	mkNP the_Det kind ;
	QKind quality kind =	mkCN quality kind ;
	Very quality =	mkAP very_AdA quality ;


	ambitious =	mkAP (mkA "ambitious");
	bad =	mkAP (mkA "bad");
	competitive =	mkAP (mkA "competitive");
	confident =	mkAP (mkA "confident");
	difficult =	mkAP (mkA "difficult");
	each =	mkAP (mkA "each");
	fast =	mkAP (mkA "fast");
	few =	mkAP (mkA "few");
	five =	mkAP (mkA "five");
	good =	mkAP (mkA "good");
	hard =	mkAP (mkA "hard");
	honest =	mkAP (mkA "honest");
	local =	mkAP (mkA "local");
	long =	mkAP (mkA "long");
	next =	mkAP (mkA "next");
	other =	mkAP (mkA "other");
	outgoing =	mkAP (mkA "outgoing");
	past =	mkAP (mkA "past");
	patient =	mkAP (mkA "patient");
	polish =	mkAP (mkA "Polish");
	poor =	mkAP (mkA "poor");
	possible =	mkAP (mkA "possible");
	realistic =	mkAP (mkA "realistic");
	safe =	mkAP (mkA "safe");
	successful =	mkAP (mkA "successful");
	true =	mkAP (mkA "true");
	unable =	mkAP (mkA "unable");
	various =	mkAP (mkA "various");

	ability =	mkCN (mkN "ability");
	administration =	mkCN (mkN "administration");
	aim =	mkCN (mkN "aim");
	business_club =	mkCN (mkN "business" (mkN "club"));
	-- club =	mkCN (mkN "club");
	company =	mkCN (mkN "company");
	training_course =	mkCN (mkN "training" course);
	course =	mkCN (mkN "course");
	sales_department =	mkCN (mkN "sales" (mkN "department"));
	director =	mkCN (mkN "director");
	effort =	mkCN (mkN "effort");
	sales_experience =	mkCN (mkN "sales" experience);
	experience =	mkCN (mkN "experience");
	hand =	mkCN (mkN "hand");
	head =	mkCN (mkN "head");
	job =	mkCN (mkN "job");
	judgement =	mkCN (mkN "judgement");
	learner =	mkCN (mkN "learner");
	lot =	mkCN (mkN "lot");
	main =	mkCN (mkN "main");
	market =	mkCN (mkN "market");
	material =	mkCN (mkN "material");
	pair =	mkCN (mkN "pair");
	person =	mkCN (mkN "person" "people");
	personality =	mkCN (mkN "personality");
	respect =	mkCN (mkN "respect");
	result =	mkCN (mkN "result");
	risk =	mkCN (mkN "risk");
	sales_person =	mkCN (mkN "sales" person);
	share =	mkCN (mkN "share");
	system =	mkCN (mkN "system");
	sales_team =	mkCN (mkN "sales" team);
	team =	mkCN (mkN "team");
	term =	mkCN (mkN "term");
	thing =	mkCN (mkN "thing");
	time =	mkCN (mkN "time");
	top =	mkCN (mkN "top");
	way =	mkCN (mkN "way");
	year =	mkCN (mkN "year");

	barbara =	mkNP (mkPN "Barbara");
	dr_bean =	(mkPN "Dr Bean");
	eva =	mkNP (mkPN "Eva");
	fast_track =	mkNP (mkPN "Fast-Track");
	tadeusz =	mkNP (mkPN "Tadeusz");

	allow =	mkV2V (mkV "allow") noPrep to_Prep;
	apply =	mkV2 "apply" "for";
	can =	can_VV;
	become =	mkV2 "become";
	choose =	mkV2 "choose";
	enjoy =	mkV2 "enjoy";
	expand =	mkV "expand";
	feel =	mkVS (mkV "feel");
	improve =	mkV2 "improve";
	increase =	mkV2 "increase";
	go =	go_V;
	have =	mkV2 have_V;
	help =	mkV2 (mkV "help");
	know =	mkVS know_V;
	lead =	mkV2 lead_V;
	must =	must_VV;
	think =	mkVS (mkV "think");
	want_NP_to =	mkV2V (mkV "want") noPrep to_Prep;
	want_to =	want_VV;

--get_V = mkV "get"
--motivate_V = mkV "motivate"
--offer_V = mkV "offer"
--organize_V = mkV "organize"
--say_V = mkV "say"
--see_V = mkV "see"
--sell_V = mkV "sell"
--set_V = mkV "set"
--start_V = mkV "start"
--take_V = mkV "take"
--tell_V = mkV "tell"
--try_V = mkV "try"
--win_V = mkV "win"
--work_V = mkV "work"

	--although_Adv = mkAdv "although";
	--always_AdV = mkAdv "always";
	--especially_Adv = mkAdv "especially";
	--frankly_Adv = mkAdv "frankly";
	--really_AdV = mkAdv "really";
	--slowly_Adv = mkAdv "slowly";
	--soon =	mkAP (mkA "soon");
	--too_Adv = mkAdv "too";
	--well_AdA = mkAdA "well";
	--wherever_Adv = mkAdv "wherever";

}

---- -- and
---- -- any
---- -- as
---- -- be
---- -- because
---- -- but
---- -- But
---- -- by
---- -- did
---- -- do
---- -- don't
---- -- during
---- -- enjoyed
---- -- Everyone
---- -- for
---- -- I
---- -- I'd
---- -- if
---- -- If
---- -- I'll
---- -- I'm
---- -- in
---- -- it
---- -- it's
---- -- I've
---- -- like
---- -- many
---- -- Maybe
---- -- me
---- -- much
---- -- must
---- -- my
---- -- myself
---- -- not
---- -- of
---- -- on
---- -- or
---- -- Or
---- -- our
---- -- over
---- -- People
---- -- perhaps
---- -- should
---- -- so
---- -- That
---- -- that's
---- -- the
---- -- their
---- -- them
---- -- they
---- -- this
---- -- to
---- -- up
---- -- was
---- -- we
---- -- we'll
---- -- were
---- -- We're
---- -- what
---- -- What's
---- -- why
---- -- with
---- -- won't
---- -- worked
---- -- working
---- -- would
---- -- years
---- -- you
