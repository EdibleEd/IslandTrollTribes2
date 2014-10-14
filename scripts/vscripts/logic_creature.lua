function SpawnCreature(unitName)
    print("spawn")

    local spawnLocation = Entities:FindByName( nil, ("spawner_neutral_passive*"))
    -- use npc_dota_hero_axe for testing if this works regardless of custom units
    
    -- Disable to keep testing simple
    -- local creature = CreateUnitByName("npc_dota_creature_elk", spawnLocation:GetAbsOrigin() + RandomVector(RandomFloat(0,200)), true, nil, nil, DOTA_TEAM_BADGUYS)
    -- print ("create " .. t .. i .." has run")
    --creature:SetInitialGoalEntity( waypointlocation )
    --local waypointlocation = Entities:FindByName ( nil, (t .. "_wp" .. i))
    if spawnLocation ~= nil then
        local nearbyUnits = FindUnitsInRadius(
                                DOTA_TEAM_BADGUYS,
                                spawnLocation:GetOrigin(),
                                nil, 100,
                                DOTA_UNIT_TARGET_TEAM_BOTH,
                                DOTA_UNIT_TARGET_ALL,
                                DOTA_UNIT_TARGET_FLAG_NONE,
                                FIND_ANY_ORDER,
                                false)
        if #nearbyUnits == 0 then
            CreateUnitByName(unitName, spawnLocation:GetOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
            --CreateUnitByName("npc_creep_hawk", spawnLocation:GetOrigin(), false, nil, nil, DOTA_TEAM_NEUTRALS)
        end
    end
end
