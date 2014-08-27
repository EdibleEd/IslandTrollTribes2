function SpawnCreature(t, index)
    print("spawn")
    
    for i=1, 4, 1 do
        local spawnLocation = Entities:FindByName( nil, ("wildlife_".. t .. "_spawner" .. i))
        -- use npc_dota_hero_axe for testing if this works regardless of custom units
        
        -- Disable to keep testing simple
        -- local creature = CreateUnitByName("npc_dota_creature_elk", spawnLocation:GetAbsOrigin() + RandomVector(RandomFloat(0,200)), true, nil, nil, DOTA_TEAM_BADGUYS)
        -- print ("create " .. t .. i .." has run")
        --creature:SetInitialGoalEntity( waypointlocation )
        local waypointlocation = Entities:FindByName ( nil, (t .. "_wp" .. i))
    end
end
