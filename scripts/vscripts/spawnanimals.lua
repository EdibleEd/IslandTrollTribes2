
print( "Animal spawning script is running." )
function spawnAnimals()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for i = 1, 4, 1 do
            local spawnerActive = 1

            while spawnerActive>=1 do
                local spawnLocation = Entities:FindByName( nil, ("wildlife_elk_spawner" .. i))
                local waypointlocation = Entities:FindByName ( nil, ("elk_wp" .. i))
                --hscript CreateUnitByName( string name, vector origin, bool findOpenSpot, hscript, hscript, int team)
                -- Probably this should be DOTA_GC_TEAM_NOTEAM if BADGUYS and GOODGUYS are the trolls
                local creature = CreateUnitByName("Elk", spawnLocation:GetAbsOrigin() + RandomVector(RandomFloat(0,200)), true, nil, nil, DOTA_TEAM_BADGUYS)
                print ("create elk" .. i .." has run")
                --Sets the waypath to follow. "elk_wp#i"
                creature:SetInitialGoalEntity( waypointlocation )
                spawnerActive = 0
            end

            spawnerActive = 1
            while spawnerActive>=1 do
                spawnLocation = Entities:FindByName( nil, ("wildlife_hawk_spawner" .. i))
                waypointlocation = Entities:FindByName( nil, ("hawk_wp" .. i))
                local creature = CreateUnitByName("Hawk", spawnLocation:GetAbsOrigin() + RandomVector(RandomFloat(0, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
                print ("create hawk " .. i .." has run")
                creature:SetInitialGoalEntity( waypointlocation )
                spawnerActive = 0
            end
        end
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    return 10 -- This is how many seconds it will wait to retrigger the spawn mechanic
end

GameRules:GetGameModeEntity():SetThink("spawnAnimals",self,"SpawnAllAnimals",10)