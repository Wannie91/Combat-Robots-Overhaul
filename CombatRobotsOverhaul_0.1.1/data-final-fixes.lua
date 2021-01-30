if not settings.startup["enable-vanilla-combatrobots"].value then 

    -- disable capsules
    data.raw["capsule"]["distractor-capsule"].flags = { "hidden" }
    data.raw["capsule"]["defender-capsule"].flags = { "hidden" }
    data.raw["capsule"]["destroyer-capsule"].flags = { "hidden" }

    --disable recipes
    data.raw.recipe["distractor-capsule"].enabled = false
    data.raw.recipe["defender-capsule"].enabled = false
    data.raw.recipe["destroyer-capsule"].enabled = false
    
    --disable combat robotics 2 & 3
    data.raw["technology"]["distractor"].enabled = false
    data.raw["technology"]["destroyer"].enabled = false

    data.raw["technology"]["defender"].effects[1] = nil
    data.raw["technology"]["distractor"].effects[1] = nil
    data.raw["technology"]["destroyer"].effects[2] = nil

end