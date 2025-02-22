
/////AUGMENTATION SURGERIES//////


//SURGERY STEPS

/datum/surgery_step/replace_limb
	name = "replace limb"
	implements = list(/obj/item/bodypart = 100, /obj/item/organ_storage = 100)
	time = 32
	var/obj/item/bodypart/L = null // L because "limb"


/datum/surgery_step/replace_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(NOAUGMENTS in target.dna.species.species_traits)
		to_chat(user, span_warning("[target] cannot be augmented!"))
		return -1
	if(istype(tool, /obj/item/organ_storage) && istype(tool.contents[1], /obj/item/bodypart))
		tool = tool.contents[1]
	var/obj/item/bodypart/aug = tool
	if(aug.status != BODYPART_ROBOTIC)
		to_chat(user, span_warning("That's not an augment, silly!"))
		return -1
	if(aug.body_zone != target_zone)
		to_chat(user, span_warning("[tool] isn't the right type for [parse_zone(target_zone)]."))
		return -1
	L = surgery.operated_bodypart
	if(L)
		display_results(user, target, span_notice("You begin to augment [target] [parse_zone(user.zone_selected)]...") ,
			span_notice("[user] begins to augment [target] [parse_zone(user.zone_selected)] with [aug].") ,
			span_notice("[user] begins to augment [target] [parse_zone(user.zone_selected)]."))
	else
		user.visible_message(span_notice("[user] looks for [target] [parse_zone(user.zone_selected)].") , span_notice("You look for [target] [parse_zone(user.zone_selected)]..."))


//ACTUAL SURGERIES

/datum/surgery/augmentation
	name = "Augmentation"
	steps = list(/datum/surgery_step/incise, /datum/surgery_step/clamp_bleeders, /datum/surgery_step/retract_skin, /datum/surgery_step/replace_limb)
	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_R_LEG,BODY_ZONE_L_LEG,BODY_ZONE_CHEST,BODY_ZONE_HEAD)
	requires_real_bodypart = TRUE

//SURGERY STEP SUCCESSES

/datum/surgery_step/replace_limb/success(mob/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(L)
		if(istype(tool, /obj/item/organ_storage))
			tool.icon_state = initial(tool.icon_state)
			tool.desc = initial(tool.desc)
			tool.cut_overlays()
			tool = tool.contents[1]
		if(istype(tool) && user.temporarilyRemoveItemFromInventory(tool))
			tool.replace_limb(target, TRUE)
		display_results(user, target, span_notice("You successfully augment [target] [parse_zone(target_zone)].") ,
			span_notice("[user] successfully augments [target] [parse_zone(target_zone)] with [tool]!") ,
			span_notice("[user] successfully augments [target] [parse_zone(target_zone)]!"))
		log_combat(user, target, "augmented", addition="by giving him new [parse_zone(target_zone)] INTENT: [uppertext(user.a_intent)]")
	else
		to_chat(user, span_warning("[target] has no organic [parse_zone(target_zone)] there!"))
	return ..()
