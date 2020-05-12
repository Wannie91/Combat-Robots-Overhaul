local hit_effects = require("__base__/prototypes/entity/demo-hit-effects")
local sounds = require("__base__/prototypes/entity/demo-sounds")

require("util")

local animations = {}

animations.destroyer_unit = 
{
	idle = 
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot.png",
		priority = "high",
		line_length = 32,
		width = 45,
		height = 39,
		y = 39,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(2.5, -1.25),
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot.png",
			priority = "high",
			line_length = 32,
			width = 88,
			height = 77,
			y = 77,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(2.5, -1.25),
			scale = 0.5
		}
	},
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot-mask.png",
		priority = "high",
		line_length = 32,
		width = 27,
		height = 21,
		y = 21,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(2.5, -7),
		apply_runtime_tint = true,
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot-mask.png",
			priority = "high",
			line_length = 32,
			width = 52,
			height = 42,
			y = 42,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(2.5, -7),
			apply_runtime_tint = true,
			scale = 0.5
		}
	},
	shadow_idle = 
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot-shadow.png",
		priority = "high",
		line_length = 32,
		width = 55,
		height = 34,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(23.5, 19),
		draw_as_shadow = true,
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot-shadow.png",
			priority = "high",
			line_length = 32,
			width = 108,
			height = 66,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(23.5, 19),
			scale = 0.5,
			draw_as_shadow = true
		},
	},
	in_motion = 
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot.png",
		priority = "high",
		line_length = 32,
		width = 45,
		height = 39,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(2.5, -1.25),
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot.png",
			priority = "high",
			line_length = 32,
			width = 88,
			height = 77,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(2.5, -1.25),
			scale = 0.5
		}
	},
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot-mask.png",
		priority = "high",
		line_length = 32,
		width = 27,
		height = 21,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(2.5, -7),
		apply_runtime_tint = true,
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot-mask.png",
			priority = "high",
			line_length = 32,
			width = 52,
			height = 42,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(2.5, -7),
			apply_runtime_tint = true,
			scale = 0.5
		}
	},
	shadow_in_motion =
	{
		filename = "__base__/graphics/entity/destroyer-robot/destroyer-robot-shadow.png",
		priority = "high",
		line_length = 32,
		width = 55,
		height = 34,
		frame_count = 1,
		direction_count = 32,
		shift = util.by_pixel(23.5, 19),
		draw_as_shadow = true,
		hr_version =
		{
			filename = "__base__/graphics/entity/destroyer-robot/hr-destroyer-robot-shadow.png",
			priority = "high",
			line_length = 32,
			width = 108,
			height = 66,
			frame_count = 1,
			direction_count = 32,
			shift = util.by_pixel(23.5, 19),
			scale = 0.5,
			draw_as_shadow = true
		}
	}
}

animations.defender_unit = 
{
	idle = 
	{
		filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
		priority = "high",
		line_length = 16,
		width = 32,
		height = 33,
		frame_count = 1,
		direction_count = 16,
		shift = util.by_pixel(0, 0.25),
		hr_version =
        {
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot.png",
			priority = "high",
			line_length = 16,
			width = 56,
			height = 59,
			frame_count = 1,
			direction_count = 16,
			shift = util.by_pixel(0, 0.25),
			scale = 0.5
        }
    },
    {
		filename = "__base__/graphics/entity/defender-robot/defender-robot-mask.png",
		priority = "high",
		line_length = 16,
		width = 18,
		height = 16,
		frame_count = 1,
		direction_count = 16,
		shift = util.by_pixel(0, -4.75),
		apply_runtime_tint = true,
		hr_version =
        {
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot-mask.png",
			priority = "high",
			line_length = 16,
			width = 28,
			height = 21,
			frame_count = 1,
			direction_count = 16,
			shift = util.by_pixel(0, -4.75),
			apply_runtime_tint = true,
			scale = 0.5
        }
	},
	shadow_idle = 
	{
		filename = "__base__/graphics/entity/defender-robot/defender-robot-shadow.png",
		priority = "high",
		line_length = 16,
		width = 45,
		height = 26,
		frame_count = 1,
		direction_count = 16,
		shift = util.by_pixel(25.5, 19),
		draw_as_shadow = true,
		hr_version =
		{
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot-shadow.png",
			priority = "high",
			line_length = 16,
			width = 88,
			height = 50,
			frame_count = 1,
			direction_count = 16,
			shift = util.by_pixel(25.5, 19),
			scale = 0.5,
			draw_as_shadow = true
		}
	},	
	in_motion = 
	{
		filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
		priority = "high",
		line_length = 16,
		width = 32,
		height = 33,
		frame_count = 1,
		animation_speed = 1,
		direction_count = 16,
		shift = util.by_pixel(0, 0.25),
		y = 33,
		hr_version =
		{
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot.png",
			priority = "high",
			line_length = 16,
			width = 56,
			height = 59,
			frame_count = 1,
			animation_speed = 1,
			direction_count = 16,
			shift = util.by_pixel(0, 0.25),
			y = 59,
			scale = 0.5
		}
	},
	{
		filename = "__base__/graphics/entity/defender-robot/defender-robot-mask.png",
		priority = "high",
		line_length = 16,
		width = 18,
		height = 16,
		frame_count = 1,
		animation_speed = 1,
		direction_count = 16,
		shift = util.by_pixel(0, -4.75),
		apply_runtime_tint = true,
		y = 16,
		hr_version =
		{
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot-mask.png",
			priority = "high",
			line_length = 16,
			width = 28,
			height = 21,
			frame_count = 1,
			animation_speed = 1,
			direction_count = 16,
			shift = util.by_pixel(0, -4.75),
			apply_runtime_tint = true,
			y = 21,
			scale = 0.5
		}
	},
	shadow_in_motion = 
	{
        filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
        priority = "high",
        line_length = 16,
        width = 32,
        height = 33,
        frame_count = 1,
        animation_speed = 1,
        direction_count = 16,
        shift = util.by_pixel(0, 0.25),
        y = 33,
        hr_version =
        {
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot.png",
			priority = "high",
			line_length = 16,
			width = 56,
			height = 59,
			frame_count = 1,
			animation_speed = 1,
			direction_count = 16,
			shift = util.by_pixel(0, 0.25),
			y = 59,
			scale = 0.5
        }
    },
    {
        filename = "__base__/graphics/entity/defender-robot/defender-robot-mask.png",
        priority = "high",
        line_length = 16,
        width = 18,
        height = 16,
        frame_count = 1,
        animation_speed = 1,
        direction_count = 16,
        shift = util.by_pixel(0, -4.75),
        apply_runtime_tint = true,
        y = 16,
        hr_version =
        {
			filename = "__base__/graphics/entity/defender-robot/hr-defender-robot-mask.png",
			priority = "high",
			line_length = 16,
			width = 28,
			height = 21,
			frame_count = 1,
			animation_speed = 1,
			direction_count = 16,
			shift = util.by_pixel(0, -4.75),
			apply_runtime_tint = true,
			y = 21,
			scale = 0.5
        }
    }
}

animations.sentry_unit = 
{
    idle =
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot.png",
        priority = "high",
        line_length = 16,
        width = 38,
        height = 33,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(0, -2.5),
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot.png",
            priority = "high",
            line_length = 16,
            width = 72,
            height = 62,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(0, -2.5),
            scale = 0.5
        }
    },
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot-mask.png",
        priority = "high",
        line_length = 16,
        width = 24,
        height = 21,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(0, -6.25),
        apply_runtime_tint = true,
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot-mask.png",
            priority = "high",
            line_length = 16,
            width = 42,
            height = 37,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(0, -6.25),
            apply_runtime_tint = true,
            scale = 0.5
        }
    },
    shadow_idle =
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 49,
        height = 30,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(32.5, 19),
        draw_as_shadow = true,
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot-shadow.png",
            priority = "high",
            line_length = 16,
            width = 96,
            height = 59,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(32.5, 19.25),
            scale = 0.5,
            draw_as_shadow = true
        }
    },
    in_motion = 
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot.png",
        priority = "high",
        line_length = 16,
        width = 38,
        height = 33,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(0, -2.5),
        y = 33,
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot.png",
            priority = "high",
            line_length = 16,
            width = 72,
            height = 62,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(0, -2.5),
            y = 62,
            scale = 0.5
        }
    },
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot-mask.png",
        priority = "high",
        line_length = 16,
        width = 24,
        height = 21,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(0, -6.25),
        apply_runtime_tint = true,
        y = 21,
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot-mask.png",
            priority = "high",
            line_length = 16,
            width = 42,
            height = 37,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(0, -6.25),
            apply_runtime_tint = true,
            y = 37,
            scale = 0.5
        }
    },
    shadow_in_motion = 
    {
        filename = "__base__/graphics/entity/distractor-robot/distractor-robot-shadow.png",
        priority = "high",
        line_length = 16,
        width = 49,
        height = 30,
        frame_count = 1,
        direction_count = 16,
        shift = util.by_pixel(32.5, 19),
        draw_as_shadow = true,
        hr_version =
        {
            filename = "__base__/graphics/entity/distractor-robot/hr-distractor-robot-shadow.png",
            priority = "high",
            line_length = 16,
            width = 96,
            height = 59,
            frame_count = 1,
            direction_count = 16,
            shift = util.by_pixel(32.5, 19.25),
            scale = 0.5,
            draw_as_shadow = true
        }
    }
}

--data:extend({	

local combatRobots = 
{
    {
		type = "unit",
		name = "destroyer-unit",
		icon = "__base__/graphics/icons/destroyer.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = { "placeable-player", "player-creation", "placeable-off-grid", "not-repairable" },
		minable = { mining_time = 0.5 },
		placeable_by = { item = "destroyer-unit-capsule", count = 1 },
		resistance =
		{
			{
				type = "fire",
				percent = 95,
			},
			{
				type = "acid",
				percent = 90,
			}
		},

		subgroup = "capsule",
		order = "e-a-c",
		max_health = 60,
		alert_when_damaged = false,
		collision_box = { {0, 0}, {0, 0} },
		selection_box = { {-0.5, -0.5}, {0.5, 0.5} },	
		hit_visualization_box = { {-0.1, -1.4}, {0.1, -1.3} },
		damaged_trigger_effect = hit_effects.flying_robot(),
		collision_mask = {"layer-14"},			
		dying_explosion = "destroyer-robot-explosion",
		vision_distance = 45,
		distance_per_frame = 0.15,
		pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        friendly_map_color = {0, 0, 1},
        radar_range = 1,
		working_sound = {
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
			entity_name = "defender-robot-explosion"
		},		
		attack_parameters =
		{
			type = "beam",
			ammo_category = "combat-robot-beam",
			cooldown = 20,
			cooldown_deviation = 0.2,
			range = 15,
			sound = make_laser_sounds(),
			ammo_type =
			{
				category = "combat-robot-beam",
				action =
				{
					type = "direct",
					action_delivery =
					{
						type = "beam",
						beam = "electric-beam",
						max_length = 20,
						duration = 20,
						source_offset = {0.15, -0.5}
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

		movement_speed = 0.1,
		distance_per_frame = 0.1,
		min_pursue_time = 10 * 60,
		max_pursue_distance = 50,
		run_animation = 
		{
			layers = 
			{ 
				animations.destroyer_unit.in_motion,
				animations.destroyer_unit.shadow_in_motion
			}
		},
		water_reflection = robot_reflection(1.2),

	},    
    {
		type = "unit",
		name = "defender-unit",
		icon = "__base__/graphics/icons/defender.png",
		icon_size = 64,
		icon_mipmaps = 4,
		flags = { "placeable-player", "player-creation", "placeable-off-grid", "not-repairable" },
		minable = { mining_time = 0.5 },
		placeable_by  = { item = "defender-unit-capsule", count = 1 },
		resistance = 
		{
			{
				type = "fire",
				percent = 95,
			},
			{
				type = "acid",
				decrease = 0,
				percent = 80
			}
		},
		subgroup = "capsule",
		order ="e-a-a",
		max_health = 60,
		vision_distance = 15,
		alert_when_damaged = false,
		collision_box = {{0, 0}, {0, 0}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		hit_visualization_box = { {-0.1, -1.1}, {0.1, -1.0} },
		damaged_trigger_effect = hit_effects.flying_robot(),
		dying_explosion = "defender-robot-explosion",
		pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        friendly_map_color = {0, 0, 1},
        radar_range = 1,
		collision_mask = {"layer-14"},
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
			entity_name = "defender-robot-explosion"
		},
		attack_parameters = 
		{
			type = "projectile",
			cooldown = 20,
			cooldown_deviation = 0.2,
			projectile_center = {0, 1},
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
								damage = { amount = 8, type = "physical" }
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
		movement_speed = 0.4,
		distance_per_frame = 0.125,
		min_pursue_time = 10 * 60,
		max_pursue_distance = 50,
		run_animation = 
		{
			layers = 
			{ 
				animations.defender_unit.in_motion,
				animations.defender_unit.shadow_in_motion
			}
		},
		water_reflection = robot_reflection(1.2),
	},
    {
        type = "unit",
        name = "sentry-unit",
        icon = "__base__/graphics/icons/distractor.png",
        icon_size = 64,
        icon_mipmaps = 4,
        flags = { "placeable-player", "player-creation", "placeable-off-grid", "not-repairable" },
		minable = { mining_time = 0.5 },
		placeable_by = { item = "sentry-unit-capsule", count = 1},
        resistance = 
        {
            {
                type = "fire",
                percent = 95
            },
            {
                type = "acid",
                decrease = 0,
                percent = 85
            }
        },
        subgroup = "capsule",
        order = "e-a-b", 
        max_health = 90,
        alert_when_damaged = true,
        collision_box = {{0, 0}, {0, 0}},
        selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
        hit_visualization_box = {{-0.1, -1.1}, {0.1, -1.0}},
        damaged_trigger_effect = hit_effects.flying_robot(),
        dying_explosion = "distractor-robot-explosion",
        vision_distance = 12,
		distance_per_frame = 0.15,
		pollution_to_join_attack = 0,
        distraction_cooldown = 300,
        friendly_map_color = {0, 0, 1},
        radar_range = 1,
        collision_mask = {"layer-14"},
        working_sound = {
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
		attack_parameters =
		{
		  	type = "projectile",
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
			cooldown = 6,
			projectile_creation_distance = 1.39375,
			projectile_center = {0, -0.0875}, -- same as gun_turret_attack shift
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
			range = 12,
			sound = sounds.gun_turret_gunshot,
			animation = {
                layers = 
                {
                    animations.sentry_unit.idle,
                    animations.sentry_unit.shadow_idle
                }
            }
		},
        movement_speed = 0.2,
		distance_per_frame = 0.1,
		min_pursue_time = 10 * 60,
		max_pursue_distance = 50,
		run_animation = 
		{
			layers = 
			{ 
				animations.sentry_unit.in_motion,
				animations.sentry_unit.shadow_in_motion
			}
		},
		water_reflection = robot_reflection(1.2),
    },

}
--})
data:extend(combatRobots)

local shadow_shift = {-0.75, -0.40}
local animation_shift = {0, 0}

local adjust_animation = function(animation)

  local animation = util.copy(animation)
  local layers = animation.layers or {animation}

  for k, layer in pairs (layers) do

    layer.frame_count = layer.direction_count
    layer.direction_count = 0
    layer.animation_speed = 1
    layer.shift = util.add_shift(layer.shift, animation_shift)

    if layer.hr_version then
      layer.hr_version.frame_count = layer.hr_version.direction_count
      layer.hr_version.direction_count = 0
      layer.hr_version.animation_speed = 1
      layer.hr_version.shift = util.add_shift(layer.hr_version.shift, animation_shift)
    end

  end

  return animation
end

local adjust_shadow = function(shadow_animation)

  local shadow_animation = util.copy(shadow_animation)
  local layers = shadow_animation.layers or {shadow_animation}

  for k, layer in pairs (layers) do

    layer.frame_count = layer.direction_count
    layer.direction_count = 0
    layer.animation_speed = 1
    layer.shift = util.add_shift(layer.shift, shadow_shift)

    if layer.hr_version then
      layer.hr_version.frame_count = layer.hr_version.direction_count
      layer.hr_version.direction_count = 0
      layer.hr_version.animation_speed = 1
      layer.hr_version.shift = util.add_shift(layer.hr_version.shift, shadow_shift)
    end

  end

  return shadow_animation
end

local reversed = function(animation)
  local animation = util.copy(animation)
  local layers = animation.layers or {animation}

  for k, layer in pairs (layers) do
    layer.run_mode = "backward"
    if layer.hr_version then
      layer.hr_version.run_mode = "backward"
    end
  end

  return animation
end

local make_robot_particle = function(prototype)

  local particle_name = prototype.name.."-dying-particle"

  local animation = adjust_animation(prototype.run_animation)
  local shadow_animation = adjust_shadow(prototype.run_animation)
  local unit_name = prototype.name:gsub( "-unit", "")

  if unit_name:find("sentry") then
	unit_name = unit_name:gsub( "sentry", "distractor")
  end

  local particle =
  {
    type = "optimized-particle",
    name = particle_name,
    pictures = {animation, reversed(animation)},
    shadows = {shadow_animation, reversed(shadow_animation)},
    movement_modifier = 0.95,
    life_time = 1000,
    regular_trigger_effect_frequency = 2,
    regular_trigger_effect =
    {
      {
        type = "create-trivial-smoke",
        smoke_name = "smoke-fast",
        starting_frame_deviation = 5,
        probability = 0.5
      },
      {
        type = "create-particle",
        particle_name = "spark-particle",
        tail_length = 10,
        tail_length_deviation = 5,
        tail_width = 5,
        probability = 0.2,
        initial_height = 0.2,
        initial_vertical_speed = 0.15,
        initial_vertical_speed_deviation = 0.05,
        speed_from_center = 0.1,
        speed_from_center_deviation = 0.05,
        offset_deviation = {{-0.25, -0.25},{0.25, 0.25}}
      }
    },
    ended_on_ground_trigger_effect =
    {
      {
      type = "create-entity",
      entity_name = unit_name.."-remnants",
      offsets = {{0, 0}}
      },
      {
        type = "play-sound",
        sound = sounds.robot_die_impact,
      },
    }
  }

  data:extend{particle}

  prototype.dying_trigger_effect =
  {
    {
      type = "create-particle",
      particle_name = particle_name,
      initial_height = 1.8,
      initial_vertical_speed = 0,
      frame_speed = 1,
      frame_speed_deviation = 0.5,
      speed_from_center = 0,
      speed_from_center_deviation = 0.2,
      offset_deviation = {{-0.01, -0.01},{0.01, 0.01}},
      offsets = {{0, 0.5}}
    },
    {
      type = "play-sound",
      sound = sounds.robot_die_whoosh,
    }, 
    {
      type = "play-sound",
      sound = sounds.robot_die_vox,
    },
  }
  
  prototype.destroy_action =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects = 
      {
        {
          type = "create-particle",
          particle_name = particle_name,
          initial_height = 1.8,
          initial_vertical_speed = 0,
          frame_speed = 0.5,
          frame_speed_deviation = 0.5,
          speed_from_center = 0,
          speed_from_center_deviation = 0.1,
          offset_deviation = {{-0.01, -0.01},{0.01, 0.01}},
          offsets = {{0, 0.5}}
        },
        {
          type = "play-sound",
          sound = sounds.robot_die_whoosh,
        },
        {
          type = "play-sound",
          sound = sounds.robot_die_vox,
        },
        {
          type = "play-sound",
          sound = sounds.robot_selfdestruct,
        },    
      }
    }
  }

end

for k, combatRobot in pairs (combatRobots) do
  make_robot_particle(combatRobot)
end
