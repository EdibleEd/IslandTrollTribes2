--[[
    Imported files
]]

--helps find file that makes items dropping on death work
require( 'itemfunctions' )
require( 'spawnanimals' )
require( 'troll' )
require('buildinghelper')

--[[
    Global variables
]]--

GAME_TICK_TIME              = 0.1  -- The game should update every half second
GAME_CREATURE_TICK_TIME     = 10
GAME_TROLL_TICK_TIME        = 0.5  -- Its really like its wc3!
GAME_ITEM_TICK_TIME         = 30  -- Spawn items every 30?
playerList = {}
maxPlayerID = 0

--[[
    Default cruft to set everything up
    In the game creation trace, this runs after 
        S:Gamerules: entering state 'DOTA_GAMERULES_STATE_INIT' - base DOTA2 rules that we can't change ar eloaded here
        SV:  Spawn Server: template_map - where the map is loaded on the server
    It runs before any of these events: 
        Precaching
        CL:  CWaitForGameServerStartupPrerequisite - this is where the sever signals it is ready to be connected to
        CL:  CCreateGameClientJob - this creates the creating client connection to server
]]--
if ITT_GameMode == nil then
    print("Script execution begin")
    ITT_GameMode = class({})
    -- LoadKeyValues(filename a) 
end

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
		print("Precache Finish")
end

--[[
    Create the game mode and our custom rules
    This is run once the engine has launched
]]--
function Activate()
    print("Activate Called")
    GameRules.AddonTemplate = ITT_GameMode()
    GameRules.AddonTemplate:InitGameMode()

    ITT_AnimalSpawner = ITT_AnimalSpawner()
    ITT_TrollController = ITT_TrollController()
end

--[[
    Here is where we run the code that occurs when the game starts
    This is run once the engine has launched

    Some useful things to do here:

    Set the hero selection time. Make this 0.0 if you have you rown hero selection system (like wc3 taverns)
        GameRules:SetHeroSelectionTime( [time] )
]]--
function ITT_GameMode:InitGameMode()
    print( "Game mode setup." )
	BuildingHelper:BlockGridNavSquares(16384)
    -- Set the game's thinkers up

    -- This is the global thinker. It should only manage game state
    GameRules:GetGameModeEntity():SetThink( "OnStateThink", self, "StateThink", 2 )

    -- This is the creature thinker. All neutral creature spawn logic goes here
    GameRules:GetGameModeEntity():SetThink( "OnCreatureThink", self, "CreatureThink", 2 )

    -- This is the troll thinker. All logic on the player's heros should be checked here
    GameRules:GetGameModeEntity():SetThink( "OnTrollThink", self, "TrollThink", 0 )

    -- This is the item thinker. All random item spawn logic goes here
    GameRules:GetGameModeEntity():SetThink( "OnItemThink", self, "ItemThink", 0 )
    
    GameRules:GetGameModeEntity():ClientLoadGridNav()
    GameRules:SetTimeOfDay( 0.75 )
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:SetHeroSelectionTime( 30.0 )
    GameRules:SetPreGameTime( 10.0 )
    GameRules:SetPostGameTime( 60.0 )
    GameRules:SetTreeRegrowTime( 60.0 )
    GameRules:SetHeroMinimapIconSize( 400 )
    GameRules:SetCreepMinimapIconScale( 0.7 )
    GameRules:SetRuneMinimapIconScale( 0.7 )
    GameRules:SetGoldTickTime( 60.0 )
    GameRules:SetGoldPerTick( 0 )

    -- Listen for a game event.
    -- A list of events is findable here: https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Engine_Events
    -- A bunch of those are broken, so be warned
    -- Custom events can be made in /scripts/custom_events.txt
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(ITT_GameMode, 'OnPlayerConnectFull'), self)
    
end
-- This updates state on each troll
-- Every half second it updates heat, checks inventory for items, etc
-- Add anything you want to run regularly on each troll to this
function ITT_GameMode:OnTrollThink()

    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        -- Will not run until pregame ends
        return 1
    end
    
    -- This will run on every player, do stuff here
    for i=1, maxPlayerID, 1 do
        ITT_TrollController:Hunger(i)
        ITT_TrollController:InventoryCheck(i)
    end

    return GAME_TROLL_TICK_TIME
end

-- This is similar, but handles spawning creatures
function ITT_GameMode:OnCreatureThink()
    for i=1, 4, 1 do
        ITT_AnimalSpawner:SpawnCreature("elk", i)
        ITT_AnimalSpawner:SpawnCreature("hawk", i)
    end
    return GAME_CREATURE_TICK_TIME
end

-- This will handle item spawns when they are implemented
function ITT_GameMode:OnItemThink()
    return GAME_ITEM_TICK_TIME
end

-- This will handle anything gamestate related that is not covered under other thinkers
function ITT_GameMode:OnStateThink()
    --print(GameRules:State_Get())

    for _,heroEntity in ipairs( HeroList:GetAllHeroes() ) do
        local name = heroEntity:GetUnitName()
        local playerEntity = heroEntity:GetPlayerOwner()

        if heroEntity:GetItemInSlot(0) ~= nil then
            local item = heroEntity:GetItemInSlot(0):GetName() 
            local troll = ""

            if item == "item_trolltype1" then
                troll = "npc_dota_hero_huskar"
            end
            if item == "item_trolltype2" then
                troll = "npc_dota_hero_witch_doctor"
            end
            if item == "item_trolltype3" then
                troll = "npc_dota_hero_dazzle"
            end
            if item == "item_trolltype4" then
                troll = "npc_dota_hero_troll_warlord"
            end


            if name == "npc_dota_hero_axe" then
                playerEntity:SetTeam(1)
                print(playerEntity:GetTeam())

                PlayerResource:ReplaceHeroWith( playerEntity:GetPlayerID(), troll, 100, 0 )
                print("Team 1 joined")
            end
            if name == "npc_dota_hero_tidehunter" then
                playerEntity:SetTeam(2)
                print(playerEntity:GetTeam())

                PlayerResource:ReplaceHeroWith( playerEntity:GetPlayerID(), troll, 100, 0 )
                print("Team 2 joined")
            end
            if name == "npc_dota_hero_storm_spirit" then
                playerEntity:SetTeam(3)
                print(playerEntity:GetTeam())

                PlayerResource:ReplaceHeroWith( playerEntity:GetPlayerID(), troll, 100, 0 )
                print("Team 3 joined")
            end
        end
    end

    --GameRules:MakeTeamLose(3)
    -- GameRules:SetGameWinner(1)
    --local player = PlayerInstanceFromIndex(1)
    --print(player:GetAssignedHero())
    --player:SetTeam(2)
    --print(player:GetTeam())





    return GAME_TICK_TIME
end


-- When players connect, add them to the players list and begin operations on them
function ITT_GameMode:OnPlayerConnectFull(keys)
    local playerID = keys.index + 1
    --local player = PlayerInstanceFromIndex(playerID)
    print( "Player " .. playerID .. " connected")

    playerList[playerID] = playerID
    maxPlayerID = maxPlayerID + 1

    local creature = CreateUnitByName("npc_dota_creature_elk", RandomVector(RandomFloat(0,200)), true, nil, nil, DOTA_TEAM_BADGUYS)
end

-- Prints recursively contents of a table
function checkKeys(keys)
    for key, value in pairs(keys) do
        print (key,value)
        checkType(value)
    end
end    

-- helper function for checkKeys
function checkType(stuff)
    if (type(stuff)=="table") then
            for k, v in pairs(stuff) do
                print(k,v)
                checkType(v)
            end
    end
end

