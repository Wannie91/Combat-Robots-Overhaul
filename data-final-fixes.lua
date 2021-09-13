if not settings.startup["enable-vanilla-combatrobots"].value then 

    -- disable vanilla capsules
    data.raw.capsule["defender-capsule"].flags = {"hidden"}
    data.raw.capsule["distractor-capsule"].flags = {"hidden"}
    data.raw.capsule["destroyer-capsule"].flags = {"hidden"}

    -- disable recipes
    data.raw.recipe["defender-capsule"].enabled = false
    data.raw.recipe["distractor-capsule"].enabled = false
    data.raw.recipe["destroyer-capsule"].enabled = false
    
    data.raw.technology.defender.effects[1] = nil
    data.raw.technology.distractor.effects[1] = nil
    data.raw.technology.destroyer.effects[1] = nil

    data.raw.technology["follower-robot-count-5"].prerequisites[2] = nil

end

if mods["UnminableBots"] then 
    data.raw["unit"]["sentry-unit"].minable = nil
    data.raw["unit"]["destroyer-unit"].minable = nil
    data.raw["spider-vehicle"]["defender-unit"].minable = nil
end

if mods["IndustrialRevolution"] then
    -- data.raw.technology["follower-robot-count-4"].effects[3] = nil
    -- data.raw.technology["follower-robot-count-7"].effects[3] = nil

    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "sentry-unit" })
    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "defender-unit" })
    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "destroyer-unit" })

end