data:extend({
    {
        type = "custom-input",
        name = "defend-player",
        key_sequence = "CONTROL + SHIFT + D",
        consuming = "game-only",
        action = "lua"
    },
    {
        type = "shortcut",
        name = "defend-player",
        action = "lua",
        order = "h[combatRobot]",
        technology_to_unlock = "defender",
        associated_control_input = "defend-player",
        toggleable = true,
        icon = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x32.png",
        icon_size = 32,
        small_icon = "__CombatRobotsOverhaul__/graphics/icons/defend-player-x24.png",
        small_icon_size = 24,
        unavailable_until_unlocked = true,
    },
})