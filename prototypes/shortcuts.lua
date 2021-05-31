local custom_input = 
{
    type = "custom-input",
    name = "defend-player",
    key_sequence = "CONTROL + SHIFT + D",
    consuming = "game-only",
    action = "lua",
}

local shortcut = 
{
    type = "shortcut",
    name = "defend-player";
    action = "lua",
    order = "h[combatRobot]",
    technology_to_unlock = "defender",
    associated_control_input = "defend-player",
    toggleable = true,
    icon = {
        filename = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x32.png",
        flags = {"icon"},
        priority = "extra-high-no-scale",
        scale = 1,
        size = 32
    },
    small_icon = {
        filename = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x24.png",
        flags = {"icon"},
        priority = "extra-high-no-scale",
        scale = 1,
        size = 24
    },
    disabled_icon = {
        filename = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x32-white.png",
        flags = {"icon"},
        priority = "extra-high-no-scale",
        scale = 1,
        size = 32
    },
    disabled_small_icon = {
        filename = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x24-white.png",
        flags = {"icon"},
        priority = "extra-high-no-scale",
        scale = 1,
        size = 24
    },
}

data:extend({custom_input, shortcut})