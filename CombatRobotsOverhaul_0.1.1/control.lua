local util = require("util/util")
local modDefines = require("util/defines")

local combatUnitTemplate = {
    player = true,
    unitType = true,
    members = 0,
    surface = true, 
    unitGroup = true,
    readyForAction = false,
    createdTick = 0,
}

local data = {
    combatUnits = {},
    attackList = {},
    defendList = {},
    waitList = {},
    defenceExcludeList = {},
}

local function getCombatUnit(player, unitType)
    
    for _, combatUnit in pairs(data.combatUnits) do 
        if combatUnit.player == player and combatUnit.unitType == unitType then 
            return combatUnit
        end
    end

    return nil

end

local function init()

    global.combatRobotsOverhaulData = global.combatRobotsOverhaulData or data 

    if game.forces["player"].technologies["defender"].researched then 
        game.forces["player"].recipes["defender-unit"].enabled = true
        game.forces["player"].recipes["sentry-unit"].enabled = true
        game.forces["player"].recipes["destroyer-unit"].enabled = true
    end

    util.createDefenceExcludeList(data.defenceExcludeList)

end

local function load()

    data = global.combatRobotsOverhaulData or data 
    global.combatRobotsOverhaulData = data

end

local function modSettingsChanged(event)

    if event.setting ~= "exclude-list" then return end

    createDefenceExcludeList(data.defenceExcludeList)

end

local function playerJoined()

end

local function toggleDefenderFollow(event)

    if event.prototype_name ~= "toggle-defender" and event.input_name ~= "keyboard-toggle-defender" then  return end
    
    local player = game.players[event.player_index]

    if player.is_shortcut_toggled("toggle-defender") then     
        player.set_shortcut_toggled("toggle-defender", false)
    else
        player.set_shortcut_toggled("toggle-defender", true)
    end

    end

local function checkAreaForEnemyBases(event)

    for _, entity in pairs(game.surfaces[event.surface_index].find_entities_filtered({ area = event.area, force = "enemy", type = { "unit-spawner", "turret" }})) do 
        if not util.tableContainsValue(data.attackList, entity.unit_number) and entity.active then 
            data.attackList[entity.unit_number] = entity
            script.register_on_entity_destroyed(entity)
        end
    end

end

local function entityDestroyed(event)

    if util.tableContainsValue(data.attackList, event.unit_number) then
        data.attackList[event.unit_number] = nil
    end

end

local function playerUsedCapsule(event)

    local item = event.item 

    if item.name == modDefines.capsules.defender or modDefines.capsules.sentry or modDefines.capsules.destroyer then 

        local player = game.players[event.player_index]
        local unitType = modDefines.associations[item.name]
        local combatUnit = getCombatUnit(player, unitType)

        if not combatUnit or combatUnit.members < game.forces.player.maximum_following_robot_count then
            if player.character then 
                player.surface.create_entity{ name = item.name, player = player, position = player.position, target = event.position, force = player.force, source = player.character, speed = 0.3, max_range = 25 }
            else
                player.surface.create_entity{ name = unitType, player = player, position = event.position, force = player.force, raise_built = true }
            end
        else
            player.create_local_flying_text{ text = { "messages.max_type_reached", unitType}, create_at_cursor = true }
            player.insert{ name = item.name, count = 1 }
        end
    end

end

local function createCombatUnit(player, entity) 

    local newCombatUnit = util.shallowcopy(combatUnitTemplate)

    newCombatUnit.player = player
    newCombatUnit.unitType = entity.name
    newCombatUnit.surface = entity.surface
    newCombatUnit.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity.force })

    local group_number = newCombatUnit.unitGroup.group_number
    table.insert(data.combatUnits, group_number, newCombatUnit)

    return data.combatUnits[group_number]
    
end

local function allowNewGroupMembers(combatUnit) 

    local state = combatUnit.unitGroup.state 

    if state == defines.group_state.gathering or state == defines.group_state.finished then 
        return true
    elseif state == defines.group_state.moving then 

        -- if defender group is moving (defending base) do not add unit 
        if combatUnit.unitType == modDefines.units.defender and not combatUnit.player.is_shortcut_toggled("toggle-defender") and combatUnit.unitGroup.command and combatUnit.unitGroup.command.type == defines.command.attack_area then 
            return false
        else
            -- combatUnit.unitGroup.set_command({ type = defines.command.stop, distraction = defines.distraction.by_enemy })
            combatUnit.unitGroup.set_command({ type = defines.command.wander, radius = 10, distraction = defines.distraction.by_enemy })
            return true
        end

    elseif state == defines.group_state.attacking_distraction or state == defines.group_state.attacking_target then 
        return false
    elseif combatUnit.unitGroup.command and combatUnit.unitGroup.command.type == defines.command.wander then 
        return true
    end

end

local function addMemberToUnitGroup(entity, combatUnit)

    combatUnit.unitGroup.add_member(entity) 
    combatUnit.members = combatUnit.members + 1
    combatUnit.readyForAction = false
    combatUnit.createdTick = game.tick

end

local function createdEntity(event)

    local entity = event.entity
    local player = game.players[entity.last_user.index]
    local combatUnit = getCombatUnit(player, entity.name)

    if not combatUnit then 
        combatUnit = createCombatUnit(player, entity)
    end

    if entity.name == modDefines.units.sentry then 
        combatUnit.members = combatUnit.members + 1
    elseif allowNewGroupMembers(combatUnit) then 
        addMemberToUnitGroup(entity, combatUnit)
    else
        data.waitList[entity.unit_number] = { combatUnit = combatUnit, entity = entity }
        entity.set_command({ type = defines.command.wander, radius = 25, ticks_to_wait  = 360, distraction = defines.distraction.by_anything })
    end

end

local function removeCombatRobotFromGroup(event)

    if event.unit.name ~= modDefines.units.defender and event.unit.name ~= modDefines.units.destroyer then return end

    local group_number = event.group.group_number
    local combatUnit = data.combatUnits[group_number]

    combatUnit.members = combatUnit.members - 1

    if combatUnit.members == 0 then 

        if combatUnit.unitType == modDefines.units.defender then 
            combatUnit.player.set_shortcut_available("toggle-defender", false)
        end

        combatUnit.player.print({ "messages.unitgroup-destroyed", combatUnit.unitType, string.format("[gps= %d, %d]", combatUnit.unitGroup.position.x, combatUnit.unitGroup.position.y )})
        data.combatUnits[group_number] = nil 
    
    end

end

local function entityDied(event)

    local combatUnit = getCombatUnit(event.entity.last_user, event.entity.name)

    if combatUnit then 
        combatUnit.members = combatUnit.members - 1 
    end

end

local function finishedGathering(event)

    if event.group.force.name ~= "player" then return end

    for _, combatUnit in pairs(data.combatUnits) do 
        if combatUnit.unitGroup == event.group and combatUnit.unitGroup.valid and not combatUnit.readyForAction then 
            combatUnit.readyForAction = true 
        end
    end

end

local function commandCompleted(event)

    if event.was_distracted or event.result ~= defines.behavior_result.success then return end

    if util.tableContainsValue(data.waitList, event.unit_number) then 

       local combatUnit, entity = data.waitList[event.unit_number].combatUnit, data.waitList[event.unit_number].entity

        if combatUnit and combatUnit.unitGroup.valid then 

            if allowNewGroupMembers(combatUnit) then 
                addMemberToUnitGroup(entity, combatUnit)
                data.waitList[event.unit_number] = nil 
            else
                entity.set_command({ type = defines.command.wander, radius = 5, ticks_to_wait = 360, distraction = defines.distraction.by_anything })
            end
        else
            combatUnit = createCombatUnit(game.players[entity.last_user], entity)
            addMemberToUnit(entity, combatUnit)
        end
    
    elseif util.tableContainsValue(data.combatUnits, event.unit_number) then 

    end

end

local function updateDefenderFollower(player, unitGroup)

    local defender_distance = settings.get_player_settings(player.index)["defender-distance"].value 

    unitGroup.set_command({ type = defines.command.go_to_location, destination_entity = player.character or nil, destination = (not player.character and player.position) or nil, radius = defender_distance - 8, distraction = defines.distraction.by_anything, pathfind_flags = modDefines.pathfinding_flags })

    --adjust robot speed to match player inside or out a vehicle
    for _, member in pairs(unitGroup.members) do 
        if player.driving then 
            member.speed = player.vehicle.speed + 0.1
        elseif player.character then
            member.speed = player.character.character_running_speed + 0.2 
        end
    end

    -- unitGroup.start_moving()

end

local function defendBase(event)

    if event.force.name == "enemy" and not event.entity.name == "player" then 

        for _, combatUnit in pairs(data.combatUnits) do 

            if combatUnit.unitType == modDefines.units.defender and not combatUnit.player.is_shortcut_toggled("toggle-defender") and combatUnit.readyForAction then

                local unitGroup = combatUnit.unitGroup
                local targetDistance = util.getDistance(event.entity.position, unitGroup.position)

                if targetDistance <= settings.global["base-defender-radius"].value then
                    
                    if unitGroup.command and unitGroup.command.type == defines.command.attack_area and not unitGroup.distraction_command then           
                        if util.samePosition(unitGroup.command.destination, event.entity.position) then 
                            return 
                        elseif targetDistance > util.getDistance(unitGroup.command.destination, unitGroup.position) then 
                            return 
                        end
                    end

                    unitGroup.set_command({ type = defines.command.attack_area, destination = event.entity.position, radius = 50, distraction = defines.distraction.by_anything })   
                end
            end
        end
    end
    
end

local function handleDestroyerUnit(unitGroup)

    if next(data.attackList) then
        
        if ( not unitGroup.command or unitGroup.command.type ~= defines.command.attack_area ) and not unitGroup.distraction_command then 

            local targetEntity = unitGroup.surface.get_closest(unitGroup.position, data.attackList) 

            if targetEntity and targetEntity.valid then 
                unitGroup.set_command({ type = defines.command.attack_area, destination = targetEntity.position, radius = 30, distraction = defines.distraction.by_enemy })
            end
        end
    elseif not unitGroup.command or unitGroup.command.type == 9 then
        unitGroup.set_command({ type = defines.command.wander, radius = 50, distraction = defines.distraction.by_enemy})
    end

end

local function onTick(event)

    for _, combatUnit in pairs (data.combatUnits) do 
        if combatUnit.unitType == modDefines.units.defender and combatUnit.readyForAction then
            if combatUnit.player.is_shortcut_toggled("toggle-defender") then
                updateDefenderFollower(combatUnit.player, combatUnit.unitGroup)
            elseif not combatUnit.unitGroup.command then 
                combatUnit.unitGroup.set_command({ type = defines.command.wander, radius = 15, distraction = defines.distraction_by_anything })
            end
        elseif combatUnit.unitType == modDefines.units.destroyer and combatUnit.readyForAction then 
            local waitTick = combatUnit.createdTick + ( settings.global["time-before-attack"].value * 60 )

            if game.tick > waitTick and combatUnit.unitGroup.valid then 
                handleDestroyerUnit(combatUnit.unitGroup)
            end
        end
    end

end

script.on_init(init)
script.on_load(load)

script.on_event(defines.events.on_runtime_mod_setting_changed, modSettingsChanged)
script.on_event(defines.events.on_player_joined_game, playerJoined)

script.on_event({defines.events.on_lua_shortcut, "keyboard-toggle-defender"}, toggleDefenderFollow)

script.on_event(defines.events.on_chunk_charted, checkAreaForEnemyBases)
script.on_event(defines.events.on_entity_destroyed, entityDestroyed)

script.on_event(defines.events.on_player_used_capsule, playerUsedCapsule)
script.on_event(defines.events.script_raised_built, createdEntity, {{ filter = "name", name = modDefines.units.defender }, { filter = "name", name = modDefines.units.sentry }, { filter = "name", name = modDefines.units.destroyer }})
script.on_event(defines.events.on_trigger_created_entity, createdEntity)
script.on_event(defines.events.on_unit_removed_from_group, removeCombatRobotFromGroup)
script.on_event(defines.events.on_entity_died, entityDied, { { filter = "name", name = modDefines.units.sentry } })

script.on_event(defines.events.on_unit_group_finished_gathering, finishedGathering)
script.on_event(defines.events.on_ai_command_completed, commandCompleted)

script.on_event(defines.events.on_entity_damaged, defendBase)

script.on_nth_tick(60, onTick)