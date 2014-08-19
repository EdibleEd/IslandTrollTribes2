-- Handles constant health degen, IE hunger
-- Author: Kieran Carnegie, Till Elton
--
-- Code from: Amanite, and http://www.reddit.com/r/Dota2Modding/comments/2dc0xm/guide_to_change_gold_over_time_to_reliable_gold/

HEAT_LOSS_PER_UNIT = 3
TICKS_PER_HEAT_UNIT = 6

allowed_item_combos_two     = {}
allowed_item_combos_three   = {}
heatTicks = 0

if ITT_TrollController == nil then
    print("Troll class created")
    ITT_TrollController = class({})
    
    allowed_item_combos_two["item_ward_observer"]  = {"item_clarity", "item_tango"}
end

-- This reduces each players health by 3, every 3 seconds
-- The return values ensure it closes when the game ends
-- Possibly need to detect only living heroes, will test that with more players
function ITT_TrollController:HeatLoss(playerID)
    heatTicks = heatTicks + 1
    if heatTicks % 6 == 0 then
        local player = PlayerInstanceFromIndex(playerID)
        local hero = player:GetAssignedHero()
        hero:ModifyHealth(hero:GetHealth()-3, hero,true,-3)
    end
end

function ITT_TrollController:InventoryCheck(playerID)
    print("Inv testing player " .. playerID)
    -- Lets find the hero we want to work with
    player = PlayerInstanceFromIndex(playerID)
    hero =   player:GetAssignedHero()
    if hero == nil then
        print("hero " .. playerID .. " doesn't exist!")
    end
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