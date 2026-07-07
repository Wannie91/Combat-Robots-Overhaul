if not settings.startup["enable-vanilla-combatrobots"].value then

    -- disable vanilla capsules
    data.raw.capsule["defender-capsule"].hidden = true
    data.raw.capsule["defender-capsule"].hidden_in_factoriopedia = true
    data.raw.capsule["distractor-capsule"].hidden = true
    data.raw.capsule["distractor-capsule"].hidden_in_factoriopedia = true
    data.raw.capsule["destroyer-capsule"].hidden = true
    data.raw.capsule["destroyer-capsule"].hidden_in_factoriopedia = true

    -- disable recipes
    data.raw.recipe["defender-capsule"].enabled = false
    data.raw.recipe["defender-capsule"].hidden_in_factoriopedia = true
    data.raw.recipe["distractor-capsule"].enabled = false
    data.raw.recipe["distractor-capsule"].hidden_in_factoriopedia = true
    data.raw.recipe["destroyer-capsule"].enabled = false
    data.raw.recipe["destroyer-capsule"].hidden_in_factoriopedia = true

    -- hide distractor and destroyer technology
    data.raw.technology.distractor.enabled = false
    -- data.raw.technology.distractor.hidden = true 
    data.raw.technology.destroyer.enabled = false
    -- data.raw.technology.destroyer.hidden = true

    --hide vanilla combat robots from factoriopedia
    data.raw["combat-robot"]["destroyer"].hidden_in_factoriopedia = true
    data.raw["combat-robot"]["defender"].hidden_in_factoriopedia = true
    data.raw["combat-robot"]["distractor"].hidden_in_factoriopedia = true

    data.raw.technology["follower-robot-count-4"].prerequisites["destroyer"] = nil
    data.raw.technology["follower-robot-count-4"].prerequisites = {"defender"}
    data.raw.technology["defender"].effects[1] = { type = "unlock-recipe", recipe = "defender-unit"}

    if mods["space-age"] then
        data.raw.technology["electric-weapons-damage-1"].prerequisites = { "defender"}
    end

else
    table.insert(data.raw.technology["defender"].effects, {type = "unlock-recipe", recipe = "defender-unit"})
end

if mods["UnminableBots"] then 
    data.raw["unit"]["sentry-unit"].minable = nil
    data.raw["unit"]["destroyer-unit"].minable = nil
    data.raw["spider-vehicle"]["defender-unit"].minable = nil
end

if mods["IndustrialRevolution"] then
    
    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "sentry-unit" })
    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "defender-unit" })
    table.insert(data.raw.technology["defender"].effects, { type = "unlock-recipe", recipe = "destroyer-unit" })

end