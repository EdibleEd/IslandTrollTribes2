function Spawn(entityKeyValues)
	thisEntity:SetContextThink("skellythink", skellythink, 0.25)
	thisEntity.state = "follow"		--possible states = follow, attack, return
	local owner = thisEntity:GetOwner()
	--FindUnitsInRadius( iTeamNumber, vPosition, hCacheUnit, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, bCanGrowCache)
	--find the nearest enemy in 200 range of the player controlling the skellies
	local enemiesInRange = FindUnitsInRadius(
        owner:GetTeam(),
        owner:GetOrigin(),
        nil, 
        2000,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
        FIND_CLOSEST,
        false)
	
	print(#enemiesInRange)

	if #enemiesInRange > 0 then
		for i = 1, #enemiesInRange do
            --create a projectile and hit each of the three(five) closest enemies
            local targetEntity = enemiesInRange[i]      
            local info = {
                          EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
                          Ability = ABILITY_old_heimerdinger_rockets,
                          vSpawnOrigin = thisEntity:GetOrigin(),
                          fDistance = 5000,
                          fStartRadius = 125,
                          fEndRadius = 125,
                          Target = targetEntity,
                          Source = thisEntity,
                          iMoveSpeed = 100,
                          bReplaceExisting = false,
                          bHasFrontalCone = false,
                          --fMaxSpeed = 5200,
                        }
            ProjectileManager:CreateTrackingProjectile(info)
        end
    end

	print("starting skelly ai")

	thisEntity.spawnTime = GameRules:GetGameTime()
end

function skellythink()
	local owner = thisEntity:GetOwner()
	local followAngle = thisEntity.position
	local followPosition = owner:GetOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,thisEntity.position,0), owner:GetForwardVector()) * 100

	if not thisEntity:IsAlive() then
		return nil
	end

	if GameRules:GetGameTime() >= thisEntity.spawnTime + 30 then
		thisEntity:ForceKill(true)
		print("Skelly timed out")
		return nil
	end

	if (thisEntity.state == "follow") and (thisEntity:GetOrigin() ~= followPosition) then
		thisEntity:MoveToPosition(followPosition)
	end

	return 0.25
end