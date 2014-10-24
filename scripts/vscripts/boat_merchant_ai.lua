function Spawn(entityKeyValues)
	thisEntity:SetContextThink("boatmerchantthink"..thisEntity:GetEntityIndex(), boatmerchantthink, 0.25)
	thisEntity.state = "move"		--possible states = move, wait
	
	
	print("starting merchant boat ai")
	thisEntity.waypointNum = 1
	thisEntity.spawnTime = GameRules:GetGameTime()
	thisEntity.endWait = 9999
	local GameMode = GameRules:GetGameModeEntity()
	GameMode.spawnedShops[thisEntity:GetUnitName()] = thisEntity
end

function boatmerchantthink()
	local path = thisEntity.path
	if path == nil then
		path = {"path_ship_waypoint_1","path_ship_waypoint_2","path_ship_waypoint_3","path_ship_waypoint_4","path_ship_waypoint_5", "path_ship_waypoint_6", "path_ship_waypoint_7"}
	end
	local waypointNum = thisEntity.waypointNum
	local waypointName = path[waypointNum]
	local waypointEnt = Entities:FindByName(nil, waypointName)
	local waypointPos = waypointEnt:GetOrigin()
	local GameMode = GameRules:GetGameModeEntity()

	if not thisEntity:IsAlive() then
		return nil
	end
	local distanceToWaypoint = (thisEntity:GetOrigin() - waypointPos)
	if (thisEntity.state == "move") and (distanceToWaypoint:Length2D() ~= 0) then
		thisEntity:MoveToPosition(waypointPos)
    elseif (thisEntity.state == "move") and (distanceToWaypoint:Length2D() == 0) then
    	thisEntity.state = "wait"
    	thisEntity.endWait = GameRules:GetGameTime()+ 15
	elseif (thisEntity.state == "wait") and (GameRules:GetGameTime() >= thisEntity.endWait) then
    	thisEntity.state = "move"
    	if waypointNum >= #path then
    		GameMode.spawnedShops[thisEntity:GetUnitName()] = nil
    		thisEntity:RemoveSelf()
		else
			thisEntity.waypointNum = thisEntity.waypointNum + 1
		end
	end

	return 0.25
end