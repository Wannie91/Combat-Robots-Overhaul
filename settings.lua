data:extend({
    {
        type = "int-setting", 
        name = "time-before-attack",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 60
    },
    {
        type = "double-setting",
        name = "defender-distance",
        setting_type = "runtime-per-user",
        default_value = 3,
        minimum_value = 0,
        maximum_value = 10
    },
    {
        type = "double-setting",
        name = "sentry-radius",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 20
    },
    {
        type = "double-setting",
        name = "base-defender-radius",
        setting_type = "runtime-global",
        default_value = 2500,
        minimum_value = 100,
        maximum_value = 5000,
    },
})