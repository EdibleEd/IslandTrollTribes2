-- Handles constant health degen, IE hunger
-- Author: Kieran Carnegie, Till Elton
--
-- Code from: Amanite, and http://www.reddit.com/r/Dota2Modding/comments/2dc0xm/guide_to_change_gold_over_time_to_reliable_gold/

require("craftinghelper")

HUNGER_LOSS_PER_UNIT = 1
TICKS_PER_HUNGER_UNIT = 6

ENERGY_LOSS_PER_UNIT = 1
TICKS_PER_ENERGY_UNIT = 6

HEAT_LOSS_PER_UNIT = 1
TICKS_PER_HEAT_UNIT = 6

allowed_item_combos_two     = {}
allowed_item_combos_three   = {}
hungerTicks = 0
energyTicks = 0
heatTicks = 0

allowed_item_combos_two["item_ward_observer"]  = {"item_clarity", "item_tango"}

-- This reduces each players health by 3, every 3 seconds
-- The return values ensure it closes when the game ends
-- Possibly need to detect only living heroes, will test that with more players
function Hunger(playerID)
    hungerTicks = hungerTicks + 1
    if hungerTicks % TICKS_PER_HUNGER_UNIT == 0 then
        local player = PlayerInstanceFromIndex(playerID)
        local hero = player:GetAssignedHero()
        if hero ~= nil then
            hero:ModifyHealth(hero:GetHealth()-HUNGER_LOSS_PER_UNIT, hero,true,-1*HUNGER_LOSS_PER_UNIT)
        end
    end
end

function Energy(playerID)
    energyTicks = energyTicks + 1
    if energyTicks % TICKS_PER_ENERGY_UNIT == 0 then
        local player = PlayerInstanceFromIndex(playerID)
        local hero = player:GetAssignedHero()
        if hero ~= nil then
            hero:ReduceMana(ENERGY_LOSS_PER_UNIT)
        end
        if hero:GetMana() <= 0 then
            hero:ForceKill(true)
        end
    end
end

function Heat(playerID)
    heatTicks = heatTicks + 1
    if heatTicks % TICKS_PER_HEAT_UNIT == 0 then
        local player = PlayerInstanceFromIndex(playerID)
        local hero = player:GetAssignedHero()
        if hero ~= nil then
            local heatStackCount = hero:GetModifierStackCount("modifier_heat_passive", nil) - HEAT_LOSS_PER_UNIT
            hero:SetModifierStackCount("modifier_heat_passive", nil, heatStackCount)
            if heatStackCount <= 0 then
                hero:ForceKill(true)
            end
        end
    end
end

TROLL_RECIPE_TABLE = {
        {"item_building_kit_fire_basic",        {"item_tinder", "item_flint", "item_stick"}},
        {"item_building_kit_tent",              {"item_stick", "item_hide_any", "item_stick"}},
        {"item_building_kit_troll_hut",         {"item_ball_clay", "item_stick", "item_stick", "item_hide_any", "item_hide_any"}},
        {"item_building_kit_hut_mud",           {"item_ball_clay", "item_ball_clay", "item_ball_clay", "item_ball_clay"}},
        {"item_building_kit_storage_chest",     {"item_hide_any", "item_stick", "item_tinder", "item_ball_clay"}},
        {"item_building_kit_smoke_house",       {"item_stick", "item_hide_any", "item_ball_clay"}},
        {"item_building_kit_armory",            {"item_flint", "item_stone", "item_stone", "item_stone"}},
        {"item_building_kit_tannery",           {"item_stick", "item_stick", "item_stone", "item_stone"}},
        {"item_building_kit_workshop",          {"item_stick", "item_ingot_iron", "item_ingot_iron"}},
        {"item_building_kit_hut_witch_doctor",  {"item_stick", "item_crystal_mana", "item_stick", "item_crystal_mana","item_stick", "item_crystal_mana"}},
        {"item_building_kit_mixing_pot",        {"item_stickick", "item_ball_clay", "item_ball_clay", "item_ball_clay"}},
        {"item_building_kit_tower_omni",        {"item_stone", "item_stick", "item_stick", "item_stick"}},
        {"item_building_kit_teleport_beacon",   {"item_stone", "item_stone", "item_crystal_mana", "item_crystal_mana"}},
        {"item_building_kit_hatchery",          {"item_stone", "item_stone", "item_stone", "item_stick", "item_stick", "item_stick"}}
    }
HIDE_ALIAS_TABLE = {
        {"item_hide_any", {"item_hide_wolf", "item_hide_elk", "item_hide_jungle_bear"}}
    }

function InventoryCheck(playerID)
    -- print("Inv testing player " .. playerID)
    -- Lets find the hero we want to work with
    local player = PlayerInstanceFromIndex(playerID)
    local hero =   player:GetAssignedHero()
    if hero == nil then
        print("hero " .. playerID .. " doesn't exist!")
    else
        CraftItems(hero, TROLL_RECIPE_TABLE, HIDE_ALIAS_TABLE)
    end
end