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

end