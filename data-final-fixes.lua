if not settings.startup['enable-vanilla-combatrobots'].value then

    data.raw["capsule"]["destroyer-capsule"].flags = {"hidden"}
    data.raw["capsule"]["distractor-capsule"].flags = {"hidden"}
    data.raw["capsule"]["defender-capsule"].flags = {"hidden"}

    data.raw.recipe["destroyer-capsule"].enabled = false
    data.raw.recipe["distractor-capsule"].enabled = false
    data.raw.recipe["defender-capsule"].enabled = false

    data.raw["technology"]["combat-robotics-2"].enabled = false
    data.raw["technology"]["combat-robotics-3"].enabled = false

    data.raw["technology"]["combat-robotics"].effects[1] = nil
    data.raw["technology"]["combat-robotics-2"].effects[1] = nil
    data.raw["technology"]["combat-robotics-3"].effects[1] = nil

end

