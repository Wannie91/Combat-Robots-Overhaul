local data = global.combatRobotsOverhaulData

for surface_id, list in pairs(data.targetList) do 

    for unit_number, entity in pairs(data.targetList[surface_id]) do 
        if entity.valid then 
            script.register_on_entity_destroyed(entity)
        else 
            data.targetList[surface_id][unit_number] = nil
        end
    end

end