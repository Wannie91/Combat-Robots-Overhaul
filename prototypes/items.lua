local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")

local item_category = 
{
    type = "item-subgroup",
    name = "combat-unit-category",
    group = "combat",
    order = "f[combatrobot]",
}

local combat_grid = 
{
    type = "equipment-grid",
    name = "combat-unit-equipment-grid",
    width = 0,
    height = 0,
    locked = true,
    equipment_categories = {"combat-unit-category"}
}

local equipment = 
{
    {
        type = "item",
        name = "defender-unit-equipment",
        icons = 
        {
            {
                icon = "__base__/graphics/icons/submachine-gun.png",
                icon_size = 64,
            },
            {
                icon = "__base__/graphics/icons/submachine-gun.png",
                icon_size = 64,
                scale = 0.333,
            },
        },
        placed_as_equipment_result = "defender-unit-equipment",
        subgroup = "combat-unit-category",
        order = "g[combatrobot]",
        default_request_amount = 1,
        stack_size = 20,
    },
    {
        type = "active-defense-equipment",
        name = "defender-unit-equipment",
        categories = {"combat-unit-category"},
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
                                damage = {amount = 8, type = "physical"}
                            }
                        }
                    }
                }
            },
        },
    },
    {
        type = "item",
        name = "destroyer-unit-equipment",
        icons = 
        {
            {
                icon = "__base__/graphics/icons/submachine-gun.png",
                icon_size = 64,
            },
            {
                icon = "__base__/graphics/icons/submachine-gun.png",
                icon_size = 64,
                scale = 0.333,
            },
        },
        placed_as_equipment_result = "destroyer-unit-equipment",
        subgroup = "combat-unit-category",
        order = "g[combatrobot]",
        default_request_amount = 1,
        stack_size = 20,
    },
    {
        type = "active-defense-equipment",
        name = "destroyer-unit-equipment",
        categories = {"combat-unit-category"},
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
            type = "beam",
            ammo_category = "beam",
            cooldown = 20,
            cooldown_deviation = 0.2,
            range = 20,
            sound = make_laser_sounds(),
            ammo_type = 
            {
                category = "beam",
                action = 
                {
                    type = "direct",
                    action_delivery =
                    {
                        type = "beam",
                        beam = "electric-beam",
                        max_length = 20,
                        duration = 20,
                        source_offset = { 0.15, -0.5 }
                    }
                }
            },
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
        stack_size = 25,
    },
    {
        type = "item-with-entity-data",
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
    combat_grid,
    equipment_category
})

data:extend(equipment, items) 