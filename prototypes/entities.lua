local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")
local animations = require("animations")
local simulations = require("__base__/prototypes/factoriopedia-simulations")

local smoke_animations = require("__base__/prototypes/entity/smoke-animations")
local smoke_fast_animation = smoke_animations.trivial_smoke_fast
local trivial_smoke = smoke_animations.trivial_smoke

local simulations =
{
    sentry_unit =
    {
        init =
        [[
            game.simulation.camera_position = {0, -1}
            game.surfaces[1].create_entity{name = "sentry-unit", position = {0,0}}
        ]]
    },
    defender_unit =
    {
        init =
        [[
            game.simulation.camera_position = {0, -1}
            game.surfaces[1].create_entity{name = "destroyer-unit", position = {0,0}}
        ]]
    },

    destroyer_unit =
    {
        init =
        [[
            game.simulation.camera_position = {0, -1}
            game.surfaces[1].create_entity{name = "destroyer-unit", position = {0,0}}
        ]]
    }
}

local equipment_category = 
{
    type = "equipment-category",
    name = "combat-unit-category",
}

local smoke_test = 
{
    type = "trivial-smoke",
    name = "smoke-test",
    render_layer = "smoke",
    animation =
    {
        filename = "__core__/graphics/empty.png",
        frame_count = 1,
        animation_speed = 1,
        repeat_count = 1,
        size = 1,
        scale = 1,
    },
    duration = 1,
    cyclic = true,
}

local spider_leg = 
{
    type = "spider-leg",
    name = "combat-leg",
    icon = "__base__/graphics/icons/defender.png",
    icon_size = 64, 
    flags = {"placeable-player", "placeable-enemy", "player-creation", "placeable-off-grid", "breaths-air", "not-blueprintable"},
    selectable_in_game = false,
    -- graphics_set = 
    -- {
    --     joint_turn_offset = 0,
    --     joint_render_layer = "zero",

    -- },
   
    graphics_set = nil,
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
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
    },
    is_military_target = true,
    hidden = true,
    alert_when_damaged = false,
    allow_copy_paste = false,
    created_smoke = { 
        type = "create-trivial-smoke", 
        smoke_name = "smoke-test",
        repeat_count = 1,
        animation_speed = 1,
        offset_deviation = {{-0.2, -0.2}, {0.2, 0.2}},
        speed_from_center = 0.03
    },
    friendly_map_color = {0, 0, 0, 0},
    enemy_map_color = {0, 0, 0, 0},
}

local defender_unit = 
{
    type = "spider-vehicle",
    name = "defender-unit",
    icon = "__base__/graphics/icons/defender.png",
    icon_size = 64, 
    icon_mipmaps = 4,
    flags = { "placeable-neutral", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "defender-unit-capsule"},
    placeable_by = {{item = "defender-unit-capsule", count = 1},{item = "defender-unit", count = 1}},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
    },
    trigger_target_mask = { "flying-robot"},
    subgroup = "capsule",
    order = "e-b-a",

    max_health = 80,
    height = 1, 
    weight = 1,
    energy_source = {type = "void"},
    inventory_size = 0,
    chunk_exploration_radius = 2,
    movement_energy_consumption = "1kW",
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,
    guns = { "defender-unit-gun" },
    allow_copy_paste = false,
    automatic_weapon_cycling = false, 
    chain_shooting_cooldown_modifier = 0.5,
    alert_when_damaged = true,
    allow_passengers = false,
    create_ghost_on_death  = false,
    torso_rotation_speed = 0.05,
    graphics_set = animations.defender_unit,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    drawing_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    -- friendly_map_color = {0, 128, 0, 1},
    -- map_color = {0, 128, 0, 1},
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
                leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger(),
            }
        },
    },

    dying_explosion = "defender-robot-explosion",
    corpse = "defender-remnants",
    allow_remote_driving = false,
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
    created_smoke = { 
        type = "create-trivial-smoke", 
        smoke_name = "smoke-test",
        repeat_count = 1,
        animation_speed = 1,
        offset_deviation = {{-0.2, -0.2}, {0.2, 0.2}},
        speed_from_center = 0.03
    },
}

defender_unit.graphics_set.render_layer = "air-entity-info-icon"
defender_unit.graphics_set.base_render_layer = "air-object"
defender_unit.graphics_set.autopilot_path_visualisation_line_width = 0.0
defender_unit.graphics_set.autopilot_path_visualisation_on_map_line_width = 1 / 100000
defender_unit.graphics_set.autopilot_destination_visualisation_render_layer = "zero"
defender_unit.graphics_set.autopilot_destination_visualisation = util.empty_sprite()
defender_unit.graphics_set.autopilot_destination_queue_on_map_visualisation = util.empty_sprite()
defender_unit.graphics_set.autopilot_destination_on_map_visualisation = util.empty_sprite()

local sentry_unit =
{
    type = "spider-unit",
    name = "sentry-unit",
    icon = "__base__/graphics/icons/distractor.png",
    icon_size = 64,

    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "sentry-unit-capsule", count = 1},
    mined_sound = sounds.deconstruct_small(0.8),
    placeable_by = {{item = "sentry-unit-capsule", count = 1},{item = "sentry-unit", count = 1}},
    subgroup = "capsule",
    order = "e-b-b",
    factoriopedia_simulation = simulations.sentry_unit,
    factoriopedia_description = {"factoriopedia-description.sentry-unit"},

    max_health = 180,
    height = 1,
    vision_distance = 45,
    radar_range = 1,
    create_ghost_on_death = false,
    alert_when_damaged = true,
    absorptions_to_join_attack = {},
    distraction_cooldown = 10,
    min_pursue_time = 10 * 60,
    max_pursue_distance = 50,
    -- friendly_map_color = {0, 100, 0},
    -- enemy_map_color = {100, 0, 0},
    
    graphics_set = animations.sentry_unit,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    trigger_target_mask = { "flying-robot"},
    dying_explosion = "distractor-robot-explosion",
    torso_rotation_speed = 0.05,
    distance_per_frame = 0.1,
    water_reflection = robot_reflection(1.2),
    damaged_trigger_effect = hit_effects.flying_robot(),
    is_military_target = true,
    collision_mask =
    {
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
    },
    ai_settings =
    {
        do_seperation = false,
        strafe_settings =
        {
            max_distance = 20,
            ideal_distance = 15,
            ideal_distance_tolerance = 2.5,
            ideal_distance_variance = 1,
            ideal_distance_importance = 0.25,
            ideal_distance_importance_variance = 0.1,
            face_target = true
        }
    },
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
        range_mode = "center-to-bounding-box",
        sound = make_laser_sounds(),
        ammo_type =
        {
            action =
            {
                type = "direct",
                action_delivery =
                {
                    type = "beam",
                    beam = "laser-beam",
                    max_length = 15,
                    duration = 20,
                }
            }
        }
    },
    repairing_sound = sound_variations("__base__/sound/robot-repair", 6, 0.6),
    created_smoke = { 
        type = "create-trivial-smoke", 
        smoke_name = "smoke-test",
        repeat_count = 1,
        animation_speed = 1,
        offset_deviation = {{-0.2, -0.2}, {0.2, 0.2}},
        speed_from_center = 0.03
    },
    -- friendly_map_color = {0, 100, 0},
    -- enemy_map_color = {100, 0, 0},
}

local destroyer_unit = 
{
    type = "spider-vehicle",
    name = "destroyer-unit",
    icon = "__base__/graphics/icons/destroyer.png",
    icon_size = 64, 
    icon_mipmaps = 4,
    flags = {"placeable-player", "player-creation", "placeable-off-grid"},
    minable = {mining_time = 0.5, result = "destroyer-unit-capsule"},
    placeable_by = {{item="destroyer-unit-capsule", count = 1}, {item="destroyer-unit", count = 1}},
    subgroup = "capsule",
    order = "e-b-c",
    factoriopedia_simulation = simulations.factoriopedia_distractor,
    allow_remote_driving = false,
    max_health = 80,
    height = 1, 
    weight = 1,
    create_ghost_on_death  = false,
    energy_source = {type = "void"},
    inventory_size = 0,
    chunk_exploration_radius = 2,
    movement_energy_consumption = "20kW",
    braking_force = 1,
    friction_force = 1,
    energy_per_hit_point = 1,
    guns = { "destroyer-unit-gun"},

    automatic_weapon_cycling = false, 
    chain_shooting_cooldown_modifier = 0.5,
    alert_when_damaged = true,
    allow_passengers = false,

    torso_rotation_speed = 0.05,
    graphics_set = animations.destroyer_unit,
    collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
    sticker_box = {{-0.1, -0.1}, {0.1, 0.1}},
    collision_mask = {
        layers = {},
        not_colliding_with_itself = true,
      },
    trigger_target_mask = { "flying-robot"},
    allow_copy_paste = false,
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
    },

    dying_explosion = "destroyer-robot-explosion",
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
    created_smoke = 
    { 
        type = "create-trivial-smoke", 
        smoke_name = "smoke-test",
        repeat_count = 1,
        animation_speed = 1,
        offset_deviation = {{-0.2, -0.2}, {0.2, 0.2}},
        speed_from_center = 0.03
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
-- destroyer_unit.graphics_set.autopilot_destination_visualisation_render_layer = "zero"
destroyer_unit.graphics_set.autopilot_path_visualisation_on_map_line_width = 1 / 100000
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
    smoke_test,
    equipment_category,
    spider_leg,
    defender_unit,
    sentry_unit,
    destroyer_unit,
    speed_sticker,
})

