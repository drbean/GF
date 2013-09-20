instance LexCandidateEng of LexCandidate = open SyntaxEng, ParadigmsEng, Prelude, IrregEng in {

oper
	ambitious_A	= mkA "ambitious";
	bad_A	= mkA "bad";
	competitive_A	= mkA "competitive";
	confident_A	= mkA "confident";
	difficult_A	= mkA "difficult";
	each_A	= mkA "each";
	fast_A	= mkA "fast";
	few_A	= mkA "few";
	five_A	= mkA "five";
	good_A	= mkA "good";
	hard_A	= mkA "hard";
	honest_A	= mkA "honest";
	local_A	= mkA "local";
	long_A	= mkA "long";
	next_A	= mkA "next";
	other_A	= mkA "other";
	outgoing_A	= mkA "outgoing";
	past_A	= mkA "past";
	patient_A	= mkA "patient";
	polish_A	= mkA "Polish";
	poor_A	= mkA "poor";
	possible_A	= mkA "possible";
	realistic_A	= mkA "realistic";
	safe_A	= mkA "safe";
	successful_A	= mkA "successful";
	true_A	= mkA "true";
	unable_A	= mkA "unable";
	various_A	= mkA "various";

	a_Det	= aSg_Det;
	the_Det	= theSg_Det;

	ability_N	= mkN "ability";
	administration_N	= mkN "administration" nonExist;
	aim_N	= mkN "aim";
	business_club_N	= mkN "business" (mkN "club");
	company_N	= mkN "company";
	training_course_N	= mkN "training" course_N;
	course_N	= mkN "course";
	sales_department_N	= mkN "sales" (mkN "department");
	director_N	= mkN "director";
	effort_N	= mkN "effort";
	sales_experience_N	= mkN "sales" experience_N;
	experience_N	= mkN "experience" nonExist;
	hand_N	= mkN "hand";
	head_N	= mkN "head";
	job_N	= mkN "job";
	judgement_N	= mkN "judgement";
	learner_N	= mkN "learner";
	lot_N	= mkN "lot";
	main_N	= mkN "main";
	market_N	= mkN "market";
	material_N	= mkN "material";
	pair_N	= mkN "pair";
	person_N	= mkN "person" "people";
	personality_N	= mkN "personality";
	respect_N	= mkN "respect";
	result_N	= mkN "result";
	risk_N	= mkN "risk";
	sales_person_N	= mkN "sales" person_N;
	share_N	= mkN "share";
	system_N	= mkN "system";
	sales_team_N	= mkN "sales" team_N;
	team_N	= mkN "team";
	term_N	= mkN "term";
	thing_N	= mkN "thing";
	time_N	= mkN "time";
	top_N	= mkN "top";
	way_N	= mkN "way";
	year_N	= mkN "year";

	barbara_PN	= mkPN "Barbara";
	dr_bean_PN	= mkPN "Dr Bean";
	eva_PN	= mkPN "Eva";
	fast_track_PN	= mkPN "Fast-Track";
	tadeusz_PN	= mkPN "Tadeusz";

	allow_V2V	= mkV2V (mkV "allow") noPrep to_Prep;
	apply_V2	= mkV2 "apply" "for";
	can_VV	= SyntaxEng.can_VV;
	become_V2	= mkV2 (mkV "become");
	choose_V2	= mkV2 "choose";
	enjoy_V2	= mkV2 "enjoy";
	expand_V	= mkV "expand";
	feel_VS	= mkVS (mkV "feel");
	improve_V2	= mkV2 "improve";
	increase_V2	= mkV2 "increase";
	go_V	= IrregEng.go_V;
	have_V2	= mkV2 (IrregEng.have_V);
	help_V2	= mkV2 "help";
	know_VS	= mkVS know_V;
	lead_V2	= mkV2 "lead";
	must_VV	= SyntaxEng.must_VV;
	think_VS	= mkVS (mkV "think");
	want_VV	= SyntaxEng.want_VV;

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
