incomplete concrete CandidateI of Candidate = open Syntax, LexCandidate in {

lincat
	NP	= Syntax.NP;
	AP	= Syntax.AP;
	Cl	= Syntax.Cl;
	V	= Syntax.V; 
	VP	= Syntax.VP; 
	V2	= Syntax.V2; 
	V2V	= Syntax.V2V;
	VV	= Syntax.VV;
	VS	= Syntax.VS;
	Det	= Syntax.Det;
 	CN	= Syntax.CN;

lin
	Is item quality	=	mkCl item quality;
	Cop item1 item2	= mkCl item1 item2;
	Happening action	=	mkVP action;
	Changing action patient	= mkVP action patient;
	Causative causal patient predicate	= mkVP causal patient predicate;
	Intens attitude predicate	= mkVP attitude predicate;
	Positing posit event	= mkVP posit (mkS event);
	UttS subject predicate	= mkCl subject predicate;
	-- Item det noun	= ConstructorsEng.mkNP det noun;
	Item det noun	= mkNP det noun;

	-- An kind	= mkNP aSg_Det kind ;
	-- The kind	= mkNP the_Det kind ;
	-- QCN quality kind	= mkCN quality kind ;
	-- Very quality	= mkAP very_AdA quality ;


	ambitious	= mkAP ambitious_A;
	bad	= mkAP bad_A;
	competitive	= mkAP competitive_A;
	confident	= mkAP confident_A;
	difficult	= mkAP difficult_A;
	each	= mkAP each_A;
	fast	= mkAP fast_A;
	few	= mkAP few_A;
	five	= mkAP five_A;
	good	= mkAP good_A;
	hard	= mkAP hard_A;
	honest	= mkAP honest_A;
	local	= mkAP local_A;
	long	= mkAP long_A;
	next	= mkAP next_A;
	other	= mkAP other_A;
	outgoing	= mkAP outgoing_A;
	past	= mkAP past_A;
	patient	= mkAP patient_A;
	polish	= mkAP polish_A;
	poor	= mkAP poor_A;
	possible	= mkAP possible_A;
	realistic	= mkAP realistic_A;
	safe	= mkAP safe_A;
	successful	= mkAP successful_A;
	true	= mkAP true_A;
	unable	= mkAP unable_A;
	various	= mkAP various_A;

	a_Det = a_Det;
	the_Det = the_Det;

	ability	= mkCN ability_N;
	administration	= mkCN administration_N;
	aim	= mkCN aim_N;
	business_club	= mkCN business_club_N;
	company	= mkCN company_N;
	training_course	= training_course_N;
	course	= mkCN course_N;
	sales_department	= mkCN sales_department_N;
	director	= mkCN director_N;
	effort	= mkCN effort_N;
	sales_experience	= mkCN sales_experience_N;
	experience	= mkCN experience_N;
	hand	= mkCN hand_N;
	head	= mkCN head_N;
	job	= mkCN job_N;
	judgement	= mkCN judgement_N;
	learner	= mkCN learner_N;
	lot	= mkCN lot_N;
	main	= mkCN main_N;
	market	= mkCN market_N;
	material	= mkCN material_N;
	pair	= mkCN pair_N;
	person	= mkCN person_N;
	personality	= mkCN personality_N;
	respect	= mkCN respect_N;
	result	= mkCN result_N;
	risk	= mkCN risk_N;
	sales_person	= mkCN sales_person_N;
	share	= mkCN share_N;
	system	= mkCN system_N;
	sales_team	= mkCN sales_team_N;
	team	= mkCN team_N;
	term	= mkCN term_N;
	thing	= mkCN thing_N;
	time	= mkCN time_N;
	top	= mkCN top_N;
	way	= mkCN way_N;
	year	= mkCN year_N;

	barbara	= mkNP barbara_PN;
	dr_bean	= mkNP dr_bean_PN;
	eva	= mkNP eva_PN;
	fast_track	= mkNP fast_track_PN;
	tadeusz	= mkNP tadeusz_PN;

	allow	= allow_V2V;
	apply	= apply_V2;
	become	= become_V2;
	choose	= choose_V2;
	can	= can_VV;
	enjoy	= enjoy_V2;
	expand	= expand_V;
	feel	= feel_VS;
	go	= go_V;
	have	= have_V2;
	help	= help_V2;
	improve	= improve_V2;
	increase	= increase_V2;
	know	= know_VS;
	lead	= lead_V2;
	must	= must_VV;
	think	= think_VS;
	want	= want_VV;
	---- want_NP_to	= mkVP want_V;
	---- want_to	= want_VV;

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
	--soon	= mkAP (mkA "soon");
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
