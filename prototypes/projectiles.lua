local capsule_smoke =
{
  {
    name = "smoke-fast",
    deviation = {0.15, 0.15},
    frequency = 1,
    position = {0, 0},
    starting_frame = 3,
    starting_frame_deviation = 5,
    starting_frame_speed_deviation = 5
  }
}

data:extend({
    {
        type = "projectile",
        name = "destroyer-unit-capsule",
        flags = { "not-on-map" },
        acceleration = 0.005,
        action = {
            type = "direct",
            action_delivery = 
            {
                type = "instant", 
                target_effects = 
                {
                    type = "create-entity",
                    entity_name = "destroyer-unit",
                    show_in_tooltips = true,
                    trigger_created_entity = "true"
                }
            }
        },
        light = { intensity = 0.5, size = 4 },
        enable_drawing_with_mask = true,
        animation =
        {
            layers =
            {
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/destroyer-capsule.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 42,
                    height = 34,
                    priority = "high"
                },
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/destroyer-capsule-mask.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 42,
                    height = 34,
                    priority = "high",
                    apply_runtime_tint = true
                }
            }
        },
        shadow =
        {
            filename = "__base__/graphics/entity/combat-robot-capsule/destroyer-capsule-shadow.png",
            flags = { "no-crop" },
            frame_count = 1,
            width = 48,
            height = 32,
            priority = "high"
        },
        smoke = capsule_smoke
    },
    {
        type = "projectile",
        name = "defender-unit-capsule",
        flags = { "not-on-map" },
        acceleration = 0.005,
        action = {
            type = "direct",
            action_delivery = 
            {
                type = "instant",
                target_effects = 
                {
                    type = "create-entity",
                    entity_name = "defender-unit",
                    show_in_tooltips = true,
                    trigger_created_entity = true,
                }
            }
        },
        light = { intensity = 0.5, size = 4 },
        enable_drawing_with_mask = true,
        animation =
        {
            layers =
            {
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/defender-capsule.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 28,
                    height = 20,
                    priority = "high"
                },
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/defender-capsule-mask.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 28,
                    height = 20,
                    priority = "high",
                    apply_runtime_tint = true
                }
            }
        },
        shadow =
        {
            filename = "__base__/graphics/entity/combat-robot-capsule/defender-capsule-shadow.png",
            flags = { "no-crop" },
            frame_count = 1,
            width = 26,
            height = 20,
            priority = "high"
        },
        smoke = capsule_smoke
    },
    {
        type = "projectile", 
        name = "sentry-unit-capsule",
        flags = { "not-on-map" },
        acceleration = 0.005,
        action = 
        {
            type = "direct",
            action_delivery = 
            {
                type = "instant",
                target_effects = 
                {
                    {
                        type = "create-entity",
                        entity_name = "sentry-unit",
                        show_in_tooltips = true,
                        trigger_created_entity = true
                    }
                }
            }
        },
        light = {intensity = 0.5, size = 4},
        enable_drawing_with_mask = true,
        animation =
        {
            layers =
            {
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/distractor-capsule.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 36,
                    height = 30,
                    priority = "high"
                },
                {
                    filename = "__base__/graphics/entity/combat-robot-capsule/distractor-capsule-mask.png",
                    flags = { "no-crop" },
                    frame_count = 1,
                    width = 36,
                    height = 30,
                    priority = "high",
                    apply_runtime_tint = true
                }
            }
        },
        shadow =
        {
            filename = "__base__/graphics/entity/combat-robot-capsule/distractor-capsule-shadow.png",
            flags = { "no-crop" },
            frame_count = 1,
            width = 40,
            height = 26,
            priority = "high"
        },
        smoke = capsule_smoke
    },
})