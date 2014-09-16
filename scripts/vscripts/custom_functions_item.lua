--[[
if itemFunctions == nil then
	print ( '[ItemFunctions] creating itemFunctions' )
	itemFunctions = {} -- Creates an array to let us be able to index itemFunctions when creating new functions
	itemFunctions.__index = itemFunctions
end

function itemFunctions:new() -- Creates the new class
	print ( '[ItemFunctions] itemFunctions:new' )
	o = o or {}
	setmetatable( o, itemFunctions )
	return o
end

function itemFunctions:start() -- Runs whenever the itemFunctions.lua is ran
	print('[ItemFunctions] itemFunctions started!')
end
]]--
function DropItemOnDeath(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] DropItemOnDeath Called' )
	local killedUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.
	if killedUnit:IsHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
				if killedUnit ~= nil then --checks to make sure the killed unit is not nonexistent.
						local Item = killedUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
						if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
							local newItem = CreateItem(itemName, nil, nil) -- creates a new variable which recreates the item we want to drop and then sets it to have no owner
								CreateItemOnPositionSync(killedUnit:GetOrigin() + RandomVector(RandomInt(20,100)), newItem) -- takes the newItem variable and creates the physical item at the killed unit's location
								killedUnit:RemoveItem(Item) -- finally, the item is removed from the original units inventory.
							end
						end
					end
				end
			end

			function StoneStun(keys)
				local caster = keys.caster
				local target = keys.target
				local targetName = target:GetName()
	local dur = 7.0	--default duration for anything besides heros
	if (target:IsHero()) then --if the target's name includes "hero"
		dur = 1.0	--then we use the hero only duration
	end
	print("Stone Stunned!")
	target:AddNewModifier(caster, nil, "modifier_stunned", { duration = dur})
end

function EatMeatRaw(keys)	--triggers the meat eating channel ability
	---[[
	local caster = keys.caster
	local abilityName = "ability_item_eat_meat_raw"
	local ability = caster:FindAbilityByName(abilityName)
	if ability == nil then
		caster:AddAbility(abilityName)
		ability = caster:FindAbilityByName( abilityName )
		ability:SetLevel(1)
		
	end
	print("trying to cast ability ", abilityName)
	caster:CastAbilityNoTarget(ability, -1)
	--caster:RemoveAbility(abilityName)
	--]]
end

function MageMasherManaBurn(keys)
	local caster = keys.caster
	local target = keys.target
	local damage = keys.Damage
	local targetName = target:GetUnitName()
	--look for mage and priests only
	if ((string.find(targetName,"mage") ~= nil) or (string.find(targetName,"priest")~= nil) or (string.find(targetName,"dazzle")~= nil) or (string.find(targetName,"witch")~= nil)) then
		--print("Burning " .. damage .. " mana")
		local startingMana = target:GetMana()
		target:SetMana(startingMana - damage)
		--print("Old mana " .. startingMana .. ". New Mana " .. target:GetMana())
		
		local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL}						

		ApplyDamage(damageTable)
		
		local thisParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(thisParticle)
		target:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	else
		print(targetName .. " is not Mage or Priest")
	end	
end

function SpearDarkThrow(keys)
	local caster = keys.caster
	local target = keys.target
	local damageMin = keys.DamageMin
	local damageMax = keys.DamageMax
	local randomDamage = RandomInt(damageMin, damageMax)
	-- damage energy here
	local dur = 2.0
	if (target:IsHero()) then --if the target's name includes "hero"
		dur = 0.5	--then we use the hero only duration
	end
	local startingMana = target:GetMana()
	target:SetMana(startingMana - randomDamage)
	
	local damageTable = {
	victim = target,
	attacker = caster,
	damage = randomDamage,
	damage_type = DAMAGE_TYPE_MAGICAL}

	ApplyDamage(damageTable)
	target:AddNewModifier(caster, nil, "modifier_stunned", { duration = dur})
	print("Spear hit! Burning " .. randomDamage .. " mana")
end

function SpearPoisonThrowInit(keys)
	local caster = keys.caster
	local target = keys.target
	local moveSpeedSlowPercent = keys.MoveSpeedSlow
	local attackSpeedSlowPercent = keys.AttackSpeedSlow

	if target.startingMoveSpeed == nil then
		print("fresh start")
		startingAttackTime = target:GetBaseAttackTime()
		startingMoveSpeed = target:GetBaseMoveSpeed()
		keys.target.startingMoveSpeed = startingMoveSpeed
		keys.target.startingAttackTime = startingAttackTime
	else
		print("refreshing")
		target:SetBaseMoveSpeed(target.startingMoveSpeed)
		target:SetBaseAttackTime(target.startingAttackTime)
		startingAttackTime = target:GetBaseAttackTime()
		startingMoveSpeed = target:GetBaseMoveSpeed()
	end

	print("Starting Movespeed: ".. target:GetBaseMoveSpeed() .. " AttackTime: " .. target:GetBaseAttackTime())

	local moveSpeedReduction = startingMoveSpeed*(moveSpeedSlowPercent/100)
	local attackSpeedReduction = startingAttackTime*(attackSpeedSlowPercent/100)

	target:SetBaseMoveSpeed(startingMoveSpeed - moveSpeedReduction)
	target:SetBaseAttackTime(startingAttackTime + attackSpeedReduction)	--higher base attack time = slower attack

	local numTicks = 30
	keys.target.moveSpeedSlowTick = moveSpeedReduction / numTicks
	keys.target.attackSpeedSlowTick = attackSpeedReduction / numTicks
	keys.target.tickNum = 0
	print("MS tick: ".. keys.target.moveSpeedSlowTick .. " AS tick: " .. keys.target.attackSpeedSlowTick)
	print("Slowed Movespeed: ".. target:GetBaseMoveSpeed() .. " AttackTime: " .. target:GetBaseAttackTime())
end

function SpearPoisonThrowTick(keys)
	local caster = keys.caster
	local target = keys.target

	target:SetBaseMoveSpeed(target.startingMoveSpeed - target.moveSpeedSlowTick*(30-target.tickNum))
	target:SetBaseAttackTime(target:GetBaseAttackTime() - target.attackSpeedSlowTick)
	keys.target.tickNum = keys.target.tickNum + 1
	print("Movespeed: ".. target:GetBaseMoveSpeed() .. " AttackTime: " .. target:GetBaseAttackTime())
end

function SpearPoisonEnd(keys)
	local caster = keys.caster
	local target = keys.target

	print(target, target.startingMoveSpeed)

	target:SetBaseMoveSpeed(target.startingMoveSpeed)
	target:SetBaseAttackTime(target.startingAttackTime)

	keys.target.startingMoveSpeed = nil
	keys.target.startingAttackTime = nil

	print("Ending Movespeed: ".. target:GetBaseMoveSpeed() .. " AttackTime: " .. target:GetBaseAttackTime())
end

function PotionManaUse(keys)
	local caster = keys.caster

	local startingMana = caster:GetMana()
	caster:SetMana(startingMana + keys.ManaRestored)
end

function PotionDrunkUse(keys)
	local caster = keys.caster
	local target = keys.target

	local dur = 13.0
    if (target:IsHero()) then --if the target is a hero unit, shorter duration
        dur = 9.0
    end
    
    target:AddNewModifier(caster, nil, "modifier_brewmaster_drunken_haze", {duration = dur, movement_slow = 10, miss_chance = 50})    
end

function PotionCureallUse(keys)
	local caster = keys.caster

	local numModifiers = caster:GetModifierCount()

	for i = 0, numModifiers do
		local modName = caster:GetModifierNameByIndex()
		caster:RemoveModifierByName(modName)
	end
end