-- Handles constant health degen, IE hunger
-- Author: Kieran Carnegie, Till Elton
--
-- Code from: Amanite, and http://www.reddit.com/r/Dota2Modding/comments/2dc0xm/guide_to_change_gold_over_time_to_reliable_gold/

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

function InventoryCheck(playerID)
    -- print("Inv testing player " .. playerID)
    -- Lets find the hero we want to work with
    player = PlayerInstanceFromIndex(playerID)
    hero =   player:GetAssignedHero()
    if hero == nil then
        print("hero " .. playerID .. " doesn't exist!")
    else
        -- lua uses an interesting sytax for for loops. for [start], [finish], [increment]
        -- we want to run over the 6 inventory slots,, starting at index 0
        for j=0,5,1 do
            if hero:GetItemInSlot(j) ~= nil then
                local item1 = hero:GetItemInSlot(j):GetName()              
                
                if j < 4 then
                    if not (hero:GetItemInSlot(j+1) == nil or hero:GetItemInSlot(j+2) == nil) then
                        local item2 = hero:GetItemInSlot(j+1):GetName()
                        local item3 = hero:GetItemInSlot(j+2):GetName() 
                        for result, components in pairs(allowed_item_combos_three) do
                            if components[1] == item1 and components[2] == item2 and components[3] == item3 then
                                hero:GetItemInSlot(j):Kill()
                                hero:GetItemInSlot(j+1):Kill()
                                hero:GetItemInSlot(j+2):Kill()
                                hero:AddItem(CreateItem(result, hero, hero))
                            end
                        end
                    end
                end

                if j < 5 then
                    if hero:GetItemInSlot(j+1) ~= nil then
                        local item2 = hero:GetItemInSlot(j+1):GetName()
                        for result, components in pairs(allowed_item_combos_two) do
                            if components[1] == item1 and components[2] == item2 then
                                hero:GetItemInSlot(j):Kill()
                                hero:GetItemInSlot(j+1):Kill()
                                hero:AddItem(CreateItem(result, hero, hero))
                            end
                        end
                    end
                end
            end
        end
    end
end