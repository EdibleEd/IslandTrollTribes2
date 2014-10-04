--Gatherer Ability Functions

--[[Pings the items in parameter ItemTable with their corresponding color]]
function PingItemInRange(keys)
    --PrintTable(keys)
    local caster = keys.caster
    local range = keys.Range    
    local itemTable = keys.ItemTable
    
    for itemName,itemColor in pairs(itemTable) do
        if itemColor == nil then
            itemColor = "255 255 255"
        end
        
        local stringParse = string.gmatch(itemColor, "%d+")
    
        --need to divide by 255 to convert to 0-1 scale
        local redVal = tonumber(stringParse())/255
        local greenVal = tonumber(stringParse())/255
        local blueVal = tonumber(stringParse())/255        
        
        print("caster info", caster:GetTeam(), caster:GetOrigin(),range)
        --FindInSphere(handle startFrom, Vector origin, float maxRadius)
        local ent = Entities:FindInSphere(nil, caster:GetOrigin(), range)

        while ent ~= nil do
            if ent:GetName() == itemName then
                print("pinging", ent, "at", ent:GetAbsOrigin().x, ent:GetAbsOrigin().y, ent:GetAbsOrigin().z)
                --maybe use CreateParticleForPlayer(string particleName, int particleAttach, handle owningEntity, handle owningPlayer)
                local thisParticle = ParticleManager:CreateParticle("particles/ui_mouseactions/ping_world.vpcf", PATTACH_ABSORIGIN, ent)
                ParticleManager:SetParticleControl(thisParticle, 0, ent:GetAbsOrigin())
                ParticleManager:SetParticleControl(thisParticle, 1, Vector(redVal, greenVal, blueVal))
                print(itemName, redVal, greenVal, blueVal)
                ParticleManager:ReleaseParticleIndex(thisParticle)
                ent:EmitSound("General.Ping")   --may be deafening
            end
            ent = Entities:FindInSphere(ent, caster:GetOrigin(), range)
        end    
    end
end

--[[Checks unit inventory for matching recipes. If there's a match, remove all items and add the corresponding potion
    Matches must have the exact number of each ingredient
    Used for both the Mixing Pot and the Herb Telegatherer]]
function MixHerbs(keys)
    print("MixHerbs")
    local caster = keys.caster
    --Table to identify ingredients
    local herbTable = {"item_river_stem", "item_river_root", "item_herb_butsu", "item_herb_orange", "item_herb_purple", "item_herb_yellow", "item_herb_blue"}
    local specialTable = {"item_herb_orange", "item_herb_purple", "item_herb_yellow", "item_herb_blue"}
    --Table used to look up herb recipes, can move this if other functions need it
    local recipeTable = {
        {"item_spirit_wind", {item_river_stem = 2}},
        {"item_spirit_water", {item_river_root = 2}},
        {"item_potion_anabolic", {item_river_stem = 6}},
        {"item_potion_cure_all", {item_herb_butsu = 6}},
        {"item_potion_drunk", {item_river_stem = 2, item_herb_butsu = 2}},
        {"item_potion_healingi", {item_river_root = 1, item_herb_butsu = 1}},
        {"item_potion_healingiii", {item_river_root = 2, item_herb_butsu = 2}},
        {"item_potion_healingiv", {item_river_root = 3, item_herb_butsu = 3}},
        {"item_potion_manai", {item_river_stem = 1, item_herb_butsu = 1}},
        {"item_potion_manaiii", {item_river_stem = 2, item_herb_butsu = 2}},
        {"item_potion_manaiv", {item_river_stem = 3, item_herb_butsu = 3}},
        {"item_rock_dark", {item_river_root = 2, item_river_stem = 2, item_herb_butsu = 2}},
        {"item_potion_twin_island", {item_herb_orange = 3, item_herb_purple = 3}},
        {"item_potion_twin_island", {item_herb_yellow = 3, item_herb_blue = 3}},
        {"item_essence_bees", {item_herb_orange = 1, item_herb_purple = 1, item_herb_yellow = 1, item_herb_blue = 1}},
        {"item_gem_of_knowledge", {item_herb_blue = 1, item_herb_orange = 3, item_herb_yellow}},
        {"item_gem_of_knowledge", {item_herb_blue = 1, item_herb_orange = 3, item_herb_purple}},
        {"item_potion_anti_magic", {special_1 = 6}},
        {"item_potion_fervor", {special_1 = 3, item_herb_butsu = 1}},
        {"item_potion_elemental", {special_1 = 1, item_river_stem = 3, item_river_root = 1}},
        {"item_potion_disease", {special_1 = 2,special_2 = 2, item_river_root = 1}},
        {"item_potion_nether", {special_1 = 1, item_river_stem = 2, item_herb_butsu = 2}},
        {"item_essence_bees", {special_1 = 2, special_2 = 1, special__3 = 1}},
        {"item_potion_acid", {special_1 = 2, special_2 = 2, item_river_stem = 2}}
    }
    
    --recipes that use special herbs. A bit more complicated
    --[[

    --]]
    
    local myMaterials = {}
    local itemTable = {}
    
    --loop through inventory slots
    for i = 0,5 do
        local item = caster:GetItemInSlot(i)    --get the item in the slot
        if item ~= nil then --if the slot is not empty
            local itemName = item:GetName() --get the item's name
            print(i, itemName)  --debug
            --loop through list of possible ingredients to see if the inventory item is one
            for i,herbName in pairs(herbTable) do
                if itemName == herbName then  --if the item is an herb ingredient
                    print("Adding to table", itemName)
                    if myMaterials[itemName] == nil then  --add it to our internal list
                        myMaterials[itemName] = 0
                    end
                    myMaterials[itemName] = myMaterials[itemName] + 1   --increment the count
                    table.insert(itemTable, item)
                end                
            end
        else
            print(i, "empty")  --more debug, print empty slot
        end
    end
    
    print("Check for match")
    --check if player materials matches any recipes
    for i,value in pairs(recipeTable) do  --loop through the recipe table
        local recipeName = recipeTable[i][1]    --get the name of the recipe
        local recipeIngredients = recipeTable[i][2] --get the items needed for the recipe
        if CompareTables(recipeIngredients, myMaterials) then    --if a recipe matches
            print("Match!", i)
            local newItem = CreateItem(recipeName, nil, nil)   --create the resulting item
            for i,removeMe in pairs(itemTable) do   --delete the materials
                caster:RemoveItem(removeMe)
            end
            caster:AddItem(newItem) --add the new item
            return  --end the function, only one item per mix
        end
    end   
    
    
    print("Check for special match")
    local specialTable = {
        {"item_herb_orange", 0},
        {"item_herb_purple", 0},
        {"item_herb_yellow", 0},
        {"item_herb_blue", 0}
    }
    
        specialTable[1][2] = myMaterials["item_herb_orange"]
        specialTable[2][2] = myMaterials["item_herb_purple"]
        specialTable[3][2] = myMaterials["item_herb_yellow"]
        specialTable[4][2] = myMaterials["item_herb_blue"]
    
    for key,val in pairs (specialTable) do
        print(val[1], val[2])
        if val[2] == nil then
            specialTable[key][2] = 0
        end
    end
    
    print("sort it!")            
    table.sort(specialTable, compareHelper)
    
    for key,val in pairs (specialTable) do
        print(val[1], val[2])
    end
    
    --replace herb names with special_X
    myMaterials["special_1"] = specialTable[1][2]
    myMaterials[specialTable[1][1]] = nil
    myMaterials["special_2"] = specialTable[2][2]
    myMaterials[specialTable[2][1]] = nil
    myMaterials["special_3"] = specialTable[3][2]
    myMaterials[specialTable[3][1]] = nil
    myMaterials["special_4"] = specialTable[4][2]
    myMaterials[specialTable[4][1]] = nil
    
    for key,val in pairs (myMaterials) do
        if val == 0 then
            myMaterials[key] = nil
        end
    end
    
    print("Check for match")
    --check if player materials matches any recipes
    for i,value in pairs(recipeTable) do  --loop through the recipe table
        local recipeName = recipeTable[i][1]    --get the name of the recipe
        local recipeIngredients = recipeTable[i][2] --get the items needed for the recipe
        if CompareTables(recipeIngredients, myMaterials) then    --if a recipe matches
            print("Match!", i)
            local newItem = CreateItem(recipeName, nil, nil)   --create the resulting item
            for i,removeMe in pairs(itemTable) do   --delete the materials
                caster:RemoveItem(removeMe)
            end
            caster:AddItem(newItem) --add the new item
            return  --end the function, only one item per mix
        end
    end   
    
end

--Compares two tables to see if they have the same values
function CompareTables(table1, table2)
    print("Comparing tables")
    if type(table1) ~= "table" or type(table2) ~= "table" then
        return false
    end
    
    for key,value in pairs(table1) do
        print(key, table1[key], table2[key])
        if table2[key] == nil then
            return false
        elseif table2[key] ~= table1[key] then
            return false
        end
    end
    
    print("check other table, just in case")    

    for key,value in pairs(table2) do
        print(key, table2[key], table1[key])
        if table1[key] == nil then
            return false
        elseif table1[key] ~= table2[key] then
            return false
        end
    end
    
    print("Match!")
    return true
end

function compareHelper(a,b)
    return a[2] > b[2]
end

function SwapAbilities(unit, ability1, ability2, enable1, enable2)
    
    --swaps ability1 and ability2, disables 1 and enables 2
    print("swap", ability1:GetName(), ability2:GetName() )
    unit:SwapAbilities(ability1:GetName(), ability2:GetName(), enable1, enable2)
    ability1:SetHidden(enable2)
    ability2:SetHidden(enable1)
end

function RadarManipulations(keys)
    local caster = keys.caster
    local isOpening = (keys.isOpening == "true")
    local ABILITY_radarManipulations = caster:FindAbilityByName("ability_gatherer_radarmanipulations")
    
    local abilityLevel = ABILITY_radarManipulations:GetLevel()
    print("abilityLevel", abilityLevel)
    local unitName = caster:GetUnitName()
    print(unitName)
    
    local tableDefaultSkillBook ={
        "ability_gatherer_itemradar",
        "ability_gatherer_radarmanipulations", 
        "ability_empty3", 
        "ability_empty4",  
        "ability_empty5", 
        "ability_empty6", 
        "ability_empty7"}
        
    local tableRadarBook ={
        "ability_gatherer_findmushroomstickortinder",
        "ability_gatherer_findhide",
        "ability_gatherer_findclayballcookedmeatorbone",
        "ability_gatherer_findmanacrystalorstone",
        "ability_gatherer_findflint",
        "ability_gatherer_findmagic"
    }

    local numAbilities = abilityLevel

    for i=1,numAbilities do
        print(tableDefaultSkillBook[i], tableRadarBook[i])
        local ability1 = caster:FindAbilityByName(tableDefaultSkillBook[i])
        local ability2 = caster:FindAbilityByName(tableRadarBook[i])
        if ability2:GetLevel() == 0 then
            ability2:SetLevel(1)
        end
        print("isopening",isOpening)
        if isOpening == true then
            print("ability1:", ability1:GetName(), "ability2:", ability2:GetName())
            SwapAbilities(caster, ability1, ability2, false, true)
            caster:FindAbilityByName("ability_gatherer_radarmanipulations"):SetHidden(true)
        else
            SwapAbilities(caster, ability1, ability2, true, false)
            caster:FindAbilityByName("ability_gatherer_radarmanipulations"):SetHidden(false)
            caster:FindAbilityByName("ability_empty3"):SetHidden(true)
            caster:FindAbilityByName("ability_empty4"):SetHidden(true)
            caster:FindAbilityByName("ability_empty5"):SetHidden(true)
            caster:FindAbilityByName("ability_empty6"):SetHidden(true)
        end
    end

end

function RadarTelegatherInit(keys)
    local caster = keys.caster
    local target = keys.target
    
    keys.caster.targetFire = target
    
end

function RadarTelegather (keys)
        local hero = EntIndexToHScript( keys.HeroEntityIndex )
        local hasTelegather = hero:HasModifier("modifier_telegather")
        local targetFire = hero.targetFire
        
        local originalItem = EntIndexToHScript(keys.ItemEntityIndex)
        local newItem = CreateItem(originalItem:GetName(), nil, nil)
        
        local itemList = {"item_tinder", "item_flint", "item_stone", "item_stick", "item_bone", "item_meat_raw", "item_crystal_mana", "item_clay_ball", "item_river_root", "item_river_stem", "item_thistles", "item_acorn", "item_acorn_magic", "item_mushroom"}
        for key,value in pairs(itemList) do
            if value == originalItem:GetName() then
                print( "Teleporting Item", originalItem:GetName())
                hero:RemoveItem(originalItem)
                local itemPosition = targetFire:GetAbsOrigin() + RandomVector(RandomInt(100,150))
                CreateItemOnPositionSync(itemPosition,newItem)   
                newItem:SetOrigin(itemPosition)
            end
        end
end

--Hunter Ability Functions

function EnsnareUnit(keys)
    local caster = keys.caster
    local target = keys.target
    local targetName = target:GetName()
    local dur = 8.0	--default duration for anything besides heros
    if (string.find(targetName,"hero") ~= nil) then --if the target's name includes "hero"
        dur = 3.5	--then we use the hero only duration
    end
    print("Ensnare!")
    target:AddNewModifier(caster, nil, "modifier_meepo_earthbind", { duration = dur})
    --target:AddNewModifier(caster, nil, "modifier_ensnare", { duration = dur})   --I could call a modifier applier, but Valve should fix this soon   
end

function TrackUnit(keys)
    local caster = keys.caster
    local target = keys.target
    local targetName = target:GetName()
    local dur = tonumber(keys.Duration)
    if (string.find(targetName,"hero") == nil) then --if the target's name does not include "hero", ie an animal
        dur = 30.0
    end
    
    --target:AddNewModifier(caster, nil, "modifier_bounty_hunter_track", { duration = dur, radius = 200})
    --callModApplier(target, modifier_hunter_track_hero, 1)
end

function TrackMoveSpotter(keys)
    local target
end

--utility functions
function callModApplier( caster, modName, abilityLevel)
    if abilityLevel == nil then
        abilityLevel = 1
    end
    local applier = modName .. "_applier"
    local ab = caster:FindAbilityByName(applier)
    if ab == nil then
        caster:AddAbility(applier)
        ab = caster:FindAbilityByName( applier )
        ab:SetLevel(abilityLevel)
        print("trying to cast ability ", applier, "level", ab:GetLevel())
    end
    caster:CastAbilityNoTarget(ab, -1)
    caster:RemoveAbility(applier)
end

--General Functions

function RestoreMana(keys)
	local target = keys.target
	target:GiveMana(keys.ManaRestored) 
end