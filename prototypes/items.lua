data:extend({
    {
        type = "item",
        name = "defender-unit",
        icon_size = 32,
        icon = "__base__/graphics/icons/defender.png",
        flags = {"hidden"},
        order = "i[combatrobot]",
        subgroup = "capsule",
        place_result = "defender-unit",
        stack_size = 25
    },
    {
        type = "item",
        name = "sentry-unit",
        icon_size = 32,
        icon = "__base__/graphics/icons/distractor.png",
        flags = {"hidden"},
        order = "j[combatrobot]",
        subgroup = "capsule",
        place_result = "sentry-unit",
        stack_size = 25
    },
    {
        type = "item",
        name = "destroyer-unit",
        icon = "__base__/graphics/icons/destroyer.png",
        icon_size = 32,
        flags = { "hidden" },
        order = "h[combatrobot]",
        subgroup = "capsule",
        place_result = "destroyer-unit",
        stack_size = 25,
    },
})