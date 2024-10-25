local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")
local simulations = require("__base__.prototypes.factoriopedia-simulations")

local equipment_category = 
{
    type = "equipment-category",
    name = "combat-unit-category",
}

local spider_leg = 
{
    type = "spider-leg",
    name = "combat-leg",
    selectable_in_game = false,
    graphics_set = create_spidertron_leg_graphics_set(0,1),
    initial_movement_speed = 100,
    minimal_step_size = 0,
    movement_acceleration = 100,
    movement_based_position_selection_distance = 3,
    base_position_selection_distance = 1,
    knee_distance_factor = 1,
    knee_height = 0,
    hip_flexibility = 0,
    stretch_force_scalar = 1,
    part_length = 100000000,
    target_position_randomisation_distance = 0,
    walking_sound_volume_modifier = 0,
    working_sound = nil,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}}, 
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
      },
    
}

local defender_unit = 
{
    type = "spider-vehicle",
    name = "defender-unit",
    icon = "__base__/graphics/icons/defender.png",
    -- icon_size = 64, 
    -- icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "defender-unit-capsule"},
    placeable_by = {item = "defender-unit-capsule", count = 1},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
      },
    subgroup = "capsule",
    order = "e-b-a",
    factoriopedia_simulation = simulations.factoriopedia_defender,

    max_health = 80,
    height = 1, 
    weight = 1,
    energy_source = {type = "void"},
    equipment_grid = "combat-unit-equipment-grid",
    inventory_size = 0,
    chunk_exploration_radius = 2,
    movement_energy_consumption = "1kW",
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,
    -- guns = { "defender-unit-gun" },

    automatic_weapon_cycling = false, 
    chain_shooting_cooldown_modifier = 0.5,
    alert_when_damaged = false,
    allow_passengers = false,


    torso_rotation_speed = 0.05,
    graphics_set = animations.defender_unit,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    friendly_map_color = {0, 128, 0, 1},
    map_color = {0, 128, 0, 1},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},

    spider_engine = 
    {
        legs = 
        {
            {
                leg = "combat-leg",
                mount_position = {0, -1},
                ground_position = {0, -1},
                blocking_legs = {1},
                walking_group = 1,
                leg_hit_the_ground_trigger = nil,
            }
        },
        military_target = "spidertron-military-target",
    },

    dying_explosion = "defender-robot-explosion",
    -- corpse = "defender-remnants",
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),
    is_military_target = true,
    resistances = 
    {
        {
            type = "fire", 
            decrease = 0,
            percent = 95,
        },
        {
            type = "acid",
            decrease = 0,
            percent = 80,
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

    minimap_representation = 
    {
        filename = "__CombatRobotsOverhaul__/graphics/icons/defender-icon.png",
        flags = {"icon"},
        size = {60,79},
        scale = 0.15,
        tint = {1, 1, 1, 1},
    },
    
    sound_minimum_speed = 0.1,
    sound_scaling_ratio = 0.1,
}

defender_unit.graphics_set.render_layer = "air-entity-info-icon"
defender_unit.graphics_set.base_render_layer = "air-object"
defender_unit.graphics_set.autopilot_path_visualisation_line_width = 0
defender_unit.graphics_set.autopilot_path_visualisation_on_map_line_width = 0
defender_unit.graphics_set.autopilot_destination_visualisation = util.empty_sprite()
defender_unit.graphics_set.autopilot_destination_queue_on_map_visualisation = util.empty_sprite()
defender_unit.graphics_set.autopilot_destination_on_map_visualisation = util.empty_sprite()

local sentry_unit = 
{
    type = "unit",
    name = "sentry-unit",
    icon = "__base__/graphics/icons/distractor.png",
    -- icon_size = 64, icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = { mining_time = 0.5, result = "sentry-unit-capsule"},
    placeable_by = {item = "sentry-unit-capsule", count = 1},
    subgroup = "capsule",
    order = "e-b-b",
    factoriopedia_simulation = simulations.factoriopedia_distractor,
    
    max_health = 180, 
    vision_distance = 45,
    radar_range = 1,
    movement_speed = 0.2,

    
    has_belt_immunity = true,
    alert_when_damaged = true,
    absorptions_to_join_attack = { },
    distraction_cooldown = 300,
    min_pursue_time = 10 * 60,
    max_pursue_distance = 50,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    friendly_map_color = {0, 100, 0},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
      },
    dying_explosion = "distractor-robot-explosion",
    distance_per_frame = 0.1,
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),

    resistances = 
    {
        {
            type = "fire",
            decrease = 0,
            percent = 95
        },
        {
            type = "acid",
            decrease = 0,
            percent = 85
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
                type = "direct",
                action_delivery = 
                {
                    type = "beam",
                    beam = "laser-beam",
                    max_length = 20,
                    duration = 10,
                }
            } 
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
    type = "spider-vehicle",
    name = "destroyer-unit",
    icon = "__base__/graphics/icons/destroyer.png",
    -- icon_size = 64, 
    -- icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "destroyer-unit-capsule"},
    placeable_by = {item = "destroyer-unit-capsule", count = 1},
    subgroup = "capsule",
    order = "e-b-a",
    factoriopedia_simulation = simulations.factoriopedia_destroyer,

    max_health = 80,
    height = 1, 
    weight = 1,
    energy_source = {type = "void"},
    equipment_grid = "combat-unit-equipment-grid",
    inventory_size = 0,
    chunk_exploration_radius = 2,
    movement_energy_consumption = "20kW",
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,

    automatic_weapon_cycling = false, 
    chain_shooting_cooldown_modifier = 0.5,
    alert_when_damaged = false,
    allow_passengers = false,


    torso_rotation_speed = 0.05,
    graphics_set = animations.destroyer_unit,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    friendly_map_color = {0, 200, 0},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
      },
    
    spider_engine = 
    {
        legs = 
        {
            {
                leg = "combat-leg",
                mount_position = {0,0},
                ground_position = {0,0},
                blocking_legs = {1},
                walking_group = 1,
                leg_hit_the_ground_trigger = nil,
            }
        },
        military_target = "spidertron-military-target",
    },

    dying_explosion = "destroyer-robot-explosion",
    -- corpse = "destroyer-remnants",
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),
    is_military_target = true,
    
    resistances = 
    {
        {
            type = "fire", 
            decrease = 0,
            percent = 95,
        },
        {
            type = "acid",
            decrease = 0,
            percent = 90,
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

    minimap_representation = 
    {
        filename = "__CombatRobotsOverhaul__/graphics/icons/destroyer-icon.png",
        flags = {"icon"},
        size = {70,76},
        scale = 0.15,
        tint = {1, 1, 1, 1},
    },
    
    sound_minimum_speed = 0.1,
    sound_scaling_ratio = 0.1,
    
}

destroyer_unit.graphics_set.render_layer = "air-entity-info-icon"
destroyer_unit.graphics_set.base_render_layer = "air-object"
destroyer_unit.graphics_set.autopilot_path_visualisation_line_width = 0
destroyer_unit.graphics_set.autopilot_path_visualisation_on_map_line_width = 0
destroyer_unit.graphics_set.autopilot_destination_visualisation = util.empty_sprite()
destroyer_unit.graphics_set.autopilot_destination_queue_on_map_visualisation = util.empty_sprite()
destroyer_unit.graphics_set.autopilot_destination_on_map_visualisation = util.empty_sprite()

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

