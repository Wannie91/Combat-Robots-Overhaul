local defines = {

    capsules = {
        defender = "defender-unit-capsule",
        sentry = "sentry-unit-capsule",
        destroyer = "destroyer-unit-capsule",        
    },

    units = {
        defender = "defender-unit",
        sentry = "sentry-unit",
        destroyer = "destroyer-unit",
    },

    associations = {
        ["defender-unit-capsule"] = "defender-unit",
        ["sentry-unit-capsule"] = "sentry-unit",
        ["destroyer-unit-capsule"] = "destroyer-unit",
    },

    pathfinding_flags = {
        allow_paths_through_own_entities = true, 
        cache = false, 
        no_break = true, 
        prefer_straight_paths = true 
    },

}

return defines