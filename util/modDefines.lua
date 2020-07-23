local modDefines = {

	capsules = {
		destroyer = "destroyer-unit-capsule",
		defender = "defender-unit-capsule",
		sentry = "sentry-unit-capsule",
	},

	units = {
		destroyer = "destroyer-unit",
		defender = "defender-unit",
		sentry = "sentry-unit",
	},

	association = {
		["destroyer-unit-capsule"] = "destroyer-unit",
		["defender-unit-capsule"] = "defender-unit",
		["sentry-unit-capsule"] = "sentry-unit",
	},

	combatUnitGroupTemplate = {
		playerID,
		unitGroup,
		surface,
		memberCount,
		readyForAction
	},

}

return modDefines