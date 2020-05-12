data:extend({
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
				cooldown = 30,
				projectile_creation_distance = 0.6,
				range = 25,
				ammo_type =
				{
					category = "capsule",
					target_type = "position",
					action =
					{
						type = "direct",
						action_delivery =
						{
							type = "projectile",
							projectile = "destroyer-unit-capsule",
							starting_speed = 0.3
						}
			  		}
				}
			 }
		},
		
		subgroup = "capsule",
		order = "f[destroyer-unit-capsule]",
		stack_size = 100
	},    
    {
        type = "capsule",
        name = "defender-unit-capsule",
        icon = "__base__/graphics/icons/defender.png",
        icon_size = 64,
        icon_mipmaps = 4,
    --[[ 		capsule_action =
        {
            type = "use-on-self",
            attack_parameters =
            {
                type = "projectile",
                ammo_category = "capsule",
                cooldown = 30,
                range = 0,
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
                                damage = { type = "physical", amount = 0}
                            }
                        }
                    }
                }
            }
        }, ]]
        
        capsule_action =
        {
            type = "throw",
            attack_parameters =
            {
                type = "projectile",
                ammo_category = "capsule",
                cooldown = 30,
                projectile_creation_distance = 0.6,
                range = 25,
                ammo_type =
                {
                    category = "capsule",
                    target_type = "position",
                    action =
                    {
                        type = "direct",
                        action_delivery =
                        {
                            type = "projectile",
                            projectile = "defender-unit-capsule",
                            starting_speed = 0.3
                        }
                    }
                }
            }
        },
        
        subgroup = "capsule",
        order = "f[defender-unit-capsule]",
        stack_size = 100
    },
    {
        type = "capsule",
		name = "sentry-unit-capsule",
		icon = "__base__/graphics/icons/distractor.png",
		icon_size = 64,
		icon_mipmaps = 4,
        capsule_action =
		{
		  	type = "throw",
		  	attack_parameters =
		  	{
				type = "projectile",
				ammo_category = "capsule",
				cooldown = 30,
				projectile_creation_distance = 0.6,
				range = 25,
				ammo_type =
				{
					category = "capsule",
					target_type = "position",
					action =
					{
						type = "direct",
						action_delivery =
						{
							type = "projectile",
							projectile = "sentry-unit-capsule",
							starting_speed = 0.3
						}
			  		}
				}
		 	}
        },
		subgroup = "capsule",
		order = "f[sentry-unit-capsule]",
		stack_size = 100
    }
})