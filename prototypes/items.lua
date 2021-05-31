local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")

local item_category =
{
    type = "item-subgroup",
    name = "defender-unit-category",
    group = "combat",
    order = "f[combatrobot]",
}

local defender_grid = 
{
    type = "equipment-grid",
    name = "defender-unit-equipment-grid",
    width = 0,
    height = 0,
    locked = true,
    equipment_categories = {"defender-unit-category"},
}

local equipments = 
{
    {
        type = "item",
        name = "defender-unit-equipment",
        icons =
        {
            {
            icon = "__base__/graphics/icons/submachine-gun.png",
            icon_size = 64
            },
            {
            icon = "__base__/graphics/icons/submachine-gun.png",
            icon_size = 64,
            scale = 0.333,
            },
        },
        placed_as_equipment_result = "defender-unit-equipment",
        subgroup = "defender-unit-category",
        order = "g[combatrobot]",
        default_request_amount = 1,
        stack_size = 20
    },
    {
        type = "active-defense-equipment",
        name = "defender-unit-equipment",
        categories = {"defender-unit-category"},
        sprite = 
        {
            filename = "__base__/graphics/icons/submachine-gun.png",
            size = 1,
            priority = "low"
        },
        shape = 
        {
            width = 0,
            height = 0,
            type = "full",
        },

        energy_source = 
        {
            type = "void",
            usage_priority = "primary-input",
        },

        automatic = true,
        attack_parameters = 
        {
            type = "projectile",
            cooldown = 20,
            cooldown_deviation = 0.2,
            projectile_center = {0,1},
            projectile_creation_distance = 0.6,
            range = 15,
            sound = sounds.defender_gunshot,
            ammo_type = 
            {
                category = "bullet",
                action = 
                {
                    type = "direct",
                    action_delivery = 
                    {
                        type = "instant",
                        source_effects = 
                        {
                            type = "create-explosion",
                            entity_name = "explosion-gunshot-small",
                        },
                        target_effects = 
                        {
                            {
                                type = "create-entity",
                                entity_name = "explosion-hit",
                            },
                            {
                                type = "damage",
                                damage = {amount = 9, type = "physical"}
                            }
                        }
                    }
                }
            },
            animation = 
            {
                layers = 
                {
                    animations.defender_unit.base_animation,
                    animations.defender_unit.shadow_base_animation
                }
            }
        },
    },
}

local items = 
{   
    {
        type = "item-with-entity-data",
        name = "defender-unit",
        icon_size = 32,
        icon = "__base__/graphics/icons/defender.png",
        flags = {"hidden"},
        order = "i[combatrobot]",
        subgroup = "capsule",
        place_result = "defender-unit",
        stack_size = 25,
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
        flags = {"hidden"},
        order = "h[combatrobot]",
        subgroup = "capsule",
        place_result = "destroyer-unit",
        stack_size = 25,
    },
}

data:extend({
    item_category,
    defender_grid,
})

data:extend(equipments, items)
