concrete FromCoreRgl of Dictionary = CatEng **    -- change Eng to your language
  open
    (S = StructuralEng), (L = LexiconEng), ParadigmsEng  -- the standard imports in Dictionary 
  in {

-- AR 11/11/2015
-- to bootstrap Dictionary from Structural and Lexicon
-- some functions renamed, split senses expanded with comment

lin above_Prep = S.above_Prep ;
lin after_Prep = S.after_Prep ;
lin all_Predet = S.all_Predet ;
lin almost_AdA = S.almost_AdA ;
lin almost_AdN = S.almost_AdN ;
lin although_Subj = S.although_Subj ;
lin always_AdV = S.always_AdV ;
lin and_Conj = S.and_Conj ;
--lin as_CAdv = S.as_CAdv ;
lin at_least_AdN = S.at_least_AdN ;
--lin at_most_AdN = S.at_most_AdN ;
lin because_Subj = S.because_Subj ;
lin before_Prep = S.before_Prep ;
lin behind_Prep = S.behind_Prep ;
lin between_Prep = S.between_Prep ;
lin both7and_DConj = S.both7and_DConj ;
lin but_PConj = S.but_PConj ;
--lin by8agent_Prep = S.by8agent_Prep ;
--lin by8means_Prep = S.by8means_Prep ;
lin by_Prep = S.by8means_Prep ; ---- split?
lin can_2_VV = S.can8know_VV ;
lin can_1_VV = S.can_VV ;
lin during_Prep = S.during_Prep ;
lin either7or_DConj = S.either7or_DConj ;
lin every_Det = S.every_Det ;
lin everybody_NP = S.everybody_NP ;
lin everything_NP = S.everything_NP ;
lin everywhere_Adv = S.everywhere_Adv ;
lin except_Prep = S.except_Prep ;
lin few_Det = S.few_Det ;
lin for_Prep = S.for_Prep ;
lin from_Prep = S.from_Prep ;
lin have_V2 = S.have_V2 ;
lin he_Pron = S.he_Pron ;
--lin here7from_Adv = S.here7from_Adv ;
--lin here7to_Adv = S.here7to_Adv ;
lin here_Adv = S.here_Adv ;
lin how8many_IDet = S.how8many_IDet ;
--lin how8much_IAdv = S.how8much_IAdv ;
lin how_IAdv = S.how_IAdv ;
lin i_Pron = S.i_Pron ;
lin iFem_Pron = S.i_Pron ; ---- to check
lin if_Subj = S.if_Subj ;
--lin if_then_Conj = S.if_then_Conj ; -- not to be kept in Dictionary
lin in_front_of_Prep = S.in8front_Prep ;
lin in_Prep = S.in_Prep ;
lin it_Pron = S.it_Pron ;
--lin language_title_Utt = S.language_title_Utt ; -- not to be kept in Dictionary
lin less_Adv = S.less_CAdv ; ---- to check
lin many_Det = S.many_Det ;
lin more_Adv = S.more_CAdv ; ---- to check
--lin most_Predet = S.most_Predet ; -- most_Det in Dictionary
lin much_Det = S.much_Det ;
lin must_VV = S.must_VV ;
lin no_Quant = S.no_Quant ;
--lin no_Utt = S.no_Utt ;
lin nobody_NP = S.nobody_NP ;
--lin not_Predet = S.not_Predet ;
lin nothing_NP = S.nothing_NP ;
lin on_Prep = S.on_Prep ;
lin only_Predet = S.only_Predet ;
lin or_Conj = S.or_Conj ;
lin otherwise_Adv = S.otherwise_PConj ; ---- to check
--lin part_Prep = S.part_Prep ;
lin please_Adv = lin Adv S.please_Voc ; ---- to check
lin of_Prep = S.possess_Prep ;
lin quite_Adv = S.quite_Adv ;
lin she_Pron = S.she_Pron ;
lin so_AdA = S.so_AdA ;
--lin somePl_Det = S.somePl_Det ; ---- some_Quant is in Dictionary
lin some_Det = S.someSg_Det ; ---- to check
lin somebody_NP = S.somebody_NP ;
lin something_NP = S.something_NP ;
lin somewhere_Adv = S.somewhere_Adv ;
lin that_Quant = S.that_Quant ;
lin that_Subj = S.that_Subj ;
--lin there7from_Adv = S.there7from_Adv ;
--lin there7to_Adv = S.there7to_Adv ;
lin there_Adv = S.there_Adv ;
lin therefore_Adv = lin Adv S.therefore_PConj ; ---- to check
lin they_Pron = S.they_Pron ;
lin theyFem_Pron = S.they_Pron ; ---- to check
lin this_Quant = S.this_Quant ;
lin through_Prep = S.through_Prep ;
lin to_Prep = S.to_Prep ;
lin too_AdA = S.too_AdA ;
lin under_Prep = S.under_Prep ;
lin very_AdA = S.very_AdA ;
lin want_VV = S.want_VV ;
lin we_Pron = S.we_Pron ;
lin weFem_Pron = S.we_Pron ; ---- to check
lin whatPl_IP = S.whatPl_IP ;
lin whatSg_IP = S.whatSg_IP ;
lin when_IAdv = S.when_IAdv ;
lin when_Subj = S.when_Subj ;
lin where_IAdv = S.where_IAdv ;
lin which_IQuant = S.which_IQuant ;
lin whoPl_IP = S.whoPl_IP ;
lin whoSg_IP = S.whoSg_IP ;
lin why_IAdv = S.why_IAdv ;
lin with_Prep = S.with_Prep ;
lin without_Prep = S.without_Prep ;
lin yes_Interj = lin Interj S.yes_Utt ;
lin youPl_Pron = S.youPl_Pron ;
lin youPlFem_Pron = S.youPl_Pron ; ---- to check
lin youPol_Pron = S.youPol_Pron ;
lin youPolFem_Pron = S.youPol_Pron ; ---- to check
lin youSg_Pron = S.youSg_Pron ;
lin youSgFem_Pron = S.youSg_Pron ; ---- to check
--lin add_V3 = L.add_V3 ;
lin add_V2 = lin V2 L.add_V3 ; ---- to check
lin airplane_N = L.airplane_N ;
lin alas_Interj = L.alas_Interj ;
lin already_Adv = L.already_Adv ;
lin animal_N = L.animal_N ;
--lin answer_V2S = L.answer_V2S ;
lin answer_V = lin V L.answer_V2S ;
lin answer_V2 = lin V2 L.answer_V2S ;
lin apartment_N = L.apartment_N ;
lin apple_N = L.apple_N ;
lin art_N = L.art_N ;
lin ash_N = L.ashes_N ; ---- to check
--lin ask_V2Q = L.ask_V2Q ;
lin ask_VQ = lin VQ L.ask_V2Q ;
lin ask_V2 = lin V2 L.ask_V2Q ;
lin baby_N = L.baby_N ;
lin back_N = L.back_N ;
lin bad_A = L.bad_A ;
lin bank_N = L.bank_N ;
lin bark_N = L.bark_N ;
lin beautiful_A = L.beautiful_A ;
lin become_VA = L.become_VA ;
lin beer_N = L.beer_N ;
--lin beg_V2V = L.beg_V2V ;
lin beg_V2 = lin V2 L.beg_V2V ; ---- to check
lin belly_N = L.belly_N ;
lin big_A = L.big_A ;
lin bike_N = L.bike_N ;
lin bird_N = L.bird_N ;
lin bite_V2 = L.bite_V2 ;
lin black_A = L.black_A ;
lin blood_N = L.blood_N ;
lin blow_V = L.blow_V ;
lin blue_A = L.blue_A ;
lin boat_N = L.boat_N ;
lin bone_N = L.bone_N ;
lin book_N = L.book_N ;
lin boot_N = L.boot_N ;
lin boss_N = L.boss_N ;
lin boy_N = L.boy_N ;
lin bread_N = L.bread_N ;
lin break_V2 = L.break_V2 ;
lin breast_N = L.breast_N ;
lin breathe_V = L.breathe_V ;
lin broad_A = L.broad_A ;
--lin brother_N2 = L.brother_N2 ;
lin brother_N = lin N L.brother_N2 ;
lin brown_A = L.brown_A ;
lin burn_V = L.burn_V ;
lin butter_N = L.butter_N ;
lin buy_V2 = L.buy_V2 ;
lin camera_N = L.camera_N ;
lin cap_N = L.cap_N ;
lin car_N = L.car_N ;
lin carpet_N = L.carpet_N ;
lin cat_N = L.cat_N ;
lin ceiling_N = L.ceiling_N ;
lin chair_N = L.chair_N ;
lin cheese_N = L.cheese_N ;
lin child_N = L.child_N ;
lin church_N = L.church_N ;
lin city_N = L.city_N ;
lin clean_A = L.clean_A ;
lin clever_A = L.clever_A ;
lin close_V2 = L.close_V2 ;
lin cloud_N = L.cloud_N ;
lin coat_N = L.coat_N ;
lin cold_A = L.cold_A ;
lin come_V = L.come_V ;
lin computer_N = L.computer_N ;
lin correct_A = L.correct_A ;
lin count_V2 = L.count_V2 ;
lin country_N = L.country_N ;
lin cousin_N = L.cousin_N ;
lin cow_N = L.cow_N ;
lin cut_V2 = L.cut_V2 ;
lin day_N = L.day_N ;
lin die_V = L.die_V ;
lin dig_V = L.dig_V ;
lin dirty_A = L.dirty_A ;
--lin distance_N3 = L.distance_N3 ;
lin distance_N = lin N L.distance_N3 ;
lin do_V2 = L.do_V2 ;
lin doctor_N = L.doctor_N ;
lin dog_N = L.dog_N ;
lin door_N = L.door_N ;
lin drink_V2 = L.drink_V2 ;
lin dry_A = L.dry_A ;
lin dull_A = L.dull_A ;
lin dust_N = L.dust_N ;
lin ear_N = L.ear_N ;
lin earth_N = L.earth_N ;
--lin easy_A2V = L.easy_A2V ;
lin eat_V2 = L.eat_V2 ;
lin egg_N = L.egg_N ;
lin empty_A = L.empty_A ;
lin enemy_N = L.enemy_N ;
lin eye_N = L.eye_N ;
lin factory_N = L.factory_N ;
lin fall_V = L.fall_V ;
--lin far_Adv = L.far_Adv ;
lin fat_N = L.fat_N ;
--lin father_N2 = L.father_N2 ;
lin father_N = lin N L.father_N2 ;
lin fear_V2 = L.fear_V2 ;
lin fear_VS = L.fear_VS ;
lin feather_N = L.feather_N ;
lin fight_V2 = L.fight_V2 ;
lin find_V2 = L.find_V2 ;
lin fingernail_N = L.fingernail_N ;
--lin fire_N = L.fire_N ;
lin fish_N = L.fish_N ;
lin float_V = L.float_V ;
lin floor_N = L.floor_N ;
lin flow_V = L.flow_V ;
lin flower_N = L.flower_N ;
lin fly_V = L.fly_V ;
lin fog_N = L.fog_N ;
lin foot_N = L.foot_N ;
lin forest_N = L.forest_N ;
lin forget_V2 = L.forget_V2 ;
lin freeze_V = L.freeze_V ;
lin fridge_N = L.fridge_N ;
lin friend_N = L.friend_N ;
lin fruit_N = L.fruit_N ;
lin full_A = L.full_A ;
lin fun_A = L.fun_AV ;
lin garden_N = L.garden_N ;
lin girl_N = L.girl_N ;
lin give_V3 = L.give_V3 ;
lin glove_N = L.glove_N ;
lin go_V = L.go_V ;
lin gold_N = L.gold_N ;
lin good_A = L.good_A ;
lin grammar_N = L.grammar_N ;
lin grass_N = L.grass_N ;
lin green_A = L.green_A ;
--lin guts_N = L.guts_N ;
lin gut_N = L.guts_N ; ---- to check
lin hair_N = L.hair_N ;
lin hand_N = L.hand_N ;
lin harbour_N = L.harbour_N ;
lin hat_N = L.hat_N ;
lin hate_V2 = L.hate_V2 ;
lin head_N = L.head_N ;
lin hear_V2 = L.hear_V2 ;
lin heart_N = L.heart_N ;
lin heavy_A = L.heavy_A ;
lin hill_N = L.hill_N ;
lin hit_V2 = L.hit_V2 ;
lin hold_V2 = L.hold_V2 ;
lin hope_VS = L.hope_VS ;
lin horn_N = L.horn_N ;
lin horse_N = L.horse_N ;
lin hot_A = L.hot_A ;
lin house_N = L.house_N ;
lin hunt_V2 = L.hunt_V2 ;
lin husband_N = L.husband_N ;
lin ice_N = L.ice_N ;
lin important_A = L.important_A ;
lin industry_N = L.industry_N ;
lin iron_N = L.iron_N ;
lin john_PN = L.john_PN ;
lin jump_V = L.jump_V ;
lin kill_V2 = L.kill_V2 ;
lin king_N = L.king_N ;
lin knee_N = L.knee_N ;
lin know_V2 = L.know_V2 ;
lin know_VQ = L.know_VQ ;
lin know_VS = L.know_VS ;
lin lake_N = L.lake_N ;
lin lamp_N = L.lamp_N ;
lin language_N = L.language_N ;
lin laugh_V = L.laugh_V ;
lin leaf_N = L.leaf_N ;
lin learn_V2 = L.learn_V2 ;
lin leather_N = L.leather_N ;
lin leave_V2 = L.leave_V2 ;
--lin left_Ord = L.left_Ord ; ---- left_A in Dictionary
lin leg_N = L.leg_N ;
--lin lie_V = L.lie_V ;
lin lie_1_V = L.lie_V ; ---- to check, but "lying on the ground" is the original Swadesh meaning
lin like_V2 = L.like_V2 ;
--lin listen_V2 = L.listen_V2 ;
lin listen_V = lin V L.listen_V2 ;
lin live_V = L.live_V ;
lin liver_N = L.liver_N ;
lin long_A = L.long_A ;
lin lose_V2 = L.lose_V2 ;
lin louse_N = L.louse_N ;
lin love_N = L.love_N ;
lin love_V2 = L.love_V2 ;
lin man_N = L.man_N ;
--lin married_A2 = L.married_A2 ;
lin married_A = lin A L.married_A2 ; ---- to check
lin meat_N = L.meat_N ;
lin milk_N = L.milk_N ;
lin moon_N = L.moon_N ;
--lin mother_N2 = L.mother_N2 ;
lin mother_N = lin N L.mother_N2 ;
lin mountain_N = L.mountain_N ;
lin mouth_N = L.mouth_N ;
lin music_N = L.music_N ;
lin name_N = L.name_N ;
lin narrow_A = L.narrow_A ;
lin near_A = L.near_A ;
lin neck_N = L.neck_N ;
lin new_A = L.new_A ;
lin newspaper_N = L.newspaper_N ;
lin night_N = L.night_N ;
lin nose_N = L.nose_N ;
lin now_Adv = L.now_Adv ;
lin number_1_N = L.number_N ; ---- to check: sense "every number has a unique..."
lin oil_N = L.oil_N ;
lin old_A = L.old_A ;
lin open_V2 = L.open_V2 ;
--lin paint_V2A = L.paint_V2A ;
lin paint_V2 = lin V2 L.paint_V2A ;
lin paper_N = L.paper_N ;
lin paris_1_PN = L.paris_PN ; ---- the capital of France
lin peace_N = L.peace_N ;
lin pen_N = L.pen_N ;
lin person_N = L.person_N ;
lin planet_N = L.planet_N ;
lin plastic_N = L.plastic_N ;
lin play_1_V = L.play_V ; ---- to check: play in a team
lin play_1_V2 = L.play_V2 ; ---- to check: play football
lin policeman_N = L.policeman_N ;
lin priest_N = L.priest_N ;
lin probable_A = L.probable_AS ;
lin pull_V2 = L.pull_V2 ;
lin push_V2 = L.push_V2 ;
lin put_V2 = L.put_V2 ;
lin queen_N = L.queen_N ;
lin question_N = L.question_N ;
lin radio_N = L.radio_N ;
lin rain_N = L.rain_N ;
lin rain_V = L.rain_V0 ;
lin read_V2 = L.read_V2 ;
lin ready_A = L.ready_A ;
lin reason_N = L.reason_N ;
lin red_A = L.red_A ;
lin religion_N = L.religion_N ;
lin restaurant_N = L.restaurant_N ;
--lin right_Ord = L.right_Ord ; ---- right_2_A in Dictionary
lin river_N = L.river_N ;
lin road_N = L.road_N ;
lin rock_N = L.rock_N ;
lin roof_N = L.roof_N ;
lin root_N = L.root_N ;
lin rope_N = L.rope_N ;
lin rotten_A = L.rotten_A ;
lin round_A = L.round_A ;
lin rub_V2 = L.rub_V2 ;
lin rubber_N = L.rubber_N ;
lin rule_N = L.rule_N ;
lin run_V = L.run_V ;
lin salt_N = L.salt_N ;
lin sand_N = L.sand_N ;
lin say_VS = L.say_VS ;
lin school_N = L.school_N ;
lin science_N = L.science_N ;
lin scratch_V2 = L.scratch_V2 ;
lin sea_N = L.sea_N ;
lin see_V2 = L.see_V2 ;
lin seed_N = L.seed_N ;
lin seek_V2 = L.seek_V2 ;
--lin sell_V3 = L.sell_V3 ;
lin sell_V2 = lin V2 L.sell_V3 ;
--lin send_V3 = L.send_V3 ;
lin send_V2 = lin V2 L.send_V3 ;
lin sew_V = L.sew_V ;
lin sharp_A = L.sharp_A ;
lin sheep_N = L.sheep_N ;
lin ship_N = L.ship_N ;
lin shirt_N = L.shirt_N ;
lin shoe_N = L.shoe_N ;
lin shop_N = L.shop_N ;
lin short_A = L.short_A ;
lin silver_N = L.silver_N ;
lin sing_V = L.sing_V ;
lin sister_N = L.sister_N ;
lin sit_V = L.sit_V ;
lin skin_N = L.skin_N ;
lin sky_N = L.sky_N ;
lin sleep_V = L.sleep_V ;
lin small_A = L.small_A ;
lin smell_V = L.smell_V ;
lin smoke_N = L.smoke_N ;
lin smooth_A = L.smooth_A ;
lin snake_N = L.snake_N ;
lin snow_N = L.snow_N ;
lin sock_N = L.sock_N ;
lin song_N = L.song_N ;
lin speak_V2 = L.speak_V2 ;
lin spit_V = L.spit_V ;
lin split_V2 = L.split_V2 ;
lin squeeze_V2 = L.squeeze_V2 ;
lin stab_V2 = L.stab_V2 ;
lin stand_V = L.stand_V ;
lin star_N = L.star_N ;
lin steel_N = L.steel_N ;
lin stick_N = L.stick_N ;
lin stone_N = L.stone_N ;
lin stop_V = L.stop_V ;
lin stove_N = L.stove_N ;
lin straight_A = L.straight_A ;
--lin student_N = L.student_N ;
lin stupid_A = L.stupid_A ;
lin suck_V2 = L.suck_V2 ;
lin sun_N = L.sun_N ;
lin swell_V = L.swell_V ;
lin swim_V = L.swim_V ;
lin switch_off_V2 = L.switch8off_V2 ;
lin switch_on_V2 = L.switch8on_V2 ;
lin table_N = L.table_N ;
lin tail_N = L.tail_N ;
--lin talk_V3 = L.talk_V3 ;
lin talk_V2 = lin V2 L.talk_V3 ; ---- to check: there are two V2 projections of talk_V3
lin teach_V2 = L.teach_V2 ;
--lin teacher_N = L.teacher_N ;
lin teacherFem_N = L.teacher_N ; ---- to check
lin teacherMasc_N = L.teacher_N ; ---- to check
lin television_N = L.television_N ;
lin thick_A = L.thick_A ;
lin thin_A = L.thin_A ;
lin think_V = L.think_V ;
lin throw_V2 = L.throw_V2 ;
lin tie_V2 = L.tie_V2 ;
lin today_Adv = L.today_Adv ;
lin tongue_N = L.tongue_N ;
lin tooth_N = L.tooth_N ;
lin train_N = L.train_N ;
lin travel_V = L.travel_V ;
lin tree_N = L.tree_N ;
lin turn_V = L.turn_V ;
lin ugly_A = L.ugly_A ;
lin uncertain_A = L.uncertain_A ;
lin understand_V2 = L.understand_V2 ;
lin university_N = L.university_N ;
lin village_N = L.village_N ;
lin vomit_V = L.vomit_V ;
lin wait_V2 = L.wait_V2 ;
lin walk_V = L.walk_V ;
lin war_N = L.war_N ;
lin warm_A = L.warm_A ;
lin wash_V2 = L.wash_V2 ;
lin watch_1_V2 = L.watch_V2 ; ---- to check: sense "watch the TV"
lin water_N = L.water_N ;
lin wet_A = L.wet_A ;
lin white_A = L.white_A ;
lin wide_A = L.wide_A ;
lin wife_N = L.wife_N ;
lin win_V2 = L.win_V2 ;
lin wind_N = L.wind_N ;
lin window_N = L.window_N ;
lin wine_N = L.wine_N ;
lin wing_N = L.wing_N ;
lin wipe_V2 = L.wipe_V2 ;
lin woman_N = L.woman_N ;
lin wonder_VQ = L.wonder_VQ ;
lin wood_N = L.wood_N ;
lin worm_N = L.worm_N ;
lin write_V2 = L.write_V2 ;
lin year_N = L.year_N ;
lin yellow_A = L.yellow_A ;
lin young_A = L.young_A ;

}
