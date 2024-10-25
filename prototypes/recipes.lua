data:extend(
{
    {
        type = "recipe",
        name = "defender-unit",
        enabled = false,
        energy_required = 15,
        ingredients = 
        {
            { type = "item", name = "iron-plate", amount = 5 },
            { type = "item", name = "copper-plate", amount = 5 },
            { type = "item", name = "electronic-circuit", amount = 3 }
        },
        results = {
            { type = "item", name = "defender-unit-capsule", amount = 1 }
        }
    },
    {
        type = "recipe",
        name = "sentry-unit",
        enabled = false,
        energy_required = 15,
        ingredients = 
        {
            { type = "item", name = "copper-plate", amount = 5 },
            { type = "item", name = "iron-plate", amount = 5 },
            { type = "item", name = "iron-gear-wheel", amount = 3 }
        },
        results = {
            { type = "item", name = "sentry-unit-capsule", amount = 1 }
        }
    },
    {
        type = "recipe",
        name = "destroyer-unit",
        enabled = false,
        energy_required = 15,
        ingredients = 
        {
            { type = "item", name = "steel-plate", amount = 5 },
            { type = "item", name = "copper-plate", amount = 5 },
            { type = "item", name = "iron-gear-wheel", amount = 3 },
            { type = "item", name = "electronic-circuit", amount = 5 }
        },
        results = {
            { type = "item", name = "destroyer-unit-capsule", amount = 1 }
        }
    }
})