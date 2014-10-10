--[[
	This is where the meat of the addon is defined and modified
	This file exists mostly because addon_game_mode can't be dynamically reloaded
]]--

print("addon_init invoked")

require( 'util' )
require("recipe_list")

--[[
    Global variables
]]--

playerList = {}
maxPlayerID = 0

GAME_TICK_TIME              = 0.1  	-- The game should update every tenth second
GAME_CREATURE_TICK_TIME     = 10
GAME_TROLL_TICK_TIME        = 0.5  	-- Its really like its wc3!
--GAME_ITEM_TICK_TIME         = 30  	-- Spawn items every 30?
FLASH_ACK_THINK             = 2

BUILDING_TICK_TIME 			= 0.03
DROPMODEL_TICK_TIME         = 0.03

itemKeyValues = LoadKeyValues("scripts/npc/npc_items_custom.txt")

--[[
    This is all used for item spawning

    Globals related to item spawns, mostly taken from
    https://github.com/island-troll-tribes/wc3-client/blob/1562854dd098180752f0f4a99df0c4968697b38b/src/lib/PublicLibrary.j
    and
    https://github.com/island-troll-tribes/wc3-client/blob/1562854dd098180752f0f4a99df0c4968697b38b/src/init/objects/Globals.j
]]--

-- Regions of the map in xmin xmax, ymin, ymax as a box, and an int as a spawnrate
-- Currently just a placeholder region called CENTER till I get a proper map
REGIONS                     = {}
-- CENTER                      = {}
TOPLEFT                     = {-8000, -600, 8000, 500, 1}  --{xmin, xmax, ymin, ymax, spawnrate}
TOPRIGHT                    = {550, 8000, 8000, 800, 1}
BOTTOMRIGHT                 = {-1100, -8000, -600, -8000, 1}
BOTTOMLEFT                  = {950, 8000, -350, -8000, 1}
-- -- Bounding box
-- TOPLEFT[1]                   = -8000
-- TOPLEFT[2]                   = -600
-- TOPLEFT[3]                   = 8000
-- TOPLEFT[4]                   = 500
-- -- Spawnrate for CENTER
-- TOPLEFT[5]                   = 1

-- -- Bounding box
-- CENTER[1]                   = -1000
-- CENTER[2]                   = 1000
-- CENTER[3]                   = -1000
-- CENTER[4]                   = 1000
-- -- Spawnrate for CENTER
-- CENTER[5]                   = 1

-- Only region is CENTER
REGIONS[1]                  = TOPLEFT
REGIONS[2]                  = TOPRIGHT
REGIONS[3]                  = BOTTOMRIGHT
REGIONS[4]                  = BOTTOMLEFT

-- Tick time is 300s
-- https://github.com/island-troll-tribes/wc3-client/blob/1562854dd098180752f0f4a99df0c4968697b38b/src/systems/spawning/Spawn%20Normal.j#L3
-- GAME_ITEM_TICK_TIME         = 300    

-- Using a shorter time for testing's sake
GAME_ITEM_TICK_TIME         = 15

-- Spawnrates of items, seeded with initial rates from
-- https://github.com/island-troll-tribes/wc3-client/blob/1562854dd098180752f0f4a99df0c4968697b38b/src/init/objects/Globals.j
TINDER_RATE                 = 5.00
FLINT_RATE                  = 3.00
STICK_RATE                  = 3.00
CLAYBALL_RATE               = 1.00
STONE_RATE                   = 1.00
MANACRYSTAL_RATE            = 0.00
MAGIC_RATE                  = 0.5

-- Relative rates start at 0 but get set such that all should sum to one on first call
REL_TINDER_RATE             = 0 
REL_FLINT_RATE              = 0
REL_STICK_RATE              = 0
REL_CLAYBALL_RATE           = 0
REL_STONE_RATE               = 0
REL_MANACRYSTAL_RATE        = 0
REL_MAGIC_RATE              = 0

-- Controls the base item spawn rate 
ITEM_BASE                   = 1


--[[
    Default cruft to set everything up
    In the game creation trace, this runs after 
        S:Gamerules: entering state 'DOTA_GAMERULES_STATE_INIT' - base DOTA2 rules that we can't change are loaded here
        SV:  Spawn Server: template_map - where the map is loaded on the server
    It runs before any of these events: 
        Precaching
        CL:  CWaitForGameServerStartupPrerequisite - this is where the sever signals it is ready to be connected to
        CL:  CCreateGameClientJob - this creates the creating client connection to server
]]--

if ITT_GameMode == nil then
    print("ITT Script execution begin")
    ITT_GameMode = class({})
    -- LoadKeyValues(filename a) 
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

	Convars:RegisterConvar('itt_set_game_mode', nil, 'Set to the game mode', FCVAR_PROTECTED)

	GameMode = GameRules:GetGameModeEntity()

    -- Set the game's thinkers up

    -- This is the global thinker. It should only manage game state
    GameMode:SetThink( "OnStateThink", ITT_GameMode, "StateThink", 2 )

    -- This is the creature thinker. All neutral creature spawn logic goes here
    GameMode:SetThink( "OnCreatureThink", ITT_GameMode, "CreatureThink", 2 )

    -- This is the troll thinker. All logic on the player's heros should be checked here
    GameMode:SetThink( "OnTrollThink", ITT_GameMode, "TrollThink", 0 )

    -- This is the building thinker. All logic on building crafting goes here
    GameMode:SetThink( "OnBuildingThink", ITT_GameMode, "BuildingThink", 0 )

    -- This is the item thinker. All random item spawn logic goes here
    GameMode:SetThink( "OnItemThink", ITT_GameMode, "ItemThink", 0 )

    -- This is the thinker that checks building placement
    GameMode:SetThink("Think", BuildingHelper, "buildinghelper", 0)

    GameMode:SetThink("FixDropModels", ITT_GameMode, "FixDropModels", 0)

    GameMode:SetThink("FlashAckThink", ITT_GameMode, "FlashAckThink", 0)

    
    GameRules:GetGameModeEntity():ClientLoadGridNav()
    GameRules:SetTimeOfDay( 0.75 )
    GameRules:SetHeroRespawnEnabled( false )
    GameRules:SetHeroSelectionTime( 30.0 )
    GameRules:SetPreGameTime( 60.0 )
    GameRules:SetPostGameTime( 60.0 )
    GameRules:SetTreeRegrowTime( 60.0 )
--    GameRules:SetHeroMinimapIconSize( 400 )
    GameRules:SetCreepMinimapIconScale( 0.7 )
    GameRules:SetRuneMinimapIconScale( 0.7 )
    GameRules:SetGoldTickTime( 60.0 )
    GameRules:SetGoldPerTick( 0 )

    -- Listen for a game event.
    -- A list of events is findable here: https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Engine_Events
    -- A bunch of those are broken, so be warned
    -- Custom events can be made in /scripts/custom_events.txt
    -- BROKEN:
    -- dota_item_drag_end dota_item_drag_begin dota_inventory_changed dota_inventory_item_changed  
    -- dota_inventory_changed_query_unit dota_inventory_item_added
    -- WORK:
    -- dota_item_picked_up dota_item_purchased
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(ITT_GameMode, 'OnPlayerConnectFull'), self) 
   
	-- Use this for assigning items to heroes initially once they pick their hero.
	ListenToGameEvent( "dota_player_pick_hero", Dynamic_Wrap( ITT_GameMode, "OnPlayerPicked" ), self )
	
	-- Use this for dealing with subclass spawning
   	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( ITT_GameMode, "OnNPCSpawned" ), self )	

    --Listener for items picked up, used for telegather abilities
    ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(ITT_GameMode, 'OnItemPickedUp'), self)

    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(ITT_GameMode, 'OnPlayerGainedLevel'), self) 
	
	--Listener for storing hero information and revive
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(ITT_GameMode, 'On_dota_player_killed'), self)

    -- Listener for drops and for removing buildings from block table
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( ITT_GameMode, "OnEntityKilled" ), self ) 

    --for multiteam
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( ITT_GameMode, 'OnGameRulesStateChange' ), self )

    --multiteam stuff
    self.m_TeamColors = {}
    print("DOTA_TEAM_GOODGUYS "..DOTA_TEAM_GOODGUYS, "DOTA_TEAM_BADGUYS "..DOTA_TEAM_BADGUYS, "DOTA_TEAM_CUSTOM_1 "..DOTA_TEAM_CUSTOM_1)
    self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 255, 0, 0 }
    self.m_TeamColors[DOTA_TEAM_BADGUYS] = { 0, 255, 0 }
    self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 0, 0, 255 }
    print(self.m_TeamColors[DOTA_TEAM_GOODGUYS], self.m_TeamColors[DOTA_TEAM_BADGUYS], self.m_TeamColors[DOTA_TEAM_CUSTOM_1])

    self.m_VictoryMessages = {}
    self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
    self.m_VictoryMessages[DOTA_TEAM_BADGUYS] = "#VictoryMessage_BadGuys"
    self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"

    self.m_GatheredShuffledTeams = {}
    self.m_NumAssignedPlayers = 0

    self:GatherValidTeams()

    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
end

-- This code is written by Internet Veteran, handle with care.
--Distribute slot locked item based off of the class.
function ITT_GameMode:OnPlayerPicked( keys ) 
    local spawnedUnit = EntIndexToHScript( keys.heroindex )
    local itemslotlock1 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)
    local itemslotlock2 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)
    local itemslotlock3 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)

 	if spawnedUnit:GetClassname() == "npc_dota_hero_witch_doctor" then
 		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_huskar" then
 		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
        spawnedUnit:AddItem(itemslotlock3)	
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_lion" then
 		spawnedUnit:AddItem(itemslotlock1)
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_shadow_shaman" then
		print(spawnedUnit:GetClassname() .. " is a gatherer")
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_dazzle" then
 		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_riki" then
  		spawnedUnit:AddItem(itemslotlock1)
	elseif spawnedUnit:GetClassname() == "npc_dota_hero_lycan" then
  		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
	else
	print(spawnedUnit:GetUnitName() .. " is a non baseclass")
	end

    --heat handling
    if string.find(spawnedUnit:GetClassname(), "hero") then
        print("HEAT1!")
        spawnedUnit:RemoveModifierByName("modifier_heat_passive")
        local heatApplier = CreateItem("item_heat_modifier_applier", spawnedUnit, spawnedUnit)
        heatApplier:ApplyDataDrivenModifier(spawnedUnit, spawnedUnit, "modifier_heat_passive", {duration=-1})
        spawnedUnit:SetModifierStackCount("modifier_heat_passive", nil, 100)
        --heatApplier:RemoveSelf()
    end
end
	
-- This code is written by Internet Veteran, handle with care.
--Do the same now for the subclasses
function ITT_GameMode:OnNPCSpawned( keys ) 
    local spawnedUnit = EntIndexToHScript( keys.entindex )
    local itemslotlock1 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)
    local itemslotlock2 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)
    local itemslotlock3 = CreateItem("item_slot_locked", spawnedUnit, spawnedUnit)
    print("spawned unit: ", spawnedUnit:GetUnitName(), spawnedUnit:GetClassname(), spawnedUnit:GetName(), spawnedUnit:GetEntityIndex())
    if string.find(spawnedUnit:GetUnitName(), "mage") then
    		spawnedUnit:AddItem(itemslotlock1)
    	spawnedUnit:AddItem(itemslotlock2)
     --	if spawnedUnit:GetClassname() == "hunter" then
    elseif string.find(spawnedUnit:GetUnitName(), "hunter") then
    		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
    	spawnedUnit:AddItem(itemslotlock3)
     --	if spawnedUnit:GetClassname() == "scout" then
    elseif string.find(spawnedUnit:GetUnitName(), "scout") then
    		spawnedUnit:AddItem(itemslotlock1)
     --	if spawnedUnit:GetClassname() == "priest" then
     -- if spawnedUnit:(string.find(targetName,"priest") ~= nil) then 
    elseif string.find(spawnedUnit:GetUnitName(), "priest") then
    		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
     --	if spawnedUnit:GetClassname() == "theif" then
     -- if spawnedUnit:(string.find(targetName,"thief") ~= nil) then 
     elseif string.find(spawnedUnit:GetUnitName(), "thief") then
    		spawnedUnit:AddItem(itemslotlock1)
     --	if spawnedUnit:GetClassname() == "beastmaster" then
     -- if spawnedUnit:(string.find(targetName,"beastmaster") ~= nil) then 
    elseif string.find(spawnedUnit:GetUnitName(), "beastmaster") then
    		spawnedUnit:AddItem(itemslotlock1)
        spawnedUnit:AddItem(itemslotlock2)
    else  
    print(spawnedUnit:GetUnitName() .. " is not a subclass")
    	end 

    --heat handling
    if string.find(spawnedUnit:GetUnitName(), "hero") then
        print("HEAT2!")
        spawnedUnit:RemoveModifierByName("modifier_heat_passive") 
        local heatApplier = CreateItem("item_heat_modifier_applier", spawnedUnit, spawnedUnit)
        heatApplier:ApplyDataDrivenModifier(spawnedUnit, spawnedUnit, "modifier_heat_passive", {duration=-1})
        spawnedUnit:SetModifierStackCount("modifier_heat_passive", nil, 100)
        --heatApplier:RemoveSelf()
    end
end

function ITT_GameMode:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    -- local keys.entindex_attacker --long
    -- local keys.entindex_inflictor --long
    -- local keys.damagebits --long

    print(killedUnit:GetUnitName() .. " has been killed")
    if string.find(killedUnit:GetUnitName(), "building") then
        killedUnit:RemoveBuilding(2, false)
    end
end

function ITT_GameMode:FixDropModels(dt)
    for _,v in pairs(Entities:FindAllByClassname("dota_item_drop")) do
        if not v.ModelFixInit then
            print("initing.. " .. v:GetContainedItem():GetAbilityName())
            v.ModelFixInit = true
            v.OriginalOrigin = v:GetOrigin()
            v.OriginalAngles = v:GetAngles()
            local custom = itemKeyValues[v:GetContainedItem():GetAbilityName()].Custom 
            if custom then
                print("found custom")
                if custom.ModelOffsets then
                    local offsets = itemKeyValues[v:GetContainedItem():GetAbilityName()].Custom.ModelOffsets          
                    v:SetOrigin( v.OriginalOrigin - Vector(offsets.Origin.x, offsets.Origin.y, offsets.Origin.z))
                    v:SetAngles( v.OriginalAngles.x - offsets.Angles.x, v.OriginalAngles.y - offsets.Angles.y, v.OriginalAngles.z - offsets.Angles.z)
                end
                if custom.ModelScale then v:SetModelScale(custom.ModelScale) end
            end
        end
    end
    return DROPMODEL_TICK_TIME
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
        Hunger(i)
		Energy(i)
        Heat(i)
        InventoryCheck(i)
        --print("burn")
    end
    return GAME_TROLL_TICK_TIME
end

function ITT_GameMode:OnBuildingThink()

    if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        -- Will not run until pregame ends
        return 1
    end
            
    -- Find all buildings
    buildings = FindUnitsInRadius(DOTA_TEAM_BADGUYS,
                                  Vector(0, 0, 0),
                                  nil,
                                  FIND_UNITS_EVERYWHERE,
                                  DOTA_UNIT_TARGET_TEAM_BOTH,
                                  DOTA_UNIT_TARGET_BUILDING,
                                  DOTA_UNIT_TARGET_FLAG_NONE,
                                  FIND_ANY_ORDER,
                                  false)
    --check each for their type, and run crafting with the corresponding table
    for i=1, #buildings do
        if buildings[i]:GetUnitName() == "npc_building_armory" then
            CraftItems(buildings[i], ARMORY_RECIPE_TABLE, nil)
        end
    end
    return GAME_TROLL_TICK_TIME
end

-- This is similar, but handles spawning creatures
function ITT_GameMode:OnCreatureThink()
    for i=1, 4, 1 do
        SpawnCreature("elk", i)
        SpawnCreature("hawk", i)
    end
    return GAME_CREATURE_TICK_TIME
end

-- The only real way of triggering code in Scaleform, events, are not reliable. Require acknowledgement of all events fired for this purpose.
function ITT_GameMode:FlashAckThink()
    print("ackthink!")
    for i=0,9 do
        local player = PlayerResource:GetPlayer(i)
        if player and player.eventQueue then
            for k,v in pairs(player.eventQueue) do

                if v then 
                    print(k)
                    self:HandleFlashMessage(v.eventname, v.data, i, v.id)
                end
            end
        end
    end
    return FLASH_ACK_THINK
end

-- pid and id optional
function ITT_GameMode:HandleFlashMessage(eventname, data, pid, id)
    local id = id or DoUniqueString("")
    print("Setting ID to .." .. id)
    data.id = id
    if pid then
        print("Forcing ACK for only.. " .. pid) 
        local player = PlayerResource:GetPlayer(pid)
        self:PrepFlashMessage(player, eventname, data, id)
    else 
        data.pid = -1
        for i=0,9 do
            local player = PlayerResource:GetPlayer(i)
            if player then self:PrepFlashMessage(player, eventname, data, id) end
        end
    end
    FireGameEvent(eventname, data)
end

function ITT_GameMode:PrepFlashMessage(player, eventname, data, id)
    if not player.eventQueue then player.eventQueue = {} end
    player.eventQueue[id] = {eventname = eventname, data = data, id = id}
end

function acknowledge_flash_event(cmdname, eventname, pid, id)
    print("Got an ack from .." .. pid)
    local player = PlayerResource:GetPlayer(tonumber(pid))
    if player.eventQueue then 
        print("nilling then.." .. id)
        print(player.eventQueue[id])
        player.eventQueue[id] = nil 
    end
end

--
-- This handles spawning items
--
-- Code by Till Elton
--
function ITT_GameMode:OnItemThink()
    --print("Item think tick started")
    if REL_TINDER_RATE == 0 then
        ITT_UpdateRelativePool()
    else
        ITT_AdjustItemSpawns()
    end
    --print("hit mid of spawn items")
    for i=1, #REGIONS, 1 do
        for ii=1, math.floor(ITEM_BASE * REGIONS[i][5]), 1 do
            print("Spawning an item on island" .. i)
            item = ITT_SpawnItem(REGIONS[i])
        end
    end
    --print("Item think tick ended")
    return GAME_ITEM_TICK_TIME
end


function ITT_SpawnItem(island)
    local itemSpawned = ITT_GetItemFromPool()
    --print(itemSpawned)
    local item = CreateItem(itemSpawned, nil, nil)
    --item:SetPurchaseTime(Time)
    local randomVector = GetRandomVectorGivenBounds(island[1], island[2], island[3], island[4])
    print(item:GetName().." spawned at " .. randomVector.x .. ", " .. randomVector.y)
    CreateItemOnPositionSync(randomVector, item)
    item:SetOrigin(randomVector)
end

-- Updates the relative probabilties, called only when the actual probabilties are changed
-- They from the point in which they are generated, sum to 1
function ITT_UpdateRelativePool()
    --print("Updating relative item probabilties")
    local Total = TINDER_RATE + FLINT_RATE + STICK_RATE + CLAYBALL_RATE + STONE_RATE + MANACRYSTAL_RATE + MAGIC_RATE
    REL_TINDER_RATE      = TINDER_RATE      / Total
    REL_FLINT_RATE       = FLINT_RATE       / Total
    REL_STICK_RATE       = STICK_RATE       / Total
    REL_CLAYBALL_RATE    = CLAYBALL_RATE    / Total
    REL_STONE_RATE       = STONE_RATE       / Total
    REL_MANACRYSTAL_RATE = MANACRYSTAL_RATE / Total
    REL_MAGIC_RATE       = MAGIC_RATE       / Total
end

-- Go though each item, order should not be relevant
function ITT_GetItemFromPool()
    local cumulProb = 0.0
    local rand      = RandomFloat(0,1)

    cumulProb = cumulProb + REL_TINDER_RATE
    if rand <= cumulProb then
        return "item_tinder"
    end

    cumulProb = cumulProb + REL_FLINT_RATE
    if rand <= cumulProb then
        return "item_flint"
    end

    cumulProb = cumulProb + REL_STICK_RATE
    if rand <= cumulProb then
        return "item_stick"
    end

    cumulProb = cumulProb + REL_CLAYBALL_RATE
    if rand <= cumulProb then
        return "item_ball_clay"
    end

    cumulProb = cumulProb + REL_STONE_RATE
    if rand <= cumulProb then
        return "item_stone"
    end

    cumulProb = cumulProb + REL_MANACRYSTAL_RATE
    if rand <= cumulProb then
        return "item_crystal_mana"
    end

    cumulProb = cumulProb + REL_MAGIC_RATE
    if rand <= cumulProb then
        return "item_magic_raw"
    end
    
    print("Should never happen, error in item spawning, commulative probability higher than items")
    print("cummulprob = " .. cumulProb)
    print("rand is " .. rand)
end

-- Item spawn distribution changes, later in the game it tends to a different ratio
-- From https://github.com/island-troll-tribes/wc3-client/blob/1562854dd098180752f0f4a99df0c4968697b38b/src/lib/PublicLibrary.j#L271-L292

function ITT_AdjustItemSpawns()
    --print("adjusting item spawns")
    FLINT_RATE = math.max(2.0,(FLINT_RATE-0.4))
    MANACRYSTAL_RATE = math.min(1.6,(MANACRYSTAL_RATE+0.5))
    STONE_RATE = math.min(3.3,(STONE_RATE+0.5))
    STICK_RATE = math.min(4.5,(STICK_RATE+0.5))
    TINDER_RATE = math.max(.7,(TINDER_RATE-0.6))
    CLAYBALL_RATE = math.min(1.85,(CLAYBALL_RATE+0.3))
    -- I don't get how item base works, it always seems too low in the wc3 file disabled for the moment since it breaks everything, any help?
    -- ITEM_BASE = math.max(1.15,(ITEM_BASE-0.2))
    ITT_UpdateRelativePool()
end

-- Gets a random vector in a specific area
function GetRandomVectorGivenBounds(minx, miny, maxx, maxy)
    return Vector(RandomFloat(minx, miny),RandomFloat(maxx, maxy),0)
end

-- Gets a random vector on the map
function GetRandomVectorInBounds()
    return Vector(RandomFloat(GetWorldMinX(), GetWorldMaxX()),RandomFloat(GetWorldMinY(), GetWorldMaxY()),0)
end

--
-- END OF ITEM SPAWNING
--

-- This will handle anything gamestate related that is not covered under other thinkers
function ITT_GameMode:OnStateThink()
    --print(GameRules:State_Get())
    return GAME_TICK_TIME
    --GameRules:MakeTeamLose(3)
    -- GameRules:SetGameWinner(1)
    --local player = PlayerInstanceFromIndex(1)
    --print(player:GetAssignedHero())
    --player:SetTeam(2)
    --print(player:GetTeam())
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

--Listener to handle telegather events from item pickup
function ITT_GameMode:OnItemPickedUp(event)
        local hero = EntIndexToHScript( event.HeroEntityIndex )
        local hasTelegather = hero:HasModifier("modifier_telegather")
        
        if hasTelegather then
            RadarTelegather(event)
        end
end

--Listener to handle level up
function ITT_GameMode:OnPlayerGainedLevel(event)
	print("PlayerGainedLevel")
end

function give_item(cmdname, itemname)
    local hero = Convars:GetCommandClient():GetAssignedHero()
    hero:AddItem(CreateItem(itemname, hero, hero))
end

function print_dropped_vecs(cmdname)
    local items = Entities:FindAllByClassname("dota_item_drop")
    for _,v in pairs(items) do
        print(v:GetClassname())
        local now = v:GetOrigin()
        v:SetOrigin(Vector(now.x, now.y, now.z - 146))
        v:SetModelScale(1.8)
    end
end

function print_fix_diffs(cmdname)
    local items = Entities:FindAllByClassname("dota_item_drop")
    for _,v in pairs(items) do
        local angs = v:GetAngles()
        local difforig = v.OriginalOrigin - v:GetOrigin()
        local diffangs = {x = v.OriginalAngles.x - angs.x, y = v.OriginalAngles.y - angs.y, z = v.OriginalAngles.z - angs.z} --i dunno either, exception w/o :__sub just for this
        print(v:GetContainedItem():GetAbilityName() .. " Offsets: ")
        print("\"Custom\"")
        print("{")
        print("    \"ModelOffsets\"")
        print("    {")
        print("        \"Origin\"")
        print("        {")
        print("            \"x\" \"" .. difforig.x .. "\"")
        print("            \"y\" \"" .. difforig.x .. "\"")
        print("            \"z\" \"" .. difforig.z .. "\"")
        print("        }")
        print("        \"Angles\"")
        print("        {")
        print("            \"x\" \"" .. diffangs.x .. "\"")
        print("            \"y\" \"" .. diffangs.x .. "\"")
        print("            \"z\" \"" .. diffangs.z .. "\"")
        print("        }")
        print("    }")
        print("}")
    end
end

function reload_ikv(cmdname)
    itemKeyValues = LoadKeyValues("scripts/npc/npc_items_custom.txt")
end

function test_ack(cmdname)
    ITT_GameMode:HandleFlashMessage("fl_level_6", {pid = -1, gameclass = "gatherer"})
end

function test_ack_sec(cmdname)
    ITT_GameMode:HandleFlashMessage("fl_level_6", {pid = Convars:GetCommandClient():GetPlayerID()})
end

function make(cmdname, unitname)
    local player = Convars:GetCommandClient()
    local hero = player:GetAssignedHero()
    CreateUnitByName(unitname, hero:GetOrigin(), true, hero, hero, 2)
end

function sub_select(cmdname, choice)
    local player = Convars:GetCommandClient()
    local hero = player:GetAssignedHero() --danger
    print(player:GetPlayerID() .. " chose " .. choice)
end

Convars:RegisterCommand("sub_select", function(cmdname, choice) sub_select(cmdname, choice) end, "Give any item", 0)
Convars:RegisterCommand("make", function(cmdname, unitname) make(cmdname, unitname) end, "Give any item", 0)
Convars:RegisterCommand("test_ack_sec", function(cmdname) test_ack_sec(cmdname) end, "Give any item", 0)
Convars:RegisterCommand("test_ack", function(cmdname) test_ack(cmdname) end, "Give any item", 0)
Convars:RegisterCommand("acknowledge_flash_event", function(cmdname, eventname, pid, id) acknowledge_flash_event(cmdname, eventname, pid, id) end, "Give any item", 0)
Convars:RegisterCommand("reload_ikv", function(cmdname) reload_ikv(cmdname) end, "Give any item", 0)
Convars:RegisterCommand("print_fix_diffs", function(cmdname) print_fix_diffs(cmdname) end, "Give any item", 0)
Convars:RegisterCommand("print_dropped_vecs", function(cmdname) print_dropped_vecs(cmdname) end, "Give any item", 0)
Convars:RegisterCommand("give_item", function(cmdname, itemname) give_item(cmdname, itemname) end, "Give any item", 0)

--multiteam stuff

---------------------------------------------------------------------------
-- Game state change handler
---------------------------------------------------------------------------
function ITT_GameMode:OnGameRulesStateChange()
    local nNewState = GameRules:State_Get()
--  print( "OnGameRulesStateChange: " .. nNewState )

    if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        print("DOTA_GAMERULES_STATE_HERO_SELECTION")
        --self:AssignAllPlayersToTeams()
        GameRules:GetGameModeEntity():SetThink( "BroadcastPlayerTeamAssignments", self, 0 ) -- can't do this immediately because the player resource doesn't have the names yet
    end
end

---------------------------------------------------------------------------
-- Helper functions
---------------------------------------------------------------------------
function ShuffledList( list )
    local result = {}
    local count = #list
    for i = 1, count do
        local pick = RandomInt( 1, #list )
        result[ #result + 1 ] = list[ pick ]
        table.remove( list, pick )
    end
    return result
end

function TableCount( t )
    local n = 0
    for _ in pairs( t ) do
        n = n + 1
    end
    return n
end

---------------------------------------------------------------------------
-- Scan the map to see which teams have spawn points
---------------------------------------------------------------------------
function ITT_GameMode:GatherValidTeams()
  print( "GatherValidTeams:" )

    local foundTeams = {}
    for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
        foundTeams[  playerStart:GetTeam() ] = true
    end

  print( "GatherValidTeams - Found spawns for a total of " .. TableCount(foundTeams) .. " teams" )
    
    local foundTeamsList = {}
    for t, _ in pairs( foundTeams ) do
        table.insert( foundTeamsList, t )
    end

    self.m_GatheredShuffledTeams = foundTeamsList
    print("gather shuffled teams", self.m_GatheredShuffledTeams, #self.m_GatheredShuffledTeams, #foundTeamsList)
    print( "Final shuffled team list:" )
    for _, team in pairs( self.m_GatheredShuffledTeams ) do
     print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
    end
end


---------------------------------------------------------------------------
-- Assign all real players to a team
---------------------------------------------------------------------------
function ITT_GameMode:AssignAllPlayersToTeams()
  print( "Assigning players to teams..." )
    for playerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
        if nil ~= PlayerResource:GetPlayer( playerID ) then
            local teamID = self:GetNextTeamAssignment()
            print( " - Player " .. playerID .. " assigned to team " .. teamID )
            PlayerResource:SetCustomTeamAssignment( playerID, teamID )
        end
    end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function ITT_GameMode:ColorForTeam( teamID )
    local color = self.m_TeamColors[teamID]
    if color == nil then
        color = { 255, 255, 255 } -- default to white
    end
    return color
end

---------------------------------------------------------------------------
-- Determine a good team assignment for the next player
---------------------------------------------------------------------------
function ITT_GameMode:GetNextTeamAssignment()
    if #self.m_GatheredShuffledTeams == 0 then
      print( "CANNOT ASSIGN PLAYER - NO KNOWN TEAMS" )
        return DOTA_TEAM_NOTEAM
    end

    -- haven't assigned this player to a team yet
    print( "m_NumAssignedPlayers = " .. self.m_NumAssignedPlayers )
    
    -- If the number of players per team doesn't divide evenly (ie. 10 players on 4 teams => 2.5 players per team)
    -- Then this floor will round that down to 2 players per team
    -- If you want to limit the number of players per team, you could just set this to eg. 1
    local playersPerTeam = 3 --math.floor( DOTA_MAX_TEAM_PLAYERS / #self.m_GatheredShuffledTeams )
    print( "playersPerTeam = " .. playersPerTeam )

    local teamIndexForPlayer = math.floor( self.m_NumAssignedPlayers / playersPerTeam )
    print( "teamIndexForPlayer = " .. teamIndexForPlayer )

    -- Then once we get to the 9th player from the case above, we need to wrap around and start assigning to the first team
    if teamIndexForPlayer >= #self.m_GatheredShuffledTeams then
        teamIndexForPlayer = teamIndexForPlayer - #self.m_GatheredShuffledTeams
        print( "teamIndexForPlayer => " .. teamIndexForPlayer )
    end
    
    teamAssignment = self.m_GatheredShuffledTeams[ 1 + teamIndexForPlayer ]
    print( "teamAssignment = " .. teamAssignment )

    self.m_NumAssignedPlayers = self.m_NumAssignedPlayers + 1

    return teamAssignment
end


---------------------------------------------------------------------------
-- Put a label over a player's hero so people know who is on what team
---------------------------------------------------------------------------
function ITT_GameMode:MakeLabelForPlayer( nPlayerID )
    if not PlayerResource:HasSelectedHero( nPlayerID ) then
        return
    end

    local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
    if hero == nil then
        return
    end

    local teamID = PlayerResource:GetTeam( nPlayerID )
    local color = self:ColorForTeam( teamID )
    hero:SetCustomHealthLabel( GetTeamName( teamID ), color[1], color[2], color[3] )
end

---------------------------------------------------------------------------
-- Tell everyone the team assignments during hero selection
---------------------------------------------------------------------------
function ITT_GameMode:BroadcastPlayerTeamAssignments()
    print("BroadcastPlayerTeamAssignments")
    for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
        local nTeamID = PlayerResource:GetTeam( nPlayerID )
        if nTeamID ~= DOTA_TEAM_NOTEAM then
            GameRules:SendCustomMessage( "#TeamAssignmentMessage", nPlayerID, -1 )
        end
    end
end

---------------------------------------------------------------------------
-- Update player labels and the scoreboard
---------------------------------------------------------------------------
function ITT_GameMode:OnThink()
    for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
        self:MakeLabelForPlayer( nPlayerID )
    end
        
    return 1
end