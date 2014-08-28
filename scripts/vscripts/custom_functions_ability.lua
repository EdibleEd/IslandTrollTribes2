--Gatherer Ability Functions

function PingItemInRange(keys)
    --PrintTable(keys)
    local caster = keys.caster
    local range = keys.Range    
    local itemTable = keys.ItemTable
    
    for itemName,itemColor in pairs(itemTable) do
        if itemColor = nil then
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