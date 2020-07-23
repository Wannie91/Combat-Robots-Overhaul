data:extend({
	{
		type = "item",
		name = "defender-unit",
		icon_size = 32,
		icon = "__base__/graphics/icons/defender.png",
		flags = {"hidden"},
		order = "d[combatrobot]",
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
		order = "e[combatrobot]",
		subgroup = "capsule",
		place_result = "sentry-unit",
		stack_size = 25
	},
	{
		type = "item",
		name = "destroyer-unit",
		icon_size = 32,
		icon = "__base__/graphics/icons/destroyer.png",
		flags = {"hidden"},
		order = "f[combatrobot]",
		subgroup = "capsule",
		place_result = "destroyer-unit",
		stack_size = 25
	},
})