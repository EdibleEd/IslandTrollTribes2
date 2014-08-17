--[[
    Imported files
]]

--require()

--[[
    Global variables
]]

GAME_TICK_TIME = 0.1  -- The game should update every half second

--[[
    Default cruft to set everything up
    In the game creation trace, this runs after 
        S:Gamerules: entering state 'DOTA_GAMERULES_STATE_INIT' - base DOTA2 rules that we can't change ar eloaded here
        SV:  Spawn Server: template_map - where the map is loaded on the server
    It runs before any of these events: 
        Precaching
        CL:  CWaitForGameServerStartupPrerequisite - this is where the sever signals it is ready to be connected to
        CL:  CCreateGameClientJob - this creates the creating client connection to server
]]
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
]]
function Precache( context )
    print("Precache called")
    --PrecacheUnitByNameSync("npc_dota_creature_gnoll_assassin", context)
end

--[[
    Create the game mode and our custom rules
    This is run once the engine has launched
]]
function Activate()
    print("Activate Called")
    GameRules.AddonTemplate = ITT_GameMode()
    GameRules.AddonTemplate:InitGameMode()
end

--[[
    Here is where we run the code that occurs when the game starts
    This is run once the engine has launched

    Some useful things to do here:

    Set the hero selection time. Make this 0.0 if you have you rown hero selection system (like wc3 taverns)
        GameRules:SetHeroSelectionTime( [time] )
]]
function ITT_GameMode:InitGameMode()
    print( "Game mode setup." )
    -- Set the game's thinker up
    -- SetThink( [script function to run], [target to run thinker on], [thinker slot],  [delay before thinking occurs] )
    GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )

    GameRules:GetGameModeEntity():ClientLoadGridNav()
    GameRules:SetPreGameTime(0.0)

    GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

    -- Listen for a game event.
    -- A list of events is findable here: https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Engine_Events
    -- A bunch of those are broken, so be warned
    -- Custom events can be made in /scripts/custom_events.txt
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(ITT_GameMode, 'OnPlayerConnectFull'), self)

    -- cvar_setf("dota_hide_cursor", 0.0)
end

--[[
    This is the game's thinker.
    It will run every "tick"

    If this doesn't return a value it will not continue to be called
    If this returns a value, it will return the time (in seconds) until it needs to be called again

    GameRules:State_Get() returns the current game state
        2   Hero select
        4   Hero selected
        5   Battle has begun
]]
function ITT_GameMode:OnThink()
    --print(GameRules:State_Get())
    return GAME_TICK_TIME
end

function ITT_GameMode:OnPlayerConnectFull(keys)
    local playerID = keys.index + 1
    local player = PlayerInstanceFromIndex(playerID)
    print( "Player " .. playerID .. " connected")
    --DebugDrawBox(PlayerInstanceFromIndex(playerID):GetCursorPosition(), Vector(50,50), Vector(150,150), 100, 100, 100, 255, 10.0) 
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

