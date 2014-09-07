--[[
    The purpose of this file is mostly to exist because it is required.
    Deal with all precaching here, to keep it out of the way.
]]--

print("addon_game_mode invoked")

--[[
    We want to precache resources we want to use, so they are ready for loading when the engine requires
    Precache things we know we'll use.  Possible file types include (but not limited to):
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

    PrecacheUnitByNameSync( "npc_dota_hero_huskar", context )
    PrecacheUnitByNameSync( "npc_dota_hero_witch_doctor", context )
    PrecacheUnitByNameSync( "npc_dota_hero_dazzle", context )
    PrecacheUnitByNameSync( "npc_dota_hero_troll_warlord", context )

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
	PrecacheResource("particle","particles/dire_fx/fire_barracks_glow_b.vpcf",context)
    
    PrecacheResource("model", 'models/props_destruction/lion_groundspikes.vmdl',context)
    PrecacheResource("model", 'models/items/abaddon/alliance_abba_weapon/alliance_abba_weapon_fx.vmdl',context)
    PrecacheResource("model", 'models/particle/tiny_simrocks.vmdl',context)
    PrecacheResource("model", 'models/particle/ice_shards.vmdl',context)
	
    print("Precache Finish")
end







