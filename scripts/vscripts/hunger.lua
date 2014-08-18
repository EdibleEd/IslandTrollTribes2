-- Handles constant health degen, IE hunger
-- Author: Till Elton
--
-- Code from: Amanite, and http://www.reddit.com/r/Dota2Modding/comments/2dc0xm/guide_to_change_gold_over_time_to_reliable_gold/

print("Loaded Hunger")

-- Populates a list with each playernumber in the game
-- We use this to only call it for players actually in the game
local players = {}
for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
    if PlayerResource:GetPlayer(nPlayerID) ~= nil then
        players[nPlayerID] = nPlayerID
    end
end

-- This reduces each players health by 3, every 3 seconds
-- The return values ensure it closes when the game ends
-- Possibly need to detect only living heroes, will test that with more players
function decrementHealth()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for nPlayerID = 0, table.getn(players) do
            local hero = PlayerResource:GetPlayer(players[nPlayerID]):GetAssignedHero()
            hero:ModifyHealth(hero:GetHealth()-3, hero,true,-3)
        end
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil  
    end
    return 3
end

-- Start the thinker 3 seconds in
GameRules:GetGameModeEntity():SetThink("decrementHealth",self,"healthDegen",3)
