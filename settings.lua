data:extend({
    {
        type = "bool-setting",
        name = "enable-vanilla-combatrobots",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "string-setting",
        name = "defence-exclude-list",
        setting_type = "runtime-global", 
        default_value = "defender-unit,sentry-unit,destroyer-unit,gun-turret,laser-turret,distractor,defender,destroyer,stone-wall,gate,spidertron",
        allow_blank = true,
    },
    {
        type = "double-setting", 
        name = "sentry-radius", 
        setting_type = "runtime-global",
        default_value = 3,
        minimum_value = 1,
        maximum_value = 20
    },
    {
        type = "double-setting",
        name = "base-defence-perimeter",
        setting_type = "runtime-global",
        default_value = 2500,
        minimum_value = 100,
        maximum_value = 5000,
    },
    {
        type = "double-setting",
        name = "defender-distance",
        setting_type = "runtime-per-user",
        default_value = 0,
        minimum_value = 0,
        maximum_value = 100
    },
    {
        type = "int-setting", 
        name = "attack-delay",
        setting_type = "runtime-global",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 60
    },
})