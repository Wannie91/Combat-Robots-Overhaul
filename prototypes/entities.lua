local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")

local equipment_category = 
{
    type = "equipment-category",
    name = "defender-unit-category",
}

local spider_leg = 
{
    type = "spider-leg",
    name = "defender-leg",
    selectable_in_game = false,
    graphics_set = create_spidertron_leg_graphics_set(0,1),
    initial_movement_speed = 100,
    minimal_step_size = 0,
    movement_acceleration = 100,
    movement_based_position_selection_distance = 3,
    part_length = 100000000,
    target_position_randomisation_distance = 0,
    walking_sound_volume_modifier = 0,
    working_sound = nil,
}

local defender_unit = 
{
    type = "spider-vehicle",
    name = "defender-unit",
    icon = "__base__/graphics/icons/defender.png",
    icon_size = 64, 
    icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "defender-unit-capsule"},
    placeable_by = {item = "defender-unit-capsule", count = 1},
    subgroup = "capsule",
    order = "e-b-a",

    max_health = 80,
    height = 1, 
    weight = 1,
    energy_source = {type = "void"},
    equipment_grid = "defender-unit-equipment-grid",
    inventory_size = 0,
    chunk_exploration_radius = 2,
    movement_energy_consumption = "1KW",
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,

    automatic_weapon_cycling = false, 
    chain_shooting_cooldown_modifier = 0.5,
    alert_when_damaged = false,
    allow_passengers = false,

    torso_rotation_speed = 0.05,
    graphics_set = animations.defender_unit,
    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    friendly_map_color = {0, 128, 0},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    collision_mask = {"layer-19"},
    render_layer = "air-object",

    spider_engine = 
    {
        legs = 
        {
            {
                leg = "defender-leg",
                mount_position = {0,0},
                ground_position = {0,0},
                blocking_legs = {1},
                leg_hit_the_ground_trigger = nil,
            }
        },
        military_target = "spidertron-military-target",
    },

    dying_explosion = "defender-robot-explosion",
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),

    resistance = 
    {
        {
            type = "fire", 
            decrease = 0,
            percent = 95,
        },
        {
            type = "acid",
            decrease = 0,
            percent = 95,
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
        persistent = true,
    },
    
    sound_minimum_speed = 0.1,
    sound_scaling_ratio = 0.1,
}

local sentry_unit = 
{
    type = "unit",
    name = "sentry-unit",
    icon = "__base__/graphics/icons/distractor.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = { mining_time = 0.5, result = "sentry-unit-capsule"},
    placeable_by = {item = "sentry-unit-capsule", count = 1},
    subgroup = "capsule",
    order = "e-b-b",

    max_health = 100, 
    vision_distance = 45,
    radar_range = 1,
    movement_speed = 0.2,

    has_belt_immunity = true,
    alert_when_damaged = true,
    pollution_to_join_attack = 0,
    distraction_cooldown = 300,
    min_pursue_time = 10 * 60,
    max_pursue_distance = 50,

    collision_box = {{0, 0}, {0, 0}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    friendly_map_color = {0, 100, 0},
    collision_mask = {"layer-19"},
    dying_explosion = "distractor-robot-explosion",
    distance_per_frame = 0.1,
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),

    resistance = 
    {
        {
            type = "fire",
            decrease = 0,
            percent = 95
        },
        {
            type = "acid",
            decrease = 0,
            percent = 95
        }
    },

    attack_parameters = 
    {
        type = "beam",
        ammo_category = "laser",
        cooldown = 40,
        cooldown_deviation = 0.2,
        damage_modifier = 0.5,
        range = 15,
        sound = make_laser_sounds(),
        ammo_type = 
        {
            category = "laser",
            action =
            {
                {
                    type = "direct",
                    action_delivery = 
                    {
                        type = "beam",
                        beam = "laser-beam",
                        max_length = 15,
                        duration = 10,
                    }
                }
            } 
        },
        animation = 
        {
            layers = 
            {
                animations.sentry_unit_idle,
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
        entity_name = "distractor-robot-explosion"
    },

    run_animation = 
    {
        layers = 
        {
            animations.sentry_unit.in_motion,
            animations.sentry_unit.shadow_in_motion
        }
    },
}

local destroyer_unit = 
{
    type = "unit",
    name = "destroyer-unit",
    icon = "__base__/graphics/icons/destroyer.png",
    icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = { mining_time = 0.5, result = "destroyer-unit-capsule"},
    placeable_by = {item = "destroyer-unit-capsule", count = 1},
    subgroup = "capsule",
    order = "e-b-c",

    max_health = 120,
    vision_distance = 45,
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
    collision_mask = { "layer-19" },
    dying_explosion = "destroyer-robot-explosion",
    distance_per_frame = 0.15,
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),

    resistance = 
    {
        {
            type = "fire",
            decrease = 0,
            percent = 95
        },
        {
            type = "acid",
            decrease = 0,
            percent = 95
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
}

local speed_sticker = 
{
    type = "sticker",
    name = "speed-sticker",
    flags = {"not-on-map"},
    animation = util.empty_sprite(),
    duration_in_ticks = 100,
    target_movement_modifier_from = 1,
    target_movement_modifier_to = 1,
    vehicle_speed_modifier_from = 10,
    vehicle_speed_modifier_to = 1,
    vehicle_friction_modifier_from = 1,
    vehicle_friction_modifier_to = 1, 
}

animations.make_robot_particle(defender_unit)
animations.make_robot_particle(sentry_unit)
animations.make_robot_particle(destroyer_unit)

data:extend({
    equipment_category,
    spider_leg,
    defender_unit,
    sentry_unit,
    destroyer_unit,
    speed_sticker,
})

