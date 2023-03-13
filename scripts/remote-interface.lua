remote.add_interface(

    "combat-robot-overhaul",
    {
        -- /c remote.call("combat-robot-overhaul", "get_targetList", surface_index = 1)
        get_targetList = function(surface_index) 
            if surface_index then
                return global.combatRobotsOverhaulData.targetList[surface_index]
            else
                return global.combatRobotsOverhaulData.targetList
            end
        end

    }
)