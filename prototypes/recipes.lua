data:extend({
	{
		type = "recipe",
		name = "destroyer-unit",
		enabled = false,
		energy_required = 15,
		ingredients = 
		{	
			{ "steel-plate", 10 },
			{ "copper-cable", 5 },
			{ "iron-gear-wheel", 5},
		},
		result = "destroyer-unit-capsule"
	},
	{
		type = "recipe",
		name = "defender-unit",
		enabled = false,
		energy_required = 8,
		ingredients = 
		{	
			{ "piercing-rounds-magazine", 3 },
			{ "electronic-circuit", 3 },
			{ "iron-gear-wheel", 5},
		},
		result = "defender-unit-capsule"
	},
	{
		type = "recipe",
		name = "sentry-unit",
		enabled = false,
		energy_required = 15,
		ingredients = 
		{
			{ "copper-plate", 5 },
			{ "iron-plate", 5 },
			{ "iron-gear-wheel", 5}
		},
		result = "sentry-unit-capsule"
	}
})