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
	
	PrecacheItemByNameSync( "item_tinder", context )
	PrecacheItemByNameSync( "item_raw_meat", context )
	PrecacheItemByNameSync( "item_bone", context )

	PrecacheUnitByNameSync( "npc_dota_creature_elk", context )
	PrecacheUnitByNameSync( "npc_dota_creature_hawk", context )

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
	PrecacheResource("model", "models/items/warlock/warlocks_summoning_scroll/warlocks_summoning_scroll.vmdl",context)
	
	PrecacheResource("particle_folder","particles/dire_fx",context)
	PrecacheResource("particle_folder","particles/winter_fx",context)
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
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts",context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_omniknight",context)

		local unitTable = {		
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

	for key,value in pairs(unitTable) do
		PrecacheUnitByNameSync(value, context)
	end

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







