--[[
	The purpose of this file is mostly to exist because it is required.
	Deal with all precaching here, to keep it out of the way.
]]--
print("addon_game_mode invoked")
require('timers')

--[[
	We want to precache resources we want to use, so they are ready for loading when the engine requires
	Precache things we know we"ll use.  Possible file types include (but not limited to):
		PrecacheResource( "model", "*.vmdl", context )
		PrecacheResource( "soundfile", "*.vsndevts", context )
		PrecacheResource( "particle", "*.vpcf", context )
		PrecacheResource( "particle_folder", "particles/folder", context )
	This is called before the game is activated, but after the "cruft" has run.
]]--
function Precache( context )
	print("Precache Begin")
	
	PrecacheItemByNameSync( "item_acorn", context )
	PrecacheItemByNameSync( "item_acorn_magic", context )
	PrecacheItemByNameSync( "item_armour_battle", context )
	PrecacheItemByNameSync( "item_axe_battle", context )
	PrecacheItemByNameSync( "item_axe_flint", context )
	PrecacheItemByNameSync( "item_axe_iron", context )
	PrecacheItemByNameSync( "item_axe_mage_masher", context )
	PrecacheItemByNameSync( "item_axe_steel", context )
	PrecacheItemByNameSync( "item_axe_stone", context )
	PrecacheItemByNameSync( "item_basic", context )
	PrecacheItemByNameSync( "item_bee_hive", context )
	PrecacheItemByNameSync( "item_blow_gun", context )
	PrecacheItemByNameSync( "item_bomb_smoke", context )
	PrecacheItemByNameSync( "item_bone", context )
	PrecacheItemByNameSync( "item_boots_anabolic", context )
	PrecacheItemByNameSync( "item_boots_bear", context )
	PrecacheItemByNameSync( "item_boots_bone", context )
	PrecacheItemByNameSync( "item_boots_elk", context )
	PrecacheItemByNameSync( "item_boots_iron", context )
	PrecacheItemByNameSync( "item_boots_steel", context )
	PrecacheItemByNameSync( "item_boots_wolf", context )
	PrecacheItemByNameSync( "item_bow_blood", context )
	PrecacheItemByNameSync( "item_building_kit_armory", context )
	PrecacheItemByNameSync( "item_building_kit_chest_storage", context )
	PrecacheItemByNameSync( "item_building_kit_fire_basic", context )
	PrecacheItemByNameSync( "item_building_kit_fire_mage", context )
	PrecacheItemByNameSync( "item_building_kit_hatchery", context )
	PrecacheItemByNameSync( "item_building_kit_hut_basic", context )
	PrecacheItemByNameSync( "item_building_kit_hut_mud", context )
	PrecacheItemByNameSync( "item_building_kit_hut_witch_doctor", context )
	PrecacheItemByNameSync( "item_building_kit_mixing_pot", context )
	PrecacheItemByNameSync( "item_building_kit_smoke_house", context )
	PrecacheItemByNameSync( "item_building_kit_spirit_ward", context )
	PrecacheItemByNameSync( "item_building_kit_teleport_beacon", context )
	PrecacheItemByNameSync( "item_building_kit_tent_basic", context )
	PrecacheItemByNameSync( "item_building_kit_tower_omni", context )
	PrecacheItemByNameSync( "item_building_kit_trap_ensnare", context )
	PrecacheItemByNameSync( "item_building_kit_workshop", context )
	PrecacheItemByNameSync( "item_clay_ball", context )
	PrecacheItemByNameSync( "item_clay_living", context )
	PrecacheItemByNameSync( "item_cloak_fire", context )
	PrecacheItemByNameSync( "item_cloak_frost", context )
	PrecacheItemByNameSync( "item_cloak_protection", context )
	PrecacheItemByNameSync( "item_coat_bear", context )
	PrecacheItemByNameSync( "item_coat_bone", context )
	PrecacheItemByNameSync( "item_coat_camouflage", context )
	PrecacheItemByNameSync( "item_coat_elk", context )
	PrecacheItemByNameSync( "item_coat_iron", context )
	PrecacheItemByNameSync( "item_coat_steel", context )
	PrecacheItemByNameSync( "item_coat_wolf", context )
	PrecacheItemByNameSync( "item_compass_sonar", context )
	PrecacheItemByNameSync( "item_egg_hawk", context )
	PrecacheItemByNameSync( "item_essence_bees", context )
	PrecacheItemByNameSync( "item_flint", context )
	PrecacheItemByNameSync( "item_gem_of_knowledge", context )
	PrecacheItemByNameSync( "item_gloves_battle", context )
	PrecacheItemByNameSync( "item_gloves_bear", context )
	PrecacheItemByNameSync( "item_gloves_Bone", context )
	PrecacheItemByNameSync( "item_gloves_elk", context )
	PrecacheItemByNameSync( "item_gloves_iron", context )
	PrecacheItemByNameSync( "item_gloves_iron", context )
	PrecacheItemByNameSync( "item_gloves_wolf", context )
	PrecacheItemByNameSync( "item_gun_blow", context )
	PrecacheItemByNameSync( "item_gun_blow_bones", context )
	PrecacheItemByNameSync( "item_gun_blow_empty", context )
	PrecacheItemByNameSync( "item_gun_blow_thistles", context )
	PrecacheItemByNameSync( "item_gun_blow_thistles_dark", context )
	PrecacheItemByNameSync( "item_herb_blue", context )
	PrecacheItemByNameSync( "item_herb_butsu", context )
	PrecacheItemByNameSync( "item_herb_orange", context )
	PrecacheItemByNameSync( "item_herb_purple", context )
	PrecacheItemByNameSync( "item_herb_yellow", context )
	PrecacheItemByNameSync( "item_hide_elk", context )
	PrecacheItemByNameSync( "item_hide_jungle_bear", context )
	PrecacheItemByNameSync( "item_hide_wolf", context )
	PrecacheItemByNameSync( "item_ingot_iron", context )
	PrecacheItemByNameSync( "item_ingot_steel", context )
	PrecacheItemByNameSync( "item_magic_raw", context )
	PrecacheItemByNameSync( "item_crystal_mana", context )
	PrecacheItemByNameSync( "item_meat_cooked", context )
	PrecacheItemByNameSync( "item_meat_diseased", context )
	PrecacheItemByNameSync( "item_meat_raw", context )
	PrecacheItemByNameSync( "item_meat_smoked", context )
	PrecacheItemByNameSync( "item_medallion_of_courage", context )
	PrecacheItemByNameSync( "item_mushroom", context )
	PrecacheItemByNameSync( "item_net_basic", context )
	PrecacheItemByNameSync( "item_pinion_fire", context )
	PrecacheItemByNameSync( "item_pinion_pain", context )
	PrecacheItemByNameSync( "item_pinion_shadow", context )
	PrecacheItemByNameSync( "item_potion_acid", context )
	PrecacheItemByNameSync( "item_potion_anabolic", context )
	PrecacheItemByNameSync( "item_potion_anti_magic", context )
	PrecacheItemByNameSync( "item_potion_cure_all", context )
	PrecacheItemByNameSync( "item_potion_disease", context )
	PrecacheItemByNameSync( "item_potion_drunk", context )
	PrecacheItemByNameSync( "item_potion_elemental", context )
	PrecacheItemByNameSync( "item_potion_fervor", context )
	PrecacheItemByNameSync( "item_potion_healingi", context )
	PrecacheItemByNameSync( "item_potion_healingiii", context )
	PrecacheItemByNameSync( "item_potion_healingiv", context )
	PrecacheItemByNameSync( "item_potion_manai", context )
	PrecacheItemByNameSync( "item_potion_manaiii", context )
	PrecacheItemByNameSync( "item_potion_manaiv", context )
	PrecacheItemByNameSync( "item_potion_nether", context )
	PrecacheItemByNameSync( "item_potion_poison", context )
	PrecacheItemByNameSync( "item_potion_poison_ultra", context )
	PrecacheItemByNameSync( "item_potion_twin_island", context )
	PrecacheItemByNameSync( "item_river_root", context )
	PrecacheItemByNameSync( "item_river_stem", context )
	PrecacheItemByNameSync( "item_rock_dark", context )
	PrecacheItemByNameSync( "item_scales_hydra", context )
	PrecacheItemByNameSync( "item_scroll_cyclone", context )
	PrecacheItemByNameSync( "item_scroll_entangling", context )
	PrecacheItemByNameSync( "item_scroll_fireball", context )
	PrecacheItemByNameSync( "item_scroll_living_dead", context )
	PrecacheItemByNameSync( "item_scroll_stoneskin", context )
	PrecacheItemByNameSync( "item_scroll_tsunami", context )
	PrecacheItemByNameSync( "item_seed_magic", context )
	PrecacheItemByNameSync( "item_shield", context )
	PrecacheItemByNameSync( "item_shield_battle", context )
	PrecacheItemByNameSync( "item_shield_bone", context )
	PrecacheItemByNameSync( "item_shield_iron", context )
	PrecacheItemByNameSync( "item_shield_steel", context )
	PrecacheItemByNameSync( "item_ship_transport", context )
	PrecacheItemByNameSync( "item_spear_basic", context )
	PrecacheItemByNameSync( "item_spear_dark", context )
	PrecacheItemByNameSync( "item_spear_iron", context )
	PrecacheItemByNameSync( "item_spear_poison", context )
	PrecacheItemByNameSync( "item_spear_poison_refined", context )
	PrecacheItemByNameSync( "item_spear_poison_ultra", context )
	PrecacheItemByNameSync( "item_spear_steel", context )
	PrecacheItemByNameSync( "item_spirit_water", context )
	PrecacheItemByNameSync( "item_spirit_wind", context )
	PrecacheItemByNameSync( "item_stick", context )
	PrecacheItemByNameSync( "item_stone", context )
	PrecacheItemByNameSync( "item_slot_locked", context )
	PrecacheItemByNameSync( "item_boat_kit_armory", context )
	PrecacheItemByNameSync( "item_boat_shield_basic", context )
	PrecacheItemByNameSync( "item_boat_bone", context )
	PrecacheItemByNameSync( "item_boat_kit_camp_fire", context )
	PrecacheItemByNameSync( "item_boat_ball_clay", context )
	PrecacheItemByNameSync( "item_boat_meat_cooked", context )
	PrecacheItemByNameSync( "item_boat_rock_dark", context )
	PrecacheItemByNameSync( "item_boat_kit_trap_ensnare", context )
	PrecacheItemByNameSync( "item_boat_flint", context )
	PrecacheItemByNameSync( "item_boat_potion_healing_iv", context )
	PrecacheItemByNameSync( "item_boat_axe_iron", context )
	PrecacheItemByNameSync( "item_boat_boots_iron", context )
	PrecacheItemByNameSync( "item_boat_coat_iron", context )
	PrecacheItemByNameSync( "item_boat_gloves_iron", context )
	PrecacheItemByNameSync( "item_boat_ingot_iron", context )
	PrecacheItemByNameSync( "item_boat_spear_iron", context )
	PrecacheItemByNameSync( "item_boat_clay_living", context )
	PrecacheItemByNameSync( "item_boat_kit_fire_mage", context )
	PrecacheItemByNameSync( "item_boat_seed_magic", context )
	PrecacheItemByNameSync( "item_boat_crystal_mana", context )
	PrecacheItemByNameSync( "item_boat_potion_mana_iv", context )
	PrecacheItemByNameSync( "item_boat_kit_mud_hut", context )
	PrecacheItemByNameSync( "item_boat_mushroom", context )
	PrecacheItemByNameSync( "item_boat_nets", context )
	PrecacheItemByNameSync( "item_boat_kit_omnidefender", context )
	PrecacheItemByNameSync( "item_boat_spear_poison", context )
	PrecacheItemByNameSync( "item_boat_scroll_cyclone", context )
	PrecacheItemByNameSync( "item_boat_scroll_entangling", context )
	PrecacheItemByNameSync( "item_boat_scroll_fireball", context )
	PrecacheItemByNameSync( "item_boat_scroll_living_dead", context )
	PrecacheItemByNameSync( "item_boat_scroll_stoneskin", context )
	PrecacheItemByNameSync( "item_boat_kit_smokehouse", context )
	PrecacheItemByNameSync( "item_boat_spear_basic", context )
	PrecacheItemByNameSync( "item_boat_spirit_water", context )
	PrecacheItemByNameSync( "item_boat_axe_steel", context )
	PrecacheItemByNameSync( "item_boat_ingot_steel", context )
	PrecacheItemByNameSync( "item_boat_shield_steel", context )
	PrecacheItemByNameSync( "item_boat_stick", context )
	PrecacheItemByNameSync( "item_boat_stone", context )
	PrecacheItemByNameSync( "item_boat_kit_storage", context )
	PrecacheItemByNameSync( "item_boat_kit_tannery", context )
	PrecacheItemByNameSync( "item_boat_beacon_teleport", context )
	PrecacheItemByNameSync( "item_boat_kit_tent", context )
	PrecacheItemByNameSync( "item_boat_tinder", context )
	PrecacheItemByNameSync( "item_boat_kit_hut_troll", context )
	PrecacheItemByNameSync( "item_boat_kit_workshop", context )
	PrecacheItemByNameSync( "item_debug_spawn_all", context )
	PrecacheItemByNameSync( "item_heat_modifier_applier", context )

	PrecacheUnitByNameSync( "npc_creep_fawn", context )
	PrecacheUnitByNameSync( "npc_creep_wolf_pup", context )
	PrecacheUnitByNameSync( "npc_creep_bear_cub", context )
	PrecacheUnitByNameSync( "npc_creep_mammoth_baby", context )
	PrecacheUnitByNameSync( "npc_creep_elk_pet", context )
	PrecacheUnitByNameSync( "npc_creep_elk_adult", context )
	PrecacheUnitByNameSync( "npc_creep_bear_jungle_adult", context )
	PrecacheUnitByNameSync( "npc_creep_drake_bone", context )
	PrecacheUnitByNameSync( "npc_creep_harpy_red", context )
	PrecacheUnitByNameSync( "npc_creep_bat_forest", context )
	PrecacheUnitByNameSync( "npc_creep_drake_nether", context )
	PrecacheUnitByNameSync( "npc_creep_fish", context )
	PrecacheUnitByNameSync( "npc_creep_fish_green", context )
	PrecacheUnitByNameSync( "npc_creep_fish_green", context )
	PrecacheUnitByNameSync( "npc_creep_elk_wild", context )
	PrecacheUnitByNameSync( "npc_creep_hawk", context )
	PrecacheUnitByNameSync( "npc_creep_wolf_jungle", context )
	PrecacheUnitByNameSync( "npc_creep_wolf_ice", context )
	PrecacheUnitByNameSync( "npc_creep_wolf_adult_jungle", context )
	PrecacheUnitByNameSync( "npc_creep_bear_jungle", context )
	PrecacheUnitByNameSync( "npc_creep_lizard", context )
	PrecacheUnitByNameSync( "npc_creep_panther", context )
	PrecacheUnitByNameSync( "npc_creep_panther_elder", context )
	PrecacheUnitByNameSync( "npc_dota_hero_shadow_shaman", context )
	PrecacheUnitByNameSync( "npc_hero_herbmaster_tele_gatherer", context )
	PrecacheUnitByNameSync( "npc_hero_radar_tele_gatherer", context )
	PrecacheUnitByNameSync( "npc_hero_remote_tele_gatherer", context )
	PrecacheUnitByNameSync( "npc_dota_hero_troll_warlord", context )
	PrecacheUnitByNameSync( "npc_dota_hero_huskar", context )
	PrecacheUnitByNameSync( "npc_hero_hunter_tracker", context )
	PrecacheUnitByNameSync( "npc_hero_hunter_warrior", context )
	PrecacheUnitByNameSync( "npc_hero_hunter_juggernaught", context )
	PrecacheUnitByNameSync( "npc_dota_hero_witch_doctor", context )
	PrecacheUnitByNameSync( "npc_hero_mage_elementalist", context )
	PrecacheUnitByNameSync( "npc_hero_mage_hypnotist", context )
	PrecacheUnitByNameSync( "npc_hero_mage_dementia_master", context )
	PrecacheUnitByNameSync( "npc_dota_hero_lion", context )
	PrecacheUnitByNameSync( "npc_hero_scout_observer", context )
	PrecacheUnitByNameSync( "npc_hero_scout_radar", context )
	PrecacheUnitByNameSync( "npc_hero_scout_spy", context )
	PrecacheUnitByNameSync( "npc_dota_hero_riki", context )
	PrecacheUnitByNameSync( "npc_hero_theif_escape_artist", context )
	PrecacheUnitByNameSync( "npc_hero_theif_contortionist", context )
	PrecacheUnitByNameSync( "npc_hero_theif_assassin", context )
	PrecacheUnitByNameSync( "npc_dota_hero_lycan", context )
	PrecacheUnitByNameSync( "npc_hero_beastmaster_packleader", context )
	PrecacheUnitByNameSync( "npc_hero_beastmaster_form_chicken", context )
	PrecacheUnitByNameSync( "npc_hero_beastmaster_shapeshifter", context )
	PrecacheUnitByNameSync( "npc_dota_hero_dazzle", context )
	PrecacheUnitByNameSync( "npc_hero_priest_booster", context )
	PrecacheUnitByNameSync( "npc_hero_priest_master_healer", context )
	PrecacheUnitByNameSync( "npc_hero_priest_sage", context )
	PrecacheUnitByNameSync(	"scout_ward", context)

	PrecacheResource("model", "models/props_debris/camp_fire001.vmdl",context)
	PrecacheResource("model", "models/props_structures/tent_dk_small.vmdl",context)
	PrecacheResource("model", "models/props_structures/sniper_hut.vmdl",context)
	PrecacheResource("model", "models/props_debris/secret_shop001.vmdl",context)
	PrecacheResource("model", "models/props_structures/tent_dk_large.vmdl",context)
	PrecacheResource("model", "models/props_structures/good_shop001.vmdl",context)
	PrecacheResource("model", "models/props_structures/tent_dk_med.vmdl",context)
	PrecacheResource("model", "models/props_structures/shop_newplayerexperience_01.vmdl",context)
	PrecacheResource("model", "models/props_structures/sideshop_radiant002.vmdl",context)
	PrecacheResource("model", "models/props_tree/stump001",context)
	PrecacheResource("model", "models/props_structures/wooden_sentry_tower001.vmdl",context)
	PrecacheResource("model", "models/items/lone_druid/bear_trap/bear_trap.vmdl",context)
	PrecacheResource("model", "models/heroes/witchdoctor/witchdoctor_ward.vmdl",context)
	PrecacheResource("model", "models/items/wards/nexon_sotdaeward/nexon_sotdaeward.vmdl",context)
	PrecacheResource("model", "models/items/furion/staff_eagle_1.vmdl",context)
	PrecacheResource("model", "models/courier/drodo/drodo.vmdl",context)
	PrecacheResource("model", "models/courier/skippy_parrot/skippy_parrot_flying_sailboat.vmdl",context)
	PrecacheResource("model", "models/courier/skippy_parrot/skippy_parrot_flying_rowboat.vmdl",context)
	PrecacheResource("model", "models/props_structures/boat_dragonknight.vmdl",context)	
	PrecacheResource("model", "models/items/warlock/warlocks_summoning_scroll/warlocks_summoning_scroll.vmdl",context)
	
	PrecacheResource("particle_folder","particles/dire_fx",context)
	PrecacheResource("particle_folder","particles/winter_fx",context)
	PrecacheResource("particle_folder","particles/rain_fx",context)
	PrecacheResource("particle_folder","particles/rain_storm_fx",context)
	PrecacheResource("particle_folder","particles/world_environmental_fx",context)
	
	PrecacheResource("model", "models/props_destruction/lion_groundspikes.vmdl",context)
	PrecacheResource("model", "models/items/abaddon/alliance_abba_weapon/alliance_abba_weapon_fx.vmdl",context)
	PrecacheResource("model", "models/particle/tiny_simrocks.vmdl",context)
	PrecacheResource("model", "models/particle/ice_shards.vmdl",context)
	PrecacheResource("model", "models/projectiles/projectile_jar.vmdl",context)
	PrecacheResource("model", "models/items/brewmaster/offhand_jug/offhand_jug.vmdl",context)
	
	
	PrecacheResource("particle_folder", "particles/items_fx",context)
	PrecacheResource("particle_folder", "particles/items2_fx",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_items.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_nyx_assassin",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts",context)
	PrecacheResource("soundfile", "soundevents/game_sounds/ability_catapult_attack.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_venomancer",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_invoker",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_gyrocopter",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_pugna",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_dragon_knight",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_lone_druid",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_rubick",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_brewmaster",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_treant",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts",context)
	PrecacheResource("particle_folder", "particles/econ/generic/generic_buff_1/",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_morphling",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts",context)
	PrecacheResource("particle_folder", "particles/econ/generic/generic_projectile_linear_1",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_tinker",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_bristleback",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_alchemist",context)
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_omniknight",context)
	PrecacheResource("particle_folder", "particles/status_fx",context)

		local heroTable = {		
		"npc_dota_hero_shadow_shaman",
		"npc_hero_herbmaster_tele_gatherer",
		"npc_hero_radar_tele_gatherer",
		"npc_hero_remote_tele_gatherer",
		"npc_dota_hero_huskar",
		"npc_hero_hunter_tracker",
		"npc_hero_hunter_warrior",
		"npc_hero_hunter_juggernaught",
		"npc_dota_hero_witch_doctor",
		"npc_hero_mage_elementalist",
		"npc_hero_mage_hypnotist",
		"npc_hero_mage_dementia_master",
		"npc_dota_hero_lion",
		"npc_hero_scout_observer",
		"npc_hero_scout_radar",
		"npc_hero_scout_spy",
		"npc_dota_hero_riki",
		"npc_hero_thief_escape_artist",
		"npc_hero_thief_contortionist",
		"npc_hero_thief_assassin",
		"npc_dota_hero_lycan",
		"npc_hero_beastmaster_packleader",
		"npc_hero_beastmaster_form_chicken",
		"npc_hero_beastmaster_shapeshifter",
		"npc_dota_hero_dazzle",
		"npc_hero_priest_booster",
		"npc_hero_priest_master_healer",
		"npc_hero_priest_sage"}

	for key,value in pairs(heroTable) do
		PrecacheUnitByNameSync(value, context)
	end

	local creepTable = {		
		"npc_creep_fawn",
		"npc_creep_wolf_pup",
		"npc_creep_bear_cub",
		"npc_creep_mammoth_baby",
		"npc_creep_elk_pet",
		"npc_creep_elk_adult",
		"npc_creep_bear_jungle_adult",
		"npc_creep_drake_bone",
		"npc_creep_harpy_red",
		"npc_creep_bat_forest",
		"npc_creep_drake_nether",
		"npc_creep_fish",
		"npc_creep_fish_green",
		"npc_creep_elk_wild",
		"npc_creep_hawk",
		"npc_creep_wolf_jungle",
		"npc_creep_wolf_ice",
		"npc_creep_wolf_adult_jungle",
		"npc_creep_bear_jungle",
		"npc_creep_lizard",
		"npc_creep_panther",
		"npc_creep_panther_elder"}
	for key,value in pairs(creepTable) do
		PrecacheUnitByNameSync(value, context)
	end

	local bushTable = {		
		"npc_bush_herb",
		"npc_bush_herb_yellow",
		"npc_bush_herb_blue",
		"npc_bush_herb_orange",
		"npc_bush_herb_purple",
		"npc_bush_thistle",
		"npc_bush_stash",
		"npc_bush_river",
		"npc_bush_thief",
		"npc_bush_scout",}
	for key,value in pairs(bushTable) do
		PrecacheUnitByNameSync(value, context)
	end

	PrecacheItemByNameSync("item_building_kit_fire_basic", context)

	print("Precache Finish")
end

--[[
    Create the game mode and our custom rules
    This is run once the engine has launched
]]--
function Activate()
    print("Activate Called")

	require( 'custom_functions_item' )
	require( 'custom_functions_ability' )
	require( 'logic_creature' )
	require( 'logic_troll' )

	require( 'buildinghelper' )


    GameRules.AddonTemplate = ITT_GameMode()
    GameRules.AddonTemplate:InitGameMode()

    BuildingHelper = BuildingHelper()
end







