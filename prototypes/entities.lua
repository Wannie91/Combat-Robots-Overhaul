local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")

-- data:extend({
local combatRobots = 
{
    {   
        type = "unit",
        name = "defender-unit",
        icon = "__base__/graphics/icons/defender.png",
        icon_size = 64, icon_mipmaps = 4,
        flags = { "placeable-player", "player-creation", "placeable-off-grid" },
        minable = { mining_time = 0.5 },
        placeable_by = { item = "defender-unit-capsule", count = 1 },   
        subgroup = "capsule",
        order = "e-b-a",

        max_health = 80,
        vision_distance = 30,
        radar_range = 1,
        movement_speed = 0.3,

        has_belt_immunity = true,
        alert_when_damaged = false,
        pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        min_pursue_time = 10 * 60,
        max_pursue_distance = 50,
        ai_settings = { do_separation = false },

		collision_box = { {0, 0}, {0, 0} },
		selection_box = { {-0.5, -0.5}, {0.5, 0.5} },
		hit_visualization_box = { {-0.1, -1.1}, {0.1, -1.0} },
        friendly_map_color = { 0, 128, 0},
        collision_mask = { "layer-14" },
        dying_explosion = "defender-robot-explosion",
        distance_per_frame = 0.125,
        water_reflection = robot_reflection(1.2),
        damaged_trigger_effect = hit_effects.flying_robot(),

        resistance = 
        {
            { 
                type = "fire",
                percent = 95
            },
            {
                type = "acid",
                percent = 80
            }
        },

        attack_parameters = 
        {
            type = "projectile", 
            cooldown = 20,
            cooldown_deviation = 0.2,
            projectile_center = { 0,1 },
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
                            entity_name = "explosion-gunshot-small"
                        },
                        target_effects = 
                        {
                            {
                                type = "create-entity",
                                entity_name = "explosion-hit"
                            },
                            {
                                type = "damage",
                                damage = { amount = 9, type = "physical" }
                            }
                        }
                    } 
                }
            },
            animation = 
            {
                layers = 
                {
                    animations.defender_unit.idle,
                    animations.defender_unit.shadow_idle
                }
            }
        },

        working_sound = 
        {
            sound = 
            {
                filename = "__base__/sound/fight/defender-robot-loop.ogg",
                volume = 0.7
            },
            apparent_volume = 1,
            persistent = true
        },

        dying_trigger_effect = 
        {
            type = "create-entity",
            entity_name = "defender-robot-explosion",
        },
        
        run_animation = 
        {
            layers = 
            {
                animations.defender_unit.in_motion,
                animations.defender_unit.shadow_in_motion
            }
        },
    },
    {   
        type = "unit",
        name = "sentry-unit",
        icon = "__base__/graphics/icons/distractor.png",
        icon_size = 64, icon_mipmaps = 4,
        flags = { "placeable-player", "player-creation", "placeable-off-grid" },
        minable = { mining_time = 0.5, result = "sentry-unit" },
        placeable_by = { item = "sentry-unit-capsule", count = 1 },   
        subgroup = "capsule",
        order = "e-b-b",

        max_health = 100,
        vision_distance = 30,
        radar_range = 1,
        movement_speed = 0.2,

        has_belt_immunity = true,
        alert_when_damaged = true,
        pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        min_pursue_time = 10 * 60,
        max_pursue_distance = 50,
        -- ai_settings = { do_separation = false },

        collision_box = { {0, 0}, {0, 0} },
        selection_box = { {-0.5, -0.5}, {0.5, 0.5}} ,
        hit_visualization_box = { {-0.1, -1.1}, {0.1, -1.0} },
        friendly_map_color = { 0, 128, 0},
        collision_mask = { "layer-14" },
        dying_explosion = "distractor-robot-explosion",
        distance_per_frame = 0.1,
        water_reflection = robot_reflection(1.2),
        damaged_trigger_effect = hit_effects.flying_robot(),

        resistance = 
        {
            { 
                type = "fire",
                percent = 95
            },
            {
                type = "acid",
                decrease = 6,
                percent = 60,
            }
        },

        attack_parameters = 
        {
            type = "projectile",
            cooldown = 10,
            projectile_creation_distance = 1.39375,
            projectile_center = { 0, -0.0875},
            range = 12,
            sound = sounds.submachine_gunshot,

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
                            entity_name = "explosion-gunshot-small"
                        },
                        target_effects = 
                        {
                            {
                                type = "create-entity",
                                entity_name = "explosion-hit"
                            },
                            {
                                type = "damage",
                                damage = { amount = 8, type = "physical" }
                            }
                        }
                    } 
                }
            },

            shell_particle =
			{
				name = "shell-particle",
				direction_deviation = 0.1,
				speed = 0.1,
				speed_deviation = 0.03,
				center = {-0.0625, 0},
				creation_distance = -1.925,
				starting_frame_speed = 0.2,
				starting_frame_speed_deviation = 0.1
            },

            animation = 
            {
                layers = 
                {
                    animations.sentry_unit.idle,
                    animations.sentry_unit.shadow_idle
                }
            }
        },

        working_sound = 
        {
            sound = 
            {
                filename = "__base__/sound/fight/distractor-robot-loop.ogg",
                volume = 0.7
            },
            apparent_volume = 1,
            persistent = true
        },

        dying_trigger_effect = 
        {
            type = "create-entity",
            entity_name = "distractor-robot-explosion",
        },
        
        run_animation = 
        {
            layers = 
            {
                animations.sentry_unit.in_motion,
                animations.sentry_unit.shadow_in_motion
            }
        },
    },
    {   
        type = "unit",
        name = "destroyer-unit",
        icon = "__base__/graphics/icons/destroyer.png",
        icon_size = 64, icon_mipmaps = 4,
        flags = { "placeable-player", "player-creation", "placeable-off-grid" },
        minable = { mining_time = 0.5 },
        placeable_by = { item = "destroyer-unit-capsule", count = 1 },   
        subgroup = "capsule",
        order = "e-b-c",

        max_health = 60,
        vision_distance = 30,
        radar_range = 1,
        movement_speed = 0.2,

        has_belt_immunity = true,
        alert_when_damaged = false,
        pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        min_pursue_time = 10 * 60,
        max_pursue_distance = 50,
        ai_settings = { do_separation = false },

        collision_box = { {0, 0}, { 0, 0} },
        selection_box = { {-0.5, -0.5}, {0.5, 0.5} },
        hit_visualization_box =  { {-0.1, -1.4}, {0.1, -1.3} },
        friendly_map_color = { 0, 128, 0},
        collision_mask = { "layer-14" },
        dying_explosion = "destroyer-robot-explosion",
        distance_per_frame = 0.15,
        water_reflection = robot_reflection(1.2),
        damaged_trigger_effect = hit_effects.flying_robot(),

        resistance = 
        {
            {
                type = "acid",
                decrease = 6,
                percent = 90,
            },
            {
                type = "physical",
                decrease = 4,
            }
        },

        attack_parameters = 
        {
            type = "beam",
            ammo_category = "beam",
            cooldown = 20,
            cooldown_deviation = 0.2,
            range = 15,
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
                        max_length = 15,
                        duration = 20,
                        source_offset = { 0.15, -0.5 }
                    }
                }
            },
            animation = 
            {
                layers = 
                {
                    animations.destroyer_unit.idle,
                    animations.destroyer_unit.shadow_idle
                }
            }
        },

        working_sound = 
        {
            sound = 
            {
                filename = "__base__/sound/fight/destroyer-robot-loop.ogg",
                volume = 0.7
            },
            apparent_volume = 1,
            persistent = true
        },

        dying_trigger_effect = 
        {
            type = "create-entity",
            entity_name = "destroyer-robot-explosion",
        },
        
        run_animation = 
        {
            layers = 
            {
                animations.destroyer_unit.in_motion,
                animations.destroyer_unit.shadow_in_motion
            }
        },
    },
}

data:extend(combatRobots)

for _, combatRobot in pairs(combatRobots) do 
    animations.make_robot_particle(combatRobot)
end