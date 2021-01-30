data:extend({
    {
        type = "custom-input",
        name = "keyboard-toggle-defender",
        key_sequence = "CONTROL + SHIFT + D",
        consuming = "game-only",
        action = "lua"
    },
    {
        type = "shortcut",
        name = "toggle-defender", 
        action = "lua", 
        order = "h[combatRobot]",
        technology_to_unlock = "defender",
        associated_control_input = "toggle-defender",
        toggleable = true,
        icon = {
            filename = "__CombatRobotsOverhaul__/graphics/icons/toogle-defender-x32.png",
            flags = { "icon" },
            priority = "extra-high-no-scale",
            scale = 1,
            size = 32
        },
        small_icon = {
            filename = "__CombatRobotsOverhaul__/graphics/icons/toogle-defender-x24.png",
            flags = { "icon" },
            priority = "extra-high-no-scale",
            scale = 1,
            size = 24
        },
        disabled_icon = {
            filename = "__CombatRobotsOverhaul__/graphics/icons/toogle-defender-x32-white.png",
            flags = { "icon" },
            priority = "extra-high-no-scale",
            scale = 1,
            size = 32
        },
        disabled_small_icon = {
            filename = "__CombatRobotsOverhaul__/graphics/icons/toogle-defender-x24-white.png",
            flags = { "icon" },
            priority = "extra-high-no-scale",
            scale = 1,
            size = 24
        },
    },
})