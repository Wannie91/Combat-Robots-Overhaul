data.raw.recipe["destroyer-capsule"].enabled = false
data.raw.recipe["distractor-capsule"].enabled = false
data.raw.recipe["defender-capsule"].enabled = false

data.raw.capsule["destroyer-capsule"].enabled = false
data.raw.capsule["defender-capsule"].enabled = false
data.raw.capsule["distractor-capsule"].enabled = false

data.raw["combat-robot"]["destroyer"].enabled = false
data.raw["combat-robot"]["defender"].enabled = false
data.raw["combat-robot"]["distractor"].enabled = false

data.raw["technology"]["combat-robotics"].effects = { { type = "unlock-recipe", recipe = "destroyer-unit" },
													  { type = "unlock-recipe", recipe = "defender-unit" },
													  { type = "unlock-recipe", recipe = "sentry-unit" },
													  { type = "maximum-following-robots-count", modifier = 4 } 
													}

data.raw["technology"]["combat-robotics-2"].enabled = false
data.raw["technology"]["combat-robotics-3"].enabled = false