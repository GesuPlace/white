#define HALFWAYCRIT 50
#define GATEWAYMAX 1

/datum/gang_item
	var/name
	var/item_path
	var/cost
	var/spawn_msg
	var/category
	var/list/gang_whitelist = list()
	var/list/gang_blacklist = list()
	var/id
	var/mode_flags = GANGMAGEDDON | GANGS

/datum/gang_item/proc/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool, check_canbuy = TRUE)
	if(check_canbuy && !can_buy(user, gang, gangtool))
		return FALSE
	var/real_cost = get_cost(user, gang, gangtool)
	if(!spawn_item(user, gang, gangtool))
		if(istype(gangtool, /obj/item/gangtool/hell_march))
			var/obj/item/gangtool/hell_march/HM = gangtool
			HM.points -= real_cost
		else
			if(gang)
				gang.adjust_influence(-real_cost)
		to_chat(user, span_notice("You bought [name]."))
		gangtool.attack_self(user)
		return TRUE

/datum/gang_item/proc/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool) // If this returns anything other than null, something fucked up and influence won't lower.
	if(item_path)
		var/obj/item/O = new item_path(user.loc)
		user.put_in_hands(O)
	else
		return TRUE
	if(spawn_msg)
		to_chat(user, spawn_msg)

/datum/gang_item/proc/can_buy(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(istype(gangtool, /obj/item/gangtool/hell_march))
		var/obj/item/gangtool/hell_march/HM = gangtool
		return (HM.points >= get_cost(user, null, HM)) && can_see(user, null, HM)
	return gang && (gang.influence >= get_cost(user, gang, gangtool)) && can_see(user, gang, gangtool)

/datum/gang_item/proc/can_see(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	return TRUE

/datum/gang_item/proc/get_cost(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	return cost

/datum/gang_item/proc/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	return "([get_cost(user, gang, gangtool)] Influence)"

/datum/gang_item/proc/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	return name

/datum/gang_item/proc/get_extra_info(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	return

///////////////////
//CLOTHING
///////////////////

/datum/gang_item/clothing
	category = "Purchase Gang Clothes (Only the jumpsuit and suit give you added influence):"

/datum/gang_item/clothing/under
	name = "Gang Uniform"
	id = "under"
	cost = 1

/datum/gang_item/clothing/under/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gang.inner_outfits.len)
		var/outfit = pick(gang.inner_outfits)
		if(outfit)
			var/obj/item/O = new outfit(user.loc)
			user.put_in_hands(O)
			to_chat(user, "<span class='notice'> This is your gang's official uniform, wearing it will increase your influence")
			return
	return TRUE

/datum/gang_item/clothing/suit
	name = "Gang Armored Outerwear"
	id = "suit"
	cost = 1

/datum/gang_item/clothing/suit/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gang.outer_outfits.len)
		var/outfit = pick(gang.outer_outfits)
		if(outfit)
			var/obj/item/O = new outfit(user.loc)
			O.armor = O.armor.setRating(melee = 20, bullet = 35, laser = 10, energy = 10, bomb = 30, bio = 0, rad = 0, fire = 30, acid = 30)
			O.desc += " Tailored for the [gang.name] Gang to offer the wearer moderate protection against ballistics and physical trauma."
			user.put_in_hands(O)
			to_chat(user, "<span class='notice'> This is your gang's official outerwear, wearing it will increase your influence")
			return
	return TRUE


/datum/gang_item/clothing/hat
	name = "Pimp Hat"
	id = "hat"
	cost = 16
	item_path = /obj/item/clothing/head/collectable/petehat/gang


/obj/item/clothing/head/collectable/petehat/gang
	name = "pimpin' hat"
	desc = "The undisputed king of style."

/datum/gang_item/clothing/mask
	name = "Golden Death Mask"
	id = "mask"
	cost = 18
	item_path = /obj/item/clothing/mask/gskull

/obj/item/clothing/mask/gskull
	name = "golden death mask"
	icon_state = "gskull"
	desc = "Strike terror, and envy, into the hearts of your enemies."

/datum/gang_item/clothing/shoes
	name = "Bling Boots"
	id = "boots"
	cost = 22
	item_path = /obj/item/clothing/shoes/gang

/obj/item/clothing/shoes/gang
	name = "blinged-out boots"
	desc = "Stand aside peasants."
	icon_state = "bling"

/datum/gang_item/clothing/neck
	name = "Gold Necklace"
	id = "necklace"
	cost = 9
	item_path = /obj/item/clothing/neck/necklace/dope

/datum/gang_item/clothing/hands
	name = "Decorative Brass Knuckles"
	id = "hand"
	cost = 11
	item_path = /obj/item/clothing/gloves/gang

/obj/item/clothing/gloves/gang
	name = "braggadocio's brass knuckles"
	desc = "Purely decorative, don't find out the hard way."
	icon_state = "knuckles"
	w_class = 3

/datum/gang_item/clothing/belt
	name = "Badass Belt"
	id = "belt"
	cost = 13
	item_path = /obj/item/storage/belt/military/gang

/obj/item/storage/belt/military/gang
	name = "badass belt"
	icon_state = "gangbelt"
	inhand_icon_state = "gang"
	desc = "The belt buckle simply reads 'BAMF'."

///////////////////
//WEAPONS
///////////////////

/datum/gang_item/weapon
	category = "Purchase Weapons:"

/datum/gang_item/weapon/ammo

/datum/gang_item/weapon/shuriken
	name = "Shuriken"
	id = "shuriken"
	cost = 3
	item_path = /obj/item/throwing_star
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/switchblade
	name = "Switchblade"
	id = "switchblade"
	cost = 5
	item_path = /obj/item/switchblade

/datum/gang_item/weapon/surplus
	name = "Surplus Rifle"
	id = "surplus"
	cost = 8
	item_path = /obj/item/gun/ballistic/automatic/surplus
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/surplus_ammo
	name = "Surplus Rifle Ammo"
	id = "surplus_ammo"
	cost = 5
	item_path = /obj/item/ammo_box/magazine/m10mm/rifle
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/improvised
	name = "Sawn-Off Improvised Shotgun"
	id = "sawn"
	cost = 6
	item_path = /obj/item/gun/ballistic/shotgun/doublebarrel/improvised/sawn
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/improvised_ammo
	name = "Box of Buckshot"
	id = "buckshot"
	cost = 5
	item_path = /obj/item/storage/box/lethalshot
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/pistol
	name = "10mm Pistol"
	id = "pistol"
	cost = 30
	item_path = /obj/item/gun/ballistic/automatic/pistol
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/pistol_ammo
	name = "10mm Ammo"
	id = "pistol_ammo"
	cost = 10
	item_path = /obj/item/ammo_box/magazine/m10mm
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/machinegun
	name = "Mounted Machine Gun"
	id = "MG"
	cost = 70
	item_path = /obj/machinery/manned_turret
	spawn_msg = span_notice("The mounted machine gun features enhanced responsiveness. Hold down on the trigger while firing to control where you're shooting.")
	mode_flags = GANGMAGEDDON

/datum/gang_item/weapon/uzi
	name = "Uzi SMG"
	id = "uzi"
	cost = 60
	item_path = /obj/item/gun/ballistic/automatic/mini_uzi
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/uzi_ammo
	name = "Uzi Ammo"
	id = "uzi_ammo"
	cost = 40
	item_path = /obj/item/ammo_box/magazine/uzim9mm
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/tanner
	name = "Tanner M41"
	id = "m41"
	cost = 30
	item_path = /obj/item/gun/ballistic/automatic/pistol/tanner
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/tanner_ammo
	name = "Tanner M41 Ammo"
	id = "m41"
	cost = 10
	item_path = /obj/item/ammo_box/magazine/m10mm
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE


/datum/gang_item/weapon/launcher
	name = "PML-9 rocket launcher"
	id = "launcher"
	cost = 60
	item_path = /obj/item/gun/ballistic/rocketlauncher/unrestricted
	mode_flags = GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/launcher
	name = "84mm HE rocket"
	id = "84he"
	cost = 5
	item_path = /obj/item/ammo_casing/caseless/rocket
	mode_flags = GANGMAGEDDON | VIGILANTE

/datum/gang_item/weapon/ammo/launcher2
	name = "84mm HEDP rocket"
	id = "84hedp"
	cost = 10
	item_path = /obj/item/ammo_casing/caseless/rocket/hedp
	mode_flags = GANGMAGEDDON | VIGILANTE

///////////////////
//EQUIPMENT
///////////////////

/datum/gang_item/equipment
	category = "Purchase Equipment:"

/datum/gang_item/equipment/brutepack
	name = "Brute Pack"
	id = "brute"
	cost = 4
	item_path = /obj/item/stack/medical/bruise_pack
	mode_flags = GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/medpatch
	name = "Healing Patch"
	id = "heal"
	cost = 4
	item_path = /obj/item/reagent_containers/pill/patch/gang

/obj/item/reagent_containers/pill/patch/gang
	name = "unlabeled medical patch"
	desc = "Very popular among the type of people who can't go to a real hospital."
	list_reagents = list("styptic_powder" = 20, "silver_sulfadiazine" = 10, "crank" = 5)
	icon_state = "bandaid_brute"

/obj/item/toy/crayon
	var/datum/team/gang/gang //For marking territory, spraycans are gang-locked to their initial gang due to colors

/obj/item/toy/crayon/proc/hippie_gang_check(mob/user, atom/target) // hooked into afterattack
	var/gang_mode = FALSE
	if(gang && user.mind)
		var/datum/antagonist/gang/G = user.mind.has_antag_datum(/datum/antagonist/gang)
		if(G)
			if(G.gang != gang)
				to_chat(user, span_danger("This spraycan's color isn't your gang's one! You cannot use it."))
				return FALSE
			gang_mode = TRUE
			instant = FALSE
			. = "gang graffiti"
	// discontinue if we're not in gang modethe area isn't valid for tagging because gang "honour"
	if(gang_mode && (!can_claim_for_gang(user, target)))
		return FALSE
	return TRUE

/obj/item/toy/crayon/proc/gang_final(mob/user, atom/target, list/affected_turfs) // hooked into afterattack
	// Double check it wasn't tagged in the meanwhile
	if(!can_claim_for_gang(user, target))
		return TRUE
	tag_for_gang(user, target)
	affected_turfs += target

/obj/item/toy/crayon/proc/can_claim_for_gang(mob/user, atom/target)
	// Check area validity.
	// Reject space, player-created areas, and non-station z-levels.
	var/area/A = get_area(target)
	if(!A || (!is_station_level(A.z)) || !A.valid_territory)
		to_chat(user, span_warning("[A] is unsuitable for tagging."))
		return FALSE

	var/spraying_over = FALSE
	for(var/G in target)
		var/obj/effect/decal/cleanable/crayon/gang/gangtag = G
		if(istype(gangtag))
			var/datum/antagonist/gang/GA = user.mind.has_antag_datum(/datum/antagonist/gang)
			if(gangtag.gang != GA.gang)
				spraying_over = TRUE
				break

	for(var/obj/machinery/power/apc in target)
		to_chat(user, span_warning("You can't tag an APC."))
		return FALSE

	var/occupying_gang = territory_claimed(A, user)
	if(occupying_gang && !spraying_over)
		to_chat(user, span_danger("[A] has already been tagged by the [occupying_gang] gang! You must get rid of or spray over the old tag first!"))
		return FALSE

	// If you pass the gaunlet of checks, you're good to proceed
	return TRUE

/obj/item/toy/crayon/proc/territory_claimed(area/territory, mob/user)
	for(var/datum/team/gang/G in GLOB.gangs)
		if(territory.type in (G.territories|G.new_territories))
			. = G.name
			break

/obj/item/toy/crayon/proc/tag_for_gang(mob/user, atom/target)
	//Delete any old markings on this tile, including other gang tags
	for(var/obj/effect/decal/cleanable/crayon/old_marking in target)
		qdel(old_marking)

	var/datum/antagonist/gang/G = user.mind.has_antag_datum(/datum/antagonist/gang)
	var/area/territory = get_area(target)
	new /obj/effect/decal/cleanable/crayon/gang(target,G.gang,"graffiti",0,user)
	if(user.mind)
		LAZYADD(G.gang.tags_by_mind[user.mind], src)
	to_chat(user, span_notice("You tagged [territory] for your gang!"))

/obj/effect/decal/cleanable/crayon/gang
	icon = 'white/valtos/icons/crayondecal.dmi'
	layer = HIGH_OBJ_LAYER //Harder to hide
	plane = GAME_PLANE
	do_icon_rotate = FALSE //These are designed to always face south, so no rotation please.
	var/datum/team/gang/gang

/obj/effect/decal/cleanable/crayon/gang/Initialize(mapload, datum/team/gang/G, e_name = "gang tag", rotation = 0,  mob/user)
	if(!G)
		qdel(src)
		return
	gang = G
	var/newcolor = G.color
	var/area/territory = get_area(src)
	icon_state = G.name
	G.new_territories |= list(territory.type = territory.name)
	//If this isn't tagged by a specific gangster there's no bonus income.
	..(mapload, newcolor, icon_state, e_name, rotation)

/obj/effect/decal/cleanable/crayon/gang/Destroy()
	if(gang)
		var/area/territory = get_area(src)
		gang.territories -= territory.type
		gang.new_territories -= territory.type
		gang.lost_territories |= list(territory.type = territory.name)
	return ..()

/obj/item/toy/crayon/spraycan/gang
	//desc = "A modified container containing suspicious paint."
	charges = 20
	gang = TRUE
	pre_noise = FALSE
	post_noise = TRUE

/obj/item/toy/crayon/spraycan/gang/Initialize(loc, datum/team/gang/G)
	.=..()
	if(G)
		gang = G
		paint_color = G.color
		update_icon()

/obj/item/toy/crayon/spraycan/gang/examine(mob/user)
	. = ..()
	if(user.mind && user.mind.has_antag_datum(/datum/antagonist/gang) || isobserver(user))
		. += "<hr>This spraycan has been specially modified for tagging territory."

/datum/gang_item/equipment/spraycan
	name = "Territory Spraycan"
	id = "spraycan"
	cost = 5
	item_path = /obj/item/toy/crayon/spraycan/gang

/datum/gang_item/equipment/spraycan/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/obj/item/O = new item_path(user.loc, gang)
	user.put_in_hands(O)

/datum/gang_item/equipment/shield
	name = "Telescopic Shield"
	id = "shield"
	cost = 10
	item_path = /obj/item/shield/riot/tele
	mode_flags = VIGILANTE

/datum/gang_item/equipment/sandbag
	name = "Sandbags"
	id = "sandbag"
	cost = 6
	item_path = /obj/item/stack/sheet/mineral/sandbags
	mode_flags = GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/sharpener
	name = "Sharpener"
	id = "whetstone"
	cost = 3
	item_path = /obj/item/sharpener
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/emp
	name = "EMP Grenade"
	id = "EMP"
	cost = 5
	item_path = /obj/item/grenade/empgrenade

/datum/gang_item/equipment/c4
	name = "C4 Explosive"
	id = "c4"
	cost = 7
	item_path = /obj/item/grenade/c4

/datum/gang_item/equipment/frag
	name = "Fragmentation Grenade"
	id = "frag nade"
	cost = 18
	item_path = /obj/item/grenade/frag/mega

/obj/item/reagent_containers/syringe/nanoboost
	name = "Nanobooster"
	desc = "Contains Nanomachines Son!."
	amount_per_transfer_from_this = 50
	volume = 50
	list_reagents = list(/datum/reagent/medicine/stimulants = 50)

/datum/gang_item/equipment/stimpack
	name = "Black Market Stimulants"
	id = "stimpack"
	cost = 12
	item_path = /obj/item/reagent_containers/syringe/nanoboost
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/implant_breaker
	name = "Implant Breaker"
	id = "implant_breaker"
	cost = 10
	item_path = /obj/item/implanter/gang
	spawn_msg = span_notice("The <b>implant breaker</b> is a single-use device that destroys all implants within the target before trying to recruit them to your gang. Also works on enemy gangsters.")

/obj/item/implant/gang
	name = "gang implant"
	desc = "Makes you a gangster or such."
	activated = 0
	var/datum/team/gang/gang

/obj/item/implant/gang/Initialize(loc, setgang)
	.=..()
	gang = setgang

/obj/item/implant/gang/Destroy()
	gang = null
	return ..()

/obj/item/implant/gang/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Criminal brainwash implant<BR>
				<b>Life:</b> A few seconds after injection.<BR>
				<b>Important Notes:</b> Illegal<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a small pod of nanobots that change the host's brain to be loyal to a certain organization.<BR>
				<b>Special Features:</b> This device will also emit a small EMP pulse, destroying any other implants within the host's brain.<BR>
				<b>Integrity:</b> Implant's EMP function will destroy itself in the process."}
	return dat

/obj/item/implant/gang/implant(mob/living/target, mob/user, silent = 0)
	if(!target || !target.mind || target.stat == DEAD)
		return 0
	var/datum/antagonist/gang/G = target.mind.has_antag_datum(/datum/antagonist/gang)
	if(G && G.gang == G)
		return 0 // it's pointless
	if(..())
		for(var/obj/item/implant/I in target.implants)
			if(I != src)
				qdel(I)

		if(ishuman(target))
			var/success
			if(G)
				if(!istype(G, /datum/antagonist/gang/boss))
					success = TRUE	//Was not a gang boss, convert as usual
					target.mind.remove_antag_datum(/datum/antagonist/gang)
			else
				success = TRUE
			if(!success)
				target.visible_message(span_warning("[target] seems to resist the implant!") , span_warning("You feel the influence of your enemies try to invade your mind!"))
				return FALSE
		target.mind.add_antag_datum(/datum/antagonist/gang, gang)
		qdel(src)
		return TRUE

/obj/item/implanter/gang
	name = "implanter (gang)"

/obj/item/implanter/gang/Initialize(loc, gang)
	if(!gang)
		qdel(src)
		return
	imp = new /obj/item/implant/gang(src,gang)
	.=..()

/datum/gang_item/equipment/implant_breaker/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/obj/item/O = new item_path(user.loc, gang)
	user.put_in_hands(O)

/datum/gang_item/function
	category = "Gangtool Functions:"
	cost = 0

/datum/gang_item/function/backup
	name = "Create Gateway for Reinforcements"
	id = "backup"
	item_path = /obj/machinery/gang/backup
	mode_flags = GANGMAGEDDON

/datum/gang_item/function/backup/can_see(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!user.mind.has_antag_datum(/datum/antagonist/gang/boss))
		return FALSE
	if(gang.gateways >= GATEWAYMAX)
		return FALSE
	return TRUE

/datum/gang_item/function/backup/can_buy(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gang.gateways >= GATEWAYMAX)
		return FALSE
	return TRUE

/datum/gang_item/function/backup/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/obj/machinery/gang/backup/gate = new(get_turf(user), gang)
	gate.G = gang

/datum/gang_item/function/backup/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/area/usrarea = get_area(user.loc)
	if(!(usrarea.type in gang.territories|gang.new_territories))
		to_chat(user, span_warning("This device can only be spawned in territory controlled by your gang!"))
		return FALSE
	var/confirm_final = tgui_alert(user, "Your gang can only place ONE gateway, make sure it is in a well-secured location.", "Are you ready to place the gateway?", "This location is secure", "I should wait...")
	if(confirm_final == "I should wait...")
		return FALSE
	return ..()

/obj/machinery/gang/backup
	name = "gang reinforcements gateway"
	desc = "A gateway used by gangs to bring in muscle from other operations."
	anchored = TRUE
	density = TRUE
	icon = 'white/valtos/icons/teleporter.dmi'
	icon_state = "gang_teleporter_on"
	max_integrity = 400
	obj_integrity = 400
	var/final_guard = TRUE
	var/datum/team/gang/G
	var/list/mob/dead/observer/queue

/obj/machinery/gang/backup/Initialize(mapload, datum/team/gang/gang)
	. = ..()
	G = gang
	queue = list()
	name = "[G] reinforcements gateway"
	addtimer(CALLBACK(src, .proc/reinforce), max(10, (4500 - world.time)))
	do_sparks(4, TRUE, src)
	gang.gateways++

/obj/machinery/gang/backup/Destroy(mapload, datum/team/gang/gang)
	for(var/mob/M in contents)
		qdel(M)
	return ..()

/obj/machinery/gang/backup/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE)
	. = ..()
	if(.)
		if((obj_integrity < 300) && final_guard == TRUE)
			final_guard = FALSE
			reinforce(FALSE)

/obj/machinery/gang/backup/proc/reinforce(repeat = TRUE)
	var/we = 0
	var/rival = 0
	var/cooldown = 0
	queue = list()
	for(var/datum/team/gang/baddies in GLOB.gangs)
		if(baddies == G)
			for(var/datum/mind/M in G.members)
				if(M.current.stat == DEAD)
					var/mob/O = M.get_ghost(TRUE)
					if(O)
						queue += O
					continue
				we++
			for(var/datum/mind/B in G.leaders)
				if(B.current.stat == DEAD)
					var/mob/O = B.get_ghost(TRUE)
					if(O)
						queue += O
					continue
				we++
		else
			for(var/datum/mind/E in G.members)
				if(E.current.stat == DEAD)
					continue
				rival++
			for(var/datum/mind/R in G.members)
				if(R.current.stat == DEAD)
					continue
				rival++
	if(!we)
		we = 1
	if(repeat)
		cooldown = 250+((we/(rival+we))*100)**2
		addtimer(CALLBACK(src, .proc/reinforce), cooldown, TIMER_UNIQUE)
	spawn_gangster()


/obj/machinery/gang/backup/proc/spawn_gangster()
	var/mob/dead/observer/winner
	if(LAZYLEN(queue))
		var/list/mob/dead/observer/finalists = pollCandidates("Would you like to be a [G.name] gang reinforcement?", jobbanType = ROLE_GANG, poll_time = 100, ignore_category = "gang war", group = queue)
		if(LAZYLEN(finalists))
			winner = pick(finalists)
	if(!winner)
		var/list/mob/dead/observer/dead_vigils = list()
		for(var/mob/dead/observer/O in GLOB.player_list)
			if(!O.mind.has_antag_datum(/datum/antagonist/gang))
				dead_vigils += O
		var/list/mob/dead/observer/candidates = pollCandidates("Would you like to be a [G.name] gang reinforcement?", jobbanType = ROLE_GANG, poll_time = 100, ignore_category = "gang war", group = dead_vigils)
		if(LAZYLEN(candidates))
			winner = pick(candidates)
	if(!src || !winner)
		message_admins("No ghosts to serve as a [G.name] gang reinforement")
		return
	var/mob/living/carbon/human/H = new(src)
	var/datum/mind/reinforcement = new /datum/mind(winner.key)
	reinforcement.active = TRUE
	reinforcement.transfer_to(H)
	reinforcement.add_antag_datum(/datum/antagonist/gang, G)
	var/obj/item/clothing/uniform = pick(G.inner_outfits)
	var/obj/item/clothing/suit/OW = pick(G.outer_outfits)
	var/obj/item/clothing/suit/outerwear = new OW(H)
	outerwear.armor = list(melee = 20, bullet = 35, laser = 10, energy = 10, bomb = 30, bio = 0, rad = 0, fire = 30, acid = 30)
	outerwear.body_parts_covered = CHEST|GROIN|LEGS|ARMS
	outerwear.desc += " Tailored for the [G.name] Gang to offer the wearer moderate protection against ballistics and physical trauma."
	H.equip_to_slot_or_del(new uniform(H), ITEM_SLOT_ICLOTHING)
	H.equip_to_slot_or_del(outerwear, ITEM_SLOT_OCLOTHING)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/jackboots(H), ITEM_SLOT_FEET)
	H.put_in_l_hand(new /obj/item/gun/ballistic/automatic/surplus(H))
	H.equip_to_slot_or_del(new /obj/item/ammo_box/magazine/m10mm/rifle(H), ITEM_SLOT_LPOCKET)
	H.equip_to_slot_or_del(new /obj/item/switchblade(H), ITEM_SLOT_RPOCKET)
	var/equip = SSjob.EquipRank(H, "Assistant", 1)
	H = equip
	do_sparks(4, TRUE, src)
	H.forceMove(get_turf(src))


/datum/gang_item/equipment/wetwork_boots
	name = "Wetwork boots"
	id = "wetwork"
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE
	cost = 20
	item_path = /obj/item/clothing/shoes/combat/gang

/obj/item/clothing/shoes/combat/gang
	name = "Wetwork boots"
	desc = "A gang's best hitmen are prepared for anything."
	permeability_coefficient = 0.01
	clothing_flags = NOSLIP

/datum/gang_item/equipment/bulletproof_armor
	name = "Bulletproof Armor"
	id = "BPA"
	cost = 20
	item_path = /obj/item/clothing/suit/armor/bulletproof
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/bulletproof_helmet
	name = "Bulletproof Helmet"
	id = "BPH"
	cost = 10
	item_path = /obj/item/clothing/head/helmet/alt
	mode_flags = GANGS | GANGMAGEDDON | VIGILANTE

/datum/gang_item/equipment/pen
	name = "Recruitment Pen"
	id = "pen"
	cost = 10
	item_path = /obj/item/pen/gang
	spawn_msg = span_notice("More <b>recruitment pens</b> will allow you to recruit gangsters faster. Only gang leaders can recruit with pens.")

/datum/gang_item/equipment/pen/can_see(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!user.mind.has_antag_datum(/datum/antagonist/gang/boss))
		return FALSE
	return ..()

/datum/gang_item/equipment/pen/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(..())
		gangtool.free_pen = FALSE
		return TRUE
	return FALSE

/datum/gang_item/equipment/pen/get_cost(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return 0
	return ..()

/datum/gang_item/equipment/pen/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gangtool && gangtool.free_pen)
		return "(GET ONE FREE)"
	return ..()


/datum/gang_item/equipment/gangtool
	id = "gangtool"
	cost = 10
	mode_flags = GANGS

/datum/gang_item/equipment/gangtool/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/item_type
	if(gang)
		item_type = /obj/item/gangtool/spare/lt
		if(gang.leaders.len < MAX_LEADERS_GANG)
			to_chat(user, span_notice("<b>Gangtools</b> allow you to promote a gangster to be your Lieutenant, enabling them to recruit and purchase items like you. Simply have them register the gangtool. You may promote up to [MAX_LEADERS_GANG-gang.leaders.len] more Lieutenants"))
	else
		item_type = /obj/item/gangtool/spare
	var/obj/item/gangtool/spare/tool = new item_type(user.loc)
	user.put_in_hands(tool)

/datum/gang_item/equipment/gangtool/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gang && (gang.leaders.len < gang.max_leaders))
		return "Promote a Gangster"
	return "Spare Gangtool"

/datum/gang_item/equipment/dominator
	name = "Station Dominator"
	id = "dominator"
	cost = 30
	item_path = /obj/machinery/dominator
	spawn_msg = span_notice("The <b>dominator</b> will secure your gang's dominance over the station. Turn it on when you are ready to defend it.")

/datum/gang_item/equipment/dominator/can_see(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!user.mind.has_antag_datum(/datum/antagonist/gang/boss))
		return FALSE
	return ..()

/datum/gang_item/equipment/dominator/can_buy(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return FALSE
	return ..()

/datum/gang_item/equipment/dominator/get_name_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return ..()
	return "<b>[..()]</b>"

/datum/gang_item/equipment/dominator/get_cost_display(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(!gang || !gang.dom_attempts)
		return "(Out of stock)"
	return ..()

/datum/gang_item/equipment/dominator/get_extra_info(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	if(gang)
		return "This device requires a 5x5 area clear of walls to work. (Estimated Takeover Time: [round(gang.determine_domination_time()/60,0.1)] minutes)"

/datum/gang_item/equipment/dominator/purchase(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	var/area/userarea = get_area(user)
	if(!(userarea.type in gang.territories|gang.new_territories))
		to_chat(user,span_warning("The <b>dominator</b> can be spawned only on territory controlled by your gang!"))
		return FALSE
	for(var/obj/obj in get_turf(user))
		if(obj.density)
			to_chat(user, span_warning("There's not enough room here!"))
			return FALSE
	var/list/open = list()
	var/list/closed = list()
	for(var/turf/T in view(3, user))
		if(isclosedturf(T))
			closed += T
		else if(isopenturf(T))
			open += T
	if(open.len < DOM_REQUIRED_TURFS)
		var/c_images = list()
		for(var/turf/T in closed)
			var/image/I = image('icons/obj/closet.dmi', T, "cardboard_special")
			I.layer = ABOVE_LIGHTING_LAYER
			I.plane = ABOVE_LIGHTING_PLANE
			c_images += I
			user.client.images += I
		for(var/turf/T in open)
			var/image/I = image('white/valtos/icons/effects.dmi', T, "checkmark")
			I.layer = ABOVE_LIGHTING_LAYER
			I.plane = ABOVE_LIGHTING_PLANE
			c_images += I
			user.client.images += I
		if(alert(user,"Are you sure you wish to place the dominator here?\nThere needs to be [DOM_REQUIRED_TURFS - open.len] more open tiles!","Confirm","Ready","Later") != "Ready")
			for(var/image/I in c_images)
				user.client.images -= I
				qdel(I)
			return
		for(var/image/I in c_images)
			user.client.images -= I
			qdel(I)
	return ..()

/datum/gang_item/equipment/dominator/spawn_item(mob/living/carbon/user, datum/team/gang/gang, obj/item/gangtool/gangtool)
	new item_path(user.loc)
	to_chat(user, spawn_msg)

/datum/gang_item/equipment/reviver
	name = "Outlawed Reviver Serum"
	id = "reviver"
	cost = 50
	item_path = /obj/item/reviver
	mode_flags = GANGMAGEDDON

/obj/item/reviver
	name = "outlawed revivification serum"
	desc = "Banned due to side effects of extreme rage, reduced intelligence, and violence. For gangs, that's just a fringe benefit."
	icon = 'white/valtos/icons/items.dmi'
	icon_state = "implanter1"
	inhand_icon_state = "syringe_0"
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron=600, /datum/material/glass=200)

/obj/item/reviver/attack(mob/living/carbon/human/H, mob/user)
	if(!ishuman(H) || icon_state == "implanter0")
		return ..()
	user.visible_message(span_warning("[user] begins inject [H] with [src].") , span_warning("You begin to inject [H] with [src]..."))
	var/total_burn	= 0
	var/total_brute	= 0
	H.notify_ghost_cloning("You're being injected with a revivification serum - return to your body!")
	if(do_after(user, 80, target = H))
		if(H.stat == DEAD && icon_state == "implanter1")
			H.visible_message("<span class='warning'>[H] body thrashes violently.")
			playsound(src, "bodyfall", 50, 1)
			H.spin(20, 1)
			if (H.suiciding || !H.getorgan(/obj/item/organ/heart) || !H.getorgan(/obj/item/organ/brain) || !H.mind)
				H.visible_message("<span class='warning'>[H] body falls still again, they're gone for good.")
				return
			if(!H.client)
				var/identity
				var/mob/dead/observer/winner
				H.visible_message("<span class='warning'>[H] body twitches as a spirit seeks to return to this broken form.")
				var/datum/antagonist/gang/G = H.mind.has_antag_datum(/datum/antagonist/gang)
				if(G && G.gang)
					identity = "[G.gang.name] gangster"
				else
					identity = "Vigilante"
				var/list/mob/dead/observer/candidates = pollGhostCandidates("Would you to play the role of a revived [identity]?", "pAI", null, FALSE, 100)
				if(LAZYLEN(candidates) && !QDELETED(src) && icon_state == "implanter1")
					winner = pick(candidates)
					H.key = winner.key
				else
					H.visible_message("<span class='warning'>[H] body falls still again, their spirit has moved on.")
					return
			total_brute = H.getBruteLoss()
			total_burn = H.getFireLoss()
			var/overall_damage = total_brute + total_burn + H.getToxLoss() + H.getOxyLoss()
			var/mobhealth = H.health
			H.adjustOxyLoss((mobhealth - HALFWAYCRIT) * (H.getOxyLoss() / overall_damage), 0)
			H.adjustToxLoss((mobhealth - HALFWAYCRIT) * (H.getToxLoss() / overall_damage), 0)
			H.adjustFireLoss((mobhealth - HALFWAYCRIT) * (total_burn / overall_damage), 0)
			H.adjustBruteLoss((mobhealth - HALFWAYCRIT) * (total_brute / overall_damage), 0)
			H.updatehealth()
			H.set_heartattack(FALSE)
			H.grab_ghost()
			H.revive()
			H.emote("gasp")
			//H.setBrainLoss(40)
			icon_state = "implanter0"
			update_icon()


//vigilante crap

/datum/gang_item/equipment/gangbreaker
	name = "Mindshield Implant"
	id = "gangbreaker"
	cost = 15
	item_path = /obj/item/implanter/mindshield
	spawn_msg = span_notice("Nanotrasen has provided you with a prototype mindshield implant that will both break a gang's control over a person and shield them from further conversion attempts.Gang bosses are immune.</b></u>")
	mode_flags = VIGILANTE

/datum/gang_item/equipment/seraph
	name = "Seraph 'Gangbuster' Mech"
	id = "seraph"
	cost = 250
	item_path = /obj/vehicle/sealed/mecha/combat/marauder/gangbuster_seraph
	spawn_msg = span_notice("For employees who go above and beyond... you know what to do with this. ")
	mode_flags = VIGILANTE

/obj/vehicle/sealed/mecha/combat/marauder/gangbuster_seraph
	desc = "Heavy-duty, combat-type exosuit. This is a custom gangbuster model, utilized only by employees who have proven themselves in the line of fire."
	name = "\improper 'Gangbuster' Seraph" // Mostly for theming since this is a Nanotrasen funded initiative
	icon_state = "seraph"

	step_in = 2
	obj_integrity = 300
	max_integrity = 300
	wreckage = /obj/structure/mecha_wreckage/seraph
	internal_damage_threshold = 20
	max_equip = 4
	bumpsmash = FALSE

/obj/vehicle/sealed/mecha/combat/marauder/gangbuster_seraph/Initialize()
	. = ..()
	operation_req_access = list()
	var/obj/item/mecha_parts/mecha_equipment/ME
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/teleporter(src)
	ME.attach(src)
