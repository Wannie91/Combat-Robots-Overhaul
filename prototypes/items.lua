local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")
local smoke_animations = require("__base__/prototypes/entity/smoke-animations")
local smoke_fast_animation = smoke_animations.trivial_smoke_fast

local collision_layer = {
    type = "collision-layer", 
    name = "flying"
}

local item_category = 
{
    type = "item-subgroup",
    name = "combat-unit-category",
    group = "combat",
    order = "f[combatrobot]",
}

local beam_ammo = 
{
    type = "ammo",
    name = "beam-ammo",
    localised_name = "Beam Ammo",
    icon = "__base__/graphics/icons/ammo-category/beam.png",  
    icon_size = 64,
    icon_mipmaps = 4,
    hidden = true,
    ammo_category = "beam",
    ammo_type = 
    {
        action =
        {
            type = "direct",
            action_delivery = 
            {
                type = "beam",
                beam = "electric-beam",
                max_length = 25,
                duration = 20,
                source_offset = {0.15, -0.5}
            }
        }
    },
    magazine_size = 1,
    subgroup = "ammo",
    order = "z[beam]-a[beam-ammo]",  
    stack_size = 1
}

local unit_guns =  
{
    {   
        type = "gun",
        name = "defender-unit-gun",
        localised_name = "Defender Unit Gun",
        icon = "__base__/graphics/icons/submachine-gun.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "gun",
        hidden = true,
        order = "h[combatrobot]-a[defender-unit-gun]",
        stack_size = 1,
        attack_parameters = 
        {
            type = "projectile",
            cooldown = 20,
            cooldown_deviation = 0.2,
            projectile_center = {0,1},
            projectile_creation_distance = 0.6,
            range = 15,
            sound = sounds.defender_gunshot,
            ammo_category = "bullet",
            ammo_consumption_modifier = 0,
            ammo_type = 
            {
                ammo_consumption_modifier = 0,
                consumption_modifier  = 0,
                energy_consumption = "0kW",
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
        }
    },
    {   
        type = "gun",
        name = "destroyer-unit-gun",
        localised_name = "Destroyer Unit Gun",
        icon = "__base__/graphics/icons/ammo-category/beam.png",
        icon_size = 64,
        icon_mipmaps = 4,
        subgroup = "gun",
        hidden = true,
        order = "h[combatrobot]-a[destroyer-unit-gun]",
        stack_size = 1,
        attack_parameters = 
        {
            type = "beam",
            ammo_category = "beam",
            cooldown = 20,
            cooldown_deviation = 0.2,
            range = 20,
            range_mode = "center-to-bounding-box",
            damage_modifier = 2,
            projectile_center = {0,1},
            projectile_creation_distance = 0.6,

            sound = make_laser_sounds(),
            ammo_consumption_modifier = 0,
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
                        max_length = 25,
                        duration = 20,
                        source_offset = {0.15, -0.5}
                    }
                }
            }
        }
    }
}
      
local items = 
{
    {
        type = "item-with-entity-data",
        name = "defender-unit",
        icon_size = 32,
        icon = "__base__/graphics/icons/defender.png",
        hidden = true,
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
        hidden = true,
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
        hidden = true,
        order = "h[combatrobot]",
        subgroup = "capsule",
        place_result = "destroyer-unit",
        stack_size = 25,
    },
}


data:extend({
    item_category,
    beam_ammo,
    collision_layer,
})

-- data:extend(equipment, items)
data:extend(items)
data:extend(unit_guns)