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
        allow_paths_through_own_entities = false, 
        cache = false, 
        no_break = true, 
        prefer_straight_paths = true,
    },

    combatRobotFilter = {
        {
            filter = "name", 
            name = "defender-unit"
        }, 
        { 
            filter = "name", 
            name = "sentry-unit",
        }, 
        { 
            filter = "name", 
            name = "destroyer-unit",
        }
    },

}

return defines