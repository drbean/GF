abstract Candidate = Cat -[S] ** {

  cat
    Quality ;
    Kind;
    Item;
    Act;
    Act_on;
    Att;
    Act_on_to;
    Express;
    Predicate;
    Event;

  flags startcat = Event ;

fun
	Is :	Item -> Quality -> Event;
	Happening :	Act -> Predicate ;
	Changing :	Act_on -> Item -> Predicate;
	Causative:	Act_on_to -> Item -> Predicate -> Predicate;
	Intens:	Att -> Predicate -> Predicate;
	Positing:	Express -> Event -> Predicate;
	S :	Item -> Predicate -> Event;

	An :	Kind -> Item;
	The :	Kind -> Item;
	QKind :	Quality -> Kind -> Kind;
	Very :	Quality -> Quality;

	ambitious :	Quality;
	bad :	Quality;
	competitive :	Quality;
	confident :	Quality;
	difficult :	Quality;
	each :	Quality;
	fast :	Quality;
	few :	Quality;
	five :	Quality;
	good :	Quality;
	hard :	Quality;
	honest :	Quality;
	local :	Quality;
	long :	Quality;
	next :	Quality;
	other :	Quality;
	outgoing :	Quality;
	past :	Quality;
	patient :	Quality;
	polish :	Quality;
	poor :	Quality;
	possible :	Quality;
	realistic :	Quality;
	safe :	Quality;
	successful :	Quality;
	true :	Quality;
	unable :	Quality;
	various :	Quality;

	ability :	Kind;
	administration :	Kind;
	aim :	Kind;
	business_club :	Kind;
	company :	Kind;
	training_course :	Kind;
	course :	Kind;
	sales_department :	Kind;
	director :	Kind;
	effort :	Kind;
	sales_experience :	Kind;
	experience :	Kind;
	hand :	Kind;
	head :	Kind;
	job :	Kind;
	judgement :	Kind;
	learner :	Kind;
	lot :	Kind;
	main :	Kind;
	market :	Kind;
	material :	Kind;
	pair :	Kind;
	person :	Kind;
	personality :	Kind;
	respect :	Kind;
	result :	Kind;
	risk :	Kind;
	sales_person :	Kind;
	share :	Kind;
	system :	Kind;
	sales_team :	Kind;
	team :	Kind;
	term :	Kind;
	thing :	Kind;
	time :	Kind;
	top :	Kind;
	way :	Kind;
	year :	Kind;

	barbara :	Item;
	dr_bean :	Item;
	eva :	Item;
	fast_track :	Item;
	tadeusz :	Item;

	allow :	Act_on_to;
	apply :	Act_on;
	become :	Act_on;
	can :	Att;
	choose :	Act_on;
	enjoy :	Act_on;
	expand :	Act;
	go :	Act;
	feel :	Express;
	have :	Act_on;
	help :	Act_on;
	improve :	Act_on;
	increase :	Act_on;
	lead :	Act_on;
	know :	Express;
	must :	Att;
	think :	Express;
	want_NP_to :	Act_on_to;
	want_to :	Att;

}

---- adv
--although_Adv = mkAdv "although";
--always_AdV = mkAdv "always";
--especially_Adv = mkAdv "especially";
--frankly_Adv = mkAdv "frankly";
--really_AdV = mkAdv "really";
--slowly_Adv = mkAdv "slowly";
-- soon :	Quality;
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
