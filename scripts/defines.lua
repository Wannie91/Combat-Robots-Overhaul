local modDefines = {}

modDefines.capsules = {
    defender = "defender-unit-capsule",
    sentry = "sentry-unit-capsule",
    destroyer = "destroyer-unit-capsule",
}

modDefines.units = {
    defender = "defender-unit",
    sentry = "sentry-unit",
    destroyer = "destroyer-unit",
}

modDefines.associations = {
    [modDefines.capsules.defender] = modDefines.units.defender,
    [modDefines.capsules.sentry] = modDefines.units.sentry,
    [modDefines.capsules.destroyer] = modDefines.units.destroyer,
}

modDefines.eventFilters = {
    {
        filter = "name",
        name = modDefines.units.defender,
    },
    {
        filter = "name",
        name = modDefines.units.sentry,
    },
    {
        filter = "name",
        name = modDefines.units.destroyer,
    },
}

return modDefines
