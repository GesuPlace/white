///Called when a mech melee attacks an atom
/atom/proc/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker)
	return

/turf/closed/wall/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker)
	mecha_attacker.do_attack_animation(src)
	switch(mecha_attacker.damtype)
		if(BRUTE)
			playsound(src, 'sound/weapons/punch4.ogg', 50, TRUE)
			mecha_attacker.visible_message(span_danger("[mecha_attacker.name] бьёт [src]!") , \
							span_danger("Бью [src]!") , null, COMBAT_MESSAGE_RANGE)
			if(prob(hardness + mecha_attacker.force) && mecha_attacker.force > 20)
				dismantle_wall(1)
				playsound(src, 'sound/effects/meteorimpact.ogg', 100, TRUE)
			else
				add_dent(WALL_DENT_HIT)
		if(BURN)
			playsound(src, 'sound/items/welder.ogg', 100, TRUE)
		if(TOX)
			playsound(src, 'sound/effects/spray2.ogg', 100, TRUE)
			return FALSE

/obj/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker)
	mecha_attacker.do_attack_animation(src)
	var/play_soundeffect = 0
	var/mech_damtype = mecha_attacker.damtype
	if(mecha_attacker.selected)
		mech_damtype = mecha_attacker.selected.damtype
		play_soundeffect = 1
	else
		switch(mecha_attacker.damtype)
			if(BRUTE)
				playsound(src, 'sound/weapons/punch4.ogg', 50, TRUE)
			if(BURN)
				playsound(src, 'sound/items/welder.ogg', 50, TRUE)
			if(TOX)
				playsound(src, 'sound/effects/spray2.ogg', 50, TRUE)
				return 0
			else
				return 0
	mecha_attacker.visible_message(span_danger("[mecha_attacker.name] бьёт [src]!") , span_danger("Бью [src]!") , null, COMBAT_MESSAGE_RANGE)
	return take_damage(mecha_attacker.force * 3, mech_damtype, "melee", play_soundeffect, get_dir(src, mecha_attacker)) // multiplied by 3 so we can hit objs hard but not be overpowered against mobs.

/obj/structure/window/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker)
	if(!can_be_reached())
		return
	return ..()

/mob/living/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/user)
	if(user.a_intent == INTENT_HARM)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, span_warning("Не хочу вредить живым существам!"))
			return
		mecha_attacker.do_attack_animation(src)
		if(mecha_attacker.damtype == "brute")
			step_away(src, mecha_attacker, 15)
		switch(mecha_attacker.damtype)
			if(BRUTE)
				Unconscious(20)
				take_overall_damage(rand(mecha_attacker.force/2, mecha_attacker.force))
				playsound(src, 'sound/weapons/punch4.ogg', 50, TRUE)
			if(BURN)
				take_overall_damage(0, rand(mecha_attacker.force * 0.5, mecha_attacker.force))
				playsound(src, 'sound/items/welder.ogg', 50, TRUE)
			if(TOX)
				mecha_attacker.mech_toxin_damage(src)
			else
				return
		updatehealth()
		visible_message(span_danger("[mecha_attacker.name] бьёт [src]!") , \
						span_userdanger("[mecha_attacker.name] бьёт меня!") , span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, mecha_attacker)
		to_chat(mecha_attacker, span_danger("Бью [src]!"))
		log_combat(user, src, "attacked", mecha_attacker, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(mecha_attacker.damtype)])")
	else
		step_away(src, mecha_attacker)
		log_combat(user, src, "pushed", mecha_attacker)
		visible_message(span_warning("[mecha_attacker] толкает [src] в сторону.") , \
						span_warning("[mecha_attacker] толкает меня в сторону.") , span_hear("Слышу агрессивную потасовку!") , 5, list(mecha_attacker))
		to_chat(mecha_attacker, span_danger("Толкаю [src] в сторону."))

/mob/living/carbon/human/mech_melee_attack(obj/vehicle/sealed/mecha/mecha_attacker, mob/user)
	if(user.a_intent == INTENT_HARM)
		if(HAS_TRAIT(user, TRAIT_PACIFISM))
			to_chat(user, span_warning("Не хочу вредить живым существам!"))
			return
		mecha_attacker.do_attack_animation(src)
		if(mecha_attacker.damtype == BRUTE)
			step_away(src, mecha_attacker, 15)
		var/obj/item/bodypart/temp = get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_HEAD))
		if(temp)
			var/update = 0
			var/dmg = rand(mecha_attacker.force * 0.5, mecha_attacker.force)
			switch(mecha_attacker.damtype)
				if(BRUTE)
					if(mecha_attacker.force > 35) // durand and other heavy mechas
						Unconscious(20)
					else if(mecha_attacker.force > 20 && !IsKnockdown()) // lightweight mechas like gygax
						Knockdown(40)
					update |= temp.receive_damage(dmg, 0)
					playsound(src, 'sound/weapons/punch4.ogg', 50, TRUE)
				if(FIRE)
					update |= temp.receive_damage(0, dmg)
					playsound(src, 'sound/items/welder.ogg', 50, TRUE)
				if(TOX)
					mecha_attacker.mech_toxin_damage(src)
				else
					return
			if(update)
				update_damage_overlays()
			updatehealth()

		visible_message(span_danger("[mecha_attacker.name] лупит [src]!") , \
						span_userdanger("[mecha_attacker.name] лупит меня!") , span_hear("Слышу звук разрывающейся плоти!") , COMBAT_MESSAGE_RANGE, list(mecha_attacker))
		to_chat(mecha_attacker, span_danger("Луплю [src]!"))
		log_combat(user, src, "attacked", mecha_attacker, "(INTENT: [uppertext(user.a_intent)]) (DAMTYPE: [uppertext(mecha_attacker.damtype)])")
	else
		return ..()
