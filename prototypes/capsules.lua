local sounds = require("__base__/prototypes/entity/sounds")
local item_sounds = require("__base__/prototypes/item_sounds")

data:extend({
    {
        type = "capsule",
        name = "defender-unit-capsule",
        icon = "__base__/graphics/icons/defender.png",
        icon_size = 64,
        capsule_action =
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                activation_type = "throw",
                ammo_category = "capsule",
                projectile_creation_distance = 0.6,
                cooldown = 30,
                range = 25,
                ammo_type = 
                {
                    category = "capsule",
                    target_type = "position",
                    action = 
                    {
                        {                                
                            type = "direct",
                            action_delivery = 
                            {
                                -- type = "instant",
                                -- target_effects = 
                                -- {
                                --     type = "damage",
                                --     show_in_tooltip = false,
                                --     damage = {type = "physical", amount = 0}
                                -- }
                                type = "projectile",
                                projectile = "defender-unit-capsule",
                                starting_speed = 0.3
                            }
                        },
                        {
                            type = "direct",
                            action_delivery = 
                            {
                                type = "instant",
                                target_effects = 
                                {
                                    type = "play-sound",
                                    sound = sounds.throw_projectile,
                                }
                            }
                        }
                    }
                }
            }
        },
        subgroup = "capsule",
        order = "d[defender-unit-capsule]",
        inventory_move_sound = item_sounds.grenade_inventory_move,
        pick_sound = item_sounds.grenade_inventory_pickup,
        drop_sound = item_sounds.grenade_inventory_move,
        stack_size = 100,
        weight = 10*kg
    },
    {
        type = "capsule",
        name = "sentry-unit-capsule",
        icon = "__base__/graphics/icons/distractor.png",
        icon_size = 64,
        capsule_action = 
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                activation_type = "throw",
                ammo_category = "capsule",
                projectile_creation_distance = 0.6,
                cooldown = 30,
                range = 25,
                ammo_type = 
                {
                    category = "capsule",
                    target_type = "position",
                    action = 
                    
                    {
                        {
                            type = "direct",
                            action_delivery = 
                            {
                                -- type = "instant",
                                -- target_effects = 
                                -- {
                                --     type = "damage",
                                --     damage = {type = "physical", amount = 0}
                                -- },
                                type = "projectile",
                                projectile = "sentry-unit-capsule",
                                starting_speed = 0.3
                            }
                        },
                        {
                            type = "direct",
                            action_delivery = 
                            {
                                type = "instant",
                                target_effects = 
                                {
                                    {
                                        type = "play-sound",
                                        sound = sounds.throw_projectile,
                                    }
                                }
                            }
                        },
                        -- {
                        --     type = "direct",
                        --     action_delivery = 
                        --     {
                        --         type = "instant",
                        --         target_effects = 
                        --         {
                        --             {
                        --                 type = "create-entity",
                        --                 entity_name = "sentry-unit",
                        --                 show_in_tooltip = true,
                        --             }
                        --         }
                        --     }
                        -- }
                    }
                }
            }
        },
        subgroup = "capsule",
        order = "e[sentry-unit-capsule]",
        inventory_move_sound = item_sounds.robotic_inventory_move,
        pick_sound = item_sounds.robotic_inventory_pickup,
        drop_sound = item_sounds.robotic_inventory_move,
        stack_size = 100,
        weight = 20*kg
    },
    {
        type = "capsule",
        name = "destroyer-unit-capsule",
        icon = "__base__/graphics/icons/destroyer.png",
        icon_size = 64,
        capsule_action = 
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                activation_type = "throw",
                ammo_category = "capsule",
                cooldown = 30,
                projectile_creation_distance = 0.6,
                range = 20,
                ammo_type = 
                {
                    category = "capsule",
                    target_type = "position",
                    action = 
                    {
                        {                                
                            type = "direct",
                            action_delivery = 
                            {
                                -- type = "instant",
                                -- target_effects = 
                                -- {
                                --     type = "damage",
                                --     damage = {type = "physical", amount = 0}
                                -- }
                                type = "projectile",
                                projectile = "destroyer-unit-capsule",
                                starting_speed = 0.3
                            }
                        },
                        {
                            type = "direct",
                            action_delivery = 
                            {
                                type = "instant",
                                target_effects = 
                                {
                                    {
                                        type = "play-sound",
                                        sound = sounds.throw_projectile,
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        subgroup = "capsule",
        order = "f[destroyer-capsule]",
        inventory_move_sound = item_sounds.robotic_inventory_move,
        pick_sound = item_sounds.robotic_inventory_pickup,
        drop_sound = item_sounds.robotic_inventory_move,
        stack_size = 100,
        weight = 40*kg
    }
})