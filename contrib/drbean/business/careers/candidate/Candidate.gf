abstract Candidate = Cat -[S] ** {


  flags startcat = Cl ;

fun
	Is :	NP -> AP -> Cl;
	Happening :	V -> VP ;
	Changing :	V2 -> NP -> VP;
	Causative:	V2V -> NP -> VP -> VP;
	Intens:	VV -> VP -> VP;
	Positing:	VS -> Cl -> VP;
	S :	NP -> VP -> Cl;
	-- PN2NP:	PN -> NP;
	-- Str2PN:	Str -> PN_;

	-- An :	CN -> NP;
	-- The :	CN -> NP;
	-- QCN :	AP -> CN -> CN;
	Very :	AP -> AP;

	ambitious :	AP;
	bad :	AP;
	competitive :	AP;
	confident :	AP;
	difficult :	AP;
	each :	AP;
	fast :	AP;
	few :	AP;
	five :	AP;
	good :	AP;
	hard :	AP;
	honest :	AP;
	local :	AP;
	long :	AP;
	next :	AP;
	other :	AP;
	outgoing :	AP;
	past :	AP;
	patient :	AP;
	polish :	AP;
	poor :	AP;
	possible :	AP;
	realistic :	AP;
	safe :	AP;
	successful :	AP;
	true :	AP;
	unable :	AP;
	various :	AP;

	ability :	CN;
	administration :	CN;
	aim :	CN;
	business_club :	CN;
	company :	CN;
	training_course :	CN;
	course :	CN;
	sales_department :	CN;
	director :	CN;
	effort :	CN;
	sales_experience :	CN;
	experience :	CN;
	hand :	CN;
	head :	CN;
	job :	CN;
	judgement :	CN;
	learner :	CN;
	lot :	CN;
	main :	CN;
	market :	CN;
	material :	CN;
	pair :	CN;
	person :	CN;
	personality :	CN;
	respect :	CN;
	result :	CN;
	risk :	CN;
	sales_person :	CN;
	share :	CN;
	system :	CN;
	sales_team :	CN;
	team :	CN;
	term :	CN;
	thing :	CN;
	time :	CN;
	top :	CN;
	way :	CN;
	year :	CN;

	barbara :	NP;
	dr_bean :	NP;
	eva :	NP;
	fast_track :	NP;
	tadeusz :	NP;

	allow :	V2V;
	apply :	V2;
	become :	V2;
	can :	VV;
	choose :	V2;
	enjoy :	V2;
	expand :	V;
	go :	V;
	feel :	VS;
	have :	V2;
	help :	V2;
	improve :	V2;
	increase :	V2;
	lead :	V2;
	know :	VS;
	must :	VV;
	think :	VS;
	want_NP_to :	V2V;
	want_to :	VV;

}

---- adv
--although_Adv = mkAdv "although";
--always_AdV = mkAdv "always";
--especially_Adv = mkAdv "especially";
--frankly_Adv = mkAdv "frankly";
--really_AdV = mkAdv "really";
--slowly_Adv = mkAdv "slowly";
-- soon :	AP;
--too_Adv = mkAdv "too";
--very_AdA = mkAdA "very";
--well_AdA = mkAdA "well";
--wherever_Adv = mkAdv "wherever";

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
--
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
