local sounds = require("__base__/prototypes/entity/sounds")

data:extend({
    {
        type = "capsule",
        name = "defender-unit-capsule",
        icon = "__base__/graphics/icons/defender.png",
        icon_size = 64,
        icon_mipmaps = 4,      
        capsule_action =
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                ammo_category = "capsule",
                projectile_creation_distance = 0.6,
                cooldown = 15,
                range = 20,
                ammo_type = 
                {
                    category = "capsule",
                    target_type = "position",
                    action = 
                    {
                        type = "direct",
                        action_delivery = 
                        {
                            type = "instant",
                            target_effects = 
                            {
                                type = "damage",
                                damage = {type = "physical", amount = 0}
                            }
                        }
                        -- type = "projectile",
                        -- projectile = "defender-unit-capsule",
                        -- starting_speed = 0.3
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
        },
        subgroup = "capsule",
        order = "d[defender-unit-capsule]",
        stack_size = 100,
    },
    {
        type = "capsule",
        name = "sentry-unit-capsule",
        icon = "__base__/graphics/icons/distractor.png",
        icon_size = 64, icon_mipmaps = 4,
        capsule_action = 
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                ammo_category = "capsule",
                projectile_creation_distance = 0.6,
                cooldown = 15,
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
                                type = "instant",
                                target_effects = 
                                {
                                    type = "damage",
                                    damage = {type = "physical", amount = 0}
                                },
                                -- type = "projectile",
                                -- projectile = "sentry-unit-capsule",
                                -- starting_speed = 0.3
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
        order = "e[sentry-unit-capsule]",
        stack_size = 100,
    },
    {
        type = "capsule",
        name = "destroyer-unit-capsule",
        icon = "__base__/graphics/icons/destroyer.png",
        icon_size = 64,
        icon_mipmaps = 4,
        capsule_action = 
        {
            type = "throw",
            attack_parameters = 
            {
                type = "projectile",
                ammo_category = "capsule",
                cooldown = 15,
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
                                type = "instant",
                                target_effects = 
                                {
                                    type = "damage",
                                    damage = {type = "physical", amount = 0}
                                }
                                -- type = "projectile",
                                -- projectile = "destroyer-unit-capsule",
                                -- starting_speed = 0.3
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
        order = "f[destroyer-unit-capsule]",
        stack_size = 100,
    }
})