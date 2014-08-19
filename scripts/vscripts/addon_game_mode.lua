--[[
    Imported files
]]

--helps find file that makes items dropping on death work
require( "itemfunctions" )
require( 'spawnanimals' )
require( 'troll' )


--[[
    Global variables
]]--

GAME_TICK_TIME              = 0.1  -- The game should update every half second
GAME_CREATURE_TICK_TIME     = 10
GAME_TROLL_TICK_TIME        = 0.5  -- Its really like its wc3!
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
    PrecacheModel( "Elk", context )
    PrecacheUnitByNameAsync( "Elk", context )
    PrecacheModel( "Hawk", context )
    PrecacheUnitByNameAsync( "Hawk", context )
    -- testing if stuff works regardless of custom units
    PrecacheUnitByNameAsync( "npc_dota_hero_axe", context )
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
    -- Set the game's thinkers up

    -- This is the global thinker. It should only manage game state
    GameRules:GetGameModeEntity():SetThink( "OnStateThink", self, "StateThink", 2 )

    -- This is the creature thinker. All spawn logic goes here
    GameRules:GetGameModeEntity():SetThink( "OnCreatureThink", self, "CreatureThink", 2 )

    -- This is the troll thinker. All logic on the player's heros should be checked here
    GameRules:GetGameModeEntity():SetThink( "OnTrollThink", self, "TrollThink", 1 )

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

function ITT_GameMode:OnTrollThink()

    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        return 1
    end

    for i=1, maxPlayerID, 1 do
        ITT_TrollController:HeatLoss(i)
        ITT_TrollController:InventoryCheck(i)
    end

    return GAME_TROLL_TICK_TIME
end

function ITT_GameMode:OnCreatureThink()
    for i=1, 4, 1 do
        ITT_AnimalSpawner:SpawnCreature("elk", i)
        ITT_AnimalSpawner:SpawnCreature("hawk", i)
    end
    return GAME_CREATURE_TICK_TIME
end

function ITT_GameMode:OnStateThink()
    --print(GameRules:State_Get())
    return GAME_TICK_TIME
end

function ITT_GameMode:OnPlayerConnectFull(keys)
    local playerID = keys.index + 1
    --local player = PlayerInstanceFromIndex(playerID)
    print( "Player " .. playerID .. " connected")

    playerList[playerID] = playerID
    maxPlayerID = maxPlayerID + 1
end

function checkKeys(keys)
    for key, value in pairs(keys) do
        print (key,value)
        checkType(value)
    end
end    

function checkType(stuff)
    if (type(stuff)=="table") then
            for k, v in pairs(stuff) do
                print(k,v)
                checkType(v)
            end
    end
end

