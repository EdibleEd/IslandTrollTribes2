function Spawn(entityKeyValues)
	thisEntity:SetContextThink("passive_neutral_ai_think"..thisEntity:GetEntityIndex(), PassiveNeutralThink, 0.25)
	thisEntity.state = "wander"		--possible states = wander, flee

	print("starting passive neutral ai")

	thisEntity.spawnTime = GameRules:GetGameTime()
end

function PassiveNeutralThink()
	if not thisEntity:IsAlive() then
		return nil
	end

	if (thisEntity.state == "wander") then
		local newPosition = thisEntity:GetAbsOrigin() + RandomVector(1000)
		thisEntity:MoveToPosition(newPosition)
		
    elseif (thisEntity.state == "flee") then
    	
	end

	return RandomFloat(10, 30)
end
