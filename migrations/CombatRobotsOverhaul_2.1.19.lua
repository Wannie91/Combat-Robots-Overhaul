for _, force in pairs(game.forces) do
    if not settings.startup["enable-vanilla-combatrobots"].value then
        force.recipes["defender-capsule"].enabled = false
        force.recipes["destroyer-capsule"].enabled = false
        force.recipes["distractor-capsule"].enabled = false
    end
end
