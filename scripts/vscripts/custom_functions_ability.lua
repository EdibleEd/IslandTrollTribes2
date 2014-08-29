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
    Matches must have the exact number of each ingredient]]
function MixHerbs(keys)
    print("MixHerbs")
    local caster = keys.caster
    --Table to identify ingredients
    local herbTable = {"item_river_stem", "item_river_root", "item_herb_butsu", "item_herb_orange", "item_herb_purple", "item_herb_yellow", "item_herb_blue"}
    --Table used to look up herb recipes, can move this if other functions need it
    local recipeTable = {}
    recipeTable["item_spirit_wind"] = {item_river_stem = 2}
    recipeTable["item_spirit_water"] = {item_river_root = 2}
    recipeTable["item_potion_anabolic"] = {item_river_stem = 6}
    recipeTable["item_potion_cure_all"] = {item_herb_butsu = 6}
    recipeTable["item_potion_drunk"] = {item_river_stem = 2, item_herb_butsu = 2}
    recipeTable["item_potion_healingi"] = {item_river_root = 1, item_herb_butsu = 1}
    recipeTable["item_potion_healingiii"] = {item_river_root = 2, item_herb_butsu = 2}
    recipeTable["item_potion_healingiv"] = {item_river_root = 3, item_herb_butsu = 3}
    recipeTable["item_potion_manai"] = {item_river_stem = 1, item_herb_butsu = 1}
    recipeTable["item_potion_manaiii"] = {item_river_stem = 2, item_herb_butsu = 2}
    recipeTable["item_potion_manaiv"] = {item_river_stem = 3, item_herb_butsu = 3}
    recipeTable["item_rock_dark"] = {item_river_root = 2, item_river_stem = 2, item_herb_butsu = 2}
    
    --recipes that use special herbs. A bit more complicated
    --[[
    recipeTable["item_potion_anti_magic"] = {special_1 = 6}
    recipeTable["item_potion_fervor"] = {special_1 = 3, item_herb_butsu = 1}
    recipeTable["item_potion_elemental"] = {special_1 = 1, item_river_stem = 3, item_river_root = 1}  
    recipeTable["item_potion_disease"] = {special_1 = 2,special_2 = 2, item_river_root = 1}
    recipeTable["item_potion_nether"] = {special_1 = 1, item_river_stem = 2, item_herb_butsu = 2}
    recipeTable["item_gem_of_knowledge"] = {item_herb_blue = 1, item_herb_orange = 3, yellow or purple}
    recipeTable["item_essence_bees"] = {item_herb_orange = 1, item_herb_purple = 1, item_herb_yellow = 1, item_herb_blue = 1} --or special_1 = 2, special_2, special_3
    recipeTable["item_potion_twin_island"] = {item_herb_orange = 3, item_herb_purple = 3 or item_herb_yellow = 3, item_herb_blue = 3}
    recipeTable["item_potion_acid"] = {special_1 = 2, special_2 = 2, item_river_stem = 2}
    --]]
    
    local myMaterials = {}
    local itemTable = {}
    
    --loop through inventory slots
    for i = 0,5 do
        local item = caster:GetItemInSlot(i)    --get the item in the slot
        if item ~= nil then --if the slot is full
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
    for key,value in pairs(recipeTable) do  --loop through the recipe table
        if CompareTables(recipeTable[key], myMaterials) then    --if a recipe matches
            print("Match!", key)
            local newItem = CreateItem(key, nil, nil)   --create the resulting item
            for i,removeMe in pairs(itemTable) do   --delete the materials
                caster:RemoveItem(removeMe)
            end
            caster:AddItem(newItem) --add the new item
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