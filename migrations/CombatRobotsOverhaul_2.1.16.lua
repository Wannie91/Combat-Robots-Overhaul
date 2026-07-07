data = storage.combatRobotsOverhaulData

for id, surface in pairs(data.targetList) do
    for key, entity in pairs(surface) do
        if not entity.valid then
            data.targetList[id][key] = nil
        end
    end
end

-- for key, defenderGroup in pairs(data.defenderGroups) do
--     for unit, entity in pairs(defenderGroup.members) do 
--         if not member.valid then 
--             defenderGroup.member[unit] = nil
--         end
--     end
--  end

-- for key, defenderGroups in pairs(data.defenderGroups) do
--     if not defenderGroups:has_members() then 
--         data.defenderGroups[key] = nil
--     end
-- end

-- for key, destroyerGroup in pairs(data.destroyerGroups) do
--         data.destroyerGroups[key] = nil
-- end