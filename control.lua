require("util/util")

local modDefines = require("util/modDefines")

local combatUnitGroupTemplate = {
	playerID,
	unitGroup,
	surface,
	memberCount = 0,
	readyForAction = false
}

local function resetUnitGroup(event)

	if event.parameter == modDefines.units.destroyer or event.parameter == modDefines.units.defender or event.parameter == modDefines.units.sentry then 

		local player = game.players[event.player_index]
		local removedEntities = 0

		if global.combatUnitGroups[player.index] and global.combatUnitGroups[player.index][event.parameter] then 

			local combatUnitGroup = global.combatUnitGroups[player.index][event.parameter]

			combatUnitGroup.unitGroup.destroy()

			for _, unit in pairs(game.surfaces[1].find_entities_filtered({ type = 'unit', name = parameter, force = player.force })) do
				if unit.last_user.index == player.index then 

					if combatUnitGroup.unitGroup.valid then 
						combatUnitGroup.unitGroup.add_member(unit)
					else
						combatUnitGroup.unitGroup = unit.surface.create_unit_group({ position = unit.position, force = unit.force })
						combatUnitGroup.unitGroup.add_member(unit)
					end
					--unit.destroy()
					--removedEntities = removedEntities + 1
				end
			end

--			player.print(string.format("Reseted %d Entities", removedEntities))

		end

	else
		player.print("Please enter a valid unit-type. (unit-types: destroyer-unit, defender-unit, sentry-unit)")
	end

end

local function resetAttackList(event)

	local player = game.players[event.player_index]

	for key, entity in pairs(global.attackList) do

		local removedEntities = 0

		if not entity.valid then
			global.attackList[key] = nil
			removedEntities = removedEntities + 1
		end
	end

	player.print(string.format("Removed %d Invalid Entities", removedEntities))

end

local function combatRobotOverhaul_init()

	if not global.combatUnitGroups then 
		global.combatUnitGroups = {}
	end

	if not global.attackList then 
		global.attackList = {}
	end

	if not global.defendList then 
		global.defendList = {}
	end

	if not global.excludeList then 
		createExcludeList()
	end

	if not global.waitList then 
		global.waitList = {}
	end

	for _, player in pairs(game.players) do 
		initCombatGroups(player.index)
	end

	-- enable tech if already researched
	for _, force in pairs(game.forces) do
		if force.technologies["combat-robotics"].researched then
			force.recipes["destroyer-unit"].enabled = true
			force.recipes["defender-unit"].enabled = true
			force.recipes["sentry-unit"].enabled = true
		end
	end

	--game.forces["player"].rechart()

end

local function combatRobotOverhaul_load(event)

	
end

local function configuration_changed(event)

	createExcludeList()

end

function initCombatGroups(player_index)

	if not global.combatUnitGroups[player_index] then
		global.combatUnitGroups[player_index] = {}
	end

	if not global.combatUnitGroups[player_index][modDefines.units.defender] or global.combatUnitGroups[player_index][modDefines.units.defender].memberCount == 0 then
		game.players[player_index].set_shortcut_available("toggle-defender", false)
	end

end

function createExcludeList()

	global.excludeList = {}

	for entry in string.gmatch(settings.global["defense_exclude_list"].value, "[^,]+") do
		global.excludeList[entry] = true
	end

end

local function toggleDefenderFollow(event)

	local player = game.players[event.player_index]

	if event.prototype_name == "toggle-defender" or event.input_name == "keyboard-toggle-defender" and player.is_shortcut_available("toggle-defender") then 

		if player.is_shortcut_toggled("toggle-defender") then
			player.set_shortcut_toggled("toggle-defender", false)
		else
			player.set_shortcut_toggled("toggle-defender", true)
		end

	end

end

local function checkAreaForEnemyBase(event)

	local enemyBaseComponents = { "unit-spawner", "turret" }

	for _, entity in pairs(game.surfaces[1].find_entities_filtered({ area = event.area, type = enemyBaseComponents, force = "enemy" })) do
		
		if not tableContainsValue(global.attackList, entity) and entity.active then 
			table.insert(global.attackList, entity.unit_number, entity)
		end
	
	end

end

local function entityDied(event)

	local entity = event.entity

	if entity.force.name == "enemy" then 
		
		if entity.type == "unit-spawner" or entity.type == "turret" then 
			removeValueFromTable(global.attackList, entity)
		else
			removeValueFromTable(global.defendList, entity)
		end

	elseif entity.name == modDefines.units.destroyer or entity.name == modDefines.units.defender or entity.name == modDefines.units.sentry then
		removeCombatRobotFromGroup(event)
	end

end

function removeCombatRobotFromGroup(event)

	local player = game.players[event.entity.last_user.index]
	local combatUnitGroup = global.combatUnitGroups[player.index][event.entity.name]

	if combatUnitGroup.unitGroup.valid then 
	
		local lastPosition = combatUnitGroup.unitGroup.position

		combatUnitGroup.memberCount = combatUnitGroup.memberCount - 1

		if combatUnitGroup.memberCount == 0 then

			if combatUnitGroup.unitType == modDefines.units.defender then 
				player.set_shortcut_available("toggle-defender", false)
			end

			combatUnitGroup.unitGroup.destroy()
			player.print({ "messages.unitgroup-destroyed", combatUnitGroup.unitType, string.format("[gps= %d, %d]", lastPosition.x, lastPosition.y)})
		
		end

	end

end

local function entityDamaged(event)

	if event.force.name == "enemy" and event.entity.has_flag("player-creation") and not global.excludeList[event.entity.name] and event.cause and event.cause.type == "unit" then
	
		if event.cause.valid and not tableContainsValue(global.defendList, event.cause) then
			table.insert(global.defendList, event.cause.unit_number, event.cause)
		end
	
	end

end

local function usedCapsule(event)

	local player = game.players[event.player_index]
	local item = event.item
	local unitType = modDefines.association[item.name]

	if item.name == modDefines.capsules.destroyer or item.name == modDefines.capsules.defender or item.name == modDefines.capsules.sentry then

		local memberCount = getUnitGroupMemberCount(player.index, unitType)

		if memberCount <= game.forces.player.maximum_following_robot_count then 

			if player.character then 
				player.surface.create_entity{ name = item.name, player = player, position = player.position, target = event.position, force = player.force, source = player.character, speed = 0.3, max_range = 25 }
			else
				player.surface.create_entity{ name = unitType, player = player, position = event.position, force = player.force, raise_built = true }
			end

		else
			player.create_local_flying_text{ text = { "messages.max_type_reached", unitType}, position = event.position }
			player.insert{ name = item.name, count = 1 }
		end
	
	end

end

function getUnitGroupMemberCount(player_index, unitType)

	if global.combatUnitGroups[player_index] and global.combatUnitGroups[player_index][unitType] then 
		return global.combatUnitGroups[player_index][unitType].memberCount
	else
		return 0
	end

end

local function raisedBuilt(event)

	local entity = event.entity
	local player = game.players[event.entity.last_user.index]

	createdCombatRobot(entity, player)

end

local function triggerCreatedEntity(event)

	local entity = event.entity
	local player = game.players[event.source.player.index]

	createdCombatRobot(entity, player)

end

function createdCombatRobot(entity, player)

	local playerUnitGroups = global.combatUnitGroups[player.index]

	if not playerUnitGroups[entity.name] or not playerUnitGroups[entity.name].unitGroup.valid then 
		playerUnitGroups[entity.name] = createCombatUnitGroup(entity, player)
	end

	addUnitToGroup(playerUnitGroups[entity.name], entity)

	if entity.name == modDefines.units.defender then
		player.set_shortcut_available("toggle-defender", true)
	end

end


function createCombatUnitGroup(entity, player)

	local newCombatUnit = shallowcopy(combatUnitGroupTemplate)

	newCombatUnit.playerID = player.index
	newCombatUnit.unitType = entity.name
	newCombatUnit.surface = entity.surface
	newCombatUnit.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity.force })

	return newCombatUnit

end

function addUnitToGroup(combatUnitGroup, entity)

	if entity.name == modDefines.units.destroyer and not combatUnitGroup.command then 
		combatUnitGroup.createdTick = game.tick
	end

	combatUnitGroup.memberCount = combatUnitGroup.memberCount + 1

	if entity.name == modDefines.units.sentry then
		entity.set_command({ type = defines.command.wander, radius = settings.global["sentry-radius"].value, distraction = defines.distraction.by_enemy })
	else
		combatUnitGroup.readyForAction = checkGroupState(combatUnitGroup.unitGroup, entity)
	end

end

function checkGroupState(unitGroup, entity)

	if unitGroup.state == defines.group_state.gathering or unitGroup.state == defines.group_state.finished then 
		unitGroup.add_member(entity)
		return false
	
	elseif unitGroup.state == defines.group_state.moving or unitGroup.command.type == defines.group_state.wander_in_group then

		if entity.name == modDefines.units.defender and unitGroup.state == defines.group_state.moving and unitGroup.command then 
			entity.set_command({ type = defines.command.wander, radius = 5, ticks_to_wait = 360 })
			table.insert(global.waitList, entity.unit_number, { unitGroup = unitGroup, entity = entity })

			return true 

		else 
			unitGroup.set_command({ type = defines.command.stop, distraction = defines.distraction.by_enemy})
			unitGroup.add_member(entity)

			return false

		end

	elseif unitGroup.state == defines.group_state.moving or unitGroup.state == defines.group_state.attacking_target then
		entity.set_command({ type = defines.command.wander, radius = 5, ticks_to_wait = 360 })
		table.insert(global.waitList, entity.unit_number, { unitGroup = unitGroup, entity = entity })

		return true
	end

end

local function finishedGathering(event)

	if event.group.force.name == "player" then 

		for _, player in pairs(game.players) do

			for _, unit in pairs(global.combatUnitGroups[player.index]) do 
				if unit.unitGroup.valid and unit.unitGroup.group_number == event.group.group_number then
					unit.readyForAction = true
				end
			end 

		end

	end

end

local function commandCompleted(event)

	if not event.was_distracted and event.result == defines.behavior_result.success and tableContainsValue(global.waitList, event.unit_number) then 

		local unitGroup, entity = global.waitList[event.unit_number].unitGroup, global.waitList[event.unit_number].entity

		if ( unitGroup.state == defines.group_state.attacking_target or unitGroup.state == defines.group_state.attacking_distraction ) or ( entity.name == modDefines.units.defender and unitGroup.state == defines.group_state.moving and unitGroup.command ) then 
			entity.set_command({ type = defines.command.wander, radius = 5, ticks_to_wait = 360 })
		else 
			unitGroup.set_command({ type = defines.command.stop, radius = 5, distraction = defines.distraction.by_enemy })
			unitGroup.add_member(entity)

			global.waitList[event.unit_number] = nil
		end

	end

end

local function handleUnitGroupsOnTick(event)

	for player, _ in pairs(global.combatUnitGroups) do 

		local destroyerGroup = global.combatUnitGroups[player][modDefines.units.destroyer]
		local defenderGroup = global.combatUnitGroups[player][modDefines.units.defender]
		local player = game.players[player]

		if destroyerGroup and destroyerGroup.unitGroup.valid and destroyerGroup.readyForAction  then 
			local waitTick = destroyerGroup.createdTick + ( settings.global["time-before-attack"].value * 60 )

			if game.tick > waitTick then 
				handleDestroyerUnit(destroyerGroup.unitGroup)
			end

		end

  		if defenderGroup and defenderGroup.unitGroup.valid and defenderGroup.readyForAction and not player.is_shortcut_toggled("toggle-defender") then 
			defendBase(defenderGroup.unitGroup, player)
		end
		

	end
	
end

function handleDestroyerUnit(unitGroup)

	if next(global.attackList) then 

		if not unitGroup.command or unitGroup.command.type ~= defines.command.attack_area then

			local targetEntity = unitGroup.surface.get_closest(unitGroup.position, global.attackList)

			if targetEntity and targetEntity.valid then 
				unitGroup.set_command({ type = defines.command.attack_area, destination = targetEntity.position, radius = 50, distraction = defines.distraction.by_enemy })
				unitGroup.start_moving()
				
			end
		end
	elseif not unitGroup.command or unitGroup.command.type ~= defines.command.wander then 
		unitGroup.set_command({ type = defines.command.wander, radius = 25, distraction = defines.distraction.by_enemy })
		unitGroup.start_moving()
	end

end

function defendBase(unitGroup, player)

	if next(global.defendList) then 

		if not unitGroup.command or unitGroup.command.type ~= defines.command.attack_area then 

			local targetEntity = unitGroup.surface.get_closest(unitGroup.position, global.defendList) 

			if targetEntity and targetEntity.valid then

				if getDistance(targetEntity.position, unitGroup.position) < settings.global["base-defender-radius"].value then 
					unitGroup.set_command({ type = defines.command.attack_area, destination = targetEntity.position, radius = 25, distraction = defines.distraction.by_enemy })
					unitGroup.start_moving()
				else
					player.print({ "messages.defender-too-far" })
				end

			end

		end

	elseif not unitGroup.command or unitGroup.command.type ~= defines.command.wander then 
		unitGroup.set_command({ type = defines.command.wander, radius = 10, distraction = defines.distraction.by_enemy })
		unitGroup.start_moving()
	end

end

local function updateFollowingDefenderUnits(event)

	local player = game.players[event.player_index]
	local defenderUnit = global.combatUnitGroups[player.index]["defender-unit"]
	
	local defender_distance = settings.get_player_settings(player.index)["defender-distance"].value 

	--TODO increase speed of unit depending on player speed

	if defenderUnit and defenderUnit.unitGroup.valid and player.is_shortcut_toggled("toggle-defender") then 
		
		if player.character then 
			defenderUnit.unitGroup.set_command({ type = defines.command.go_to_location, destination_entity = player.character, radius = defender_distance, distraction = defines.distraction.by_enemy, pathfind_flags = {allow_paths_through_own_entities = true, cache = false, no_break  = true, prefer_straight_paths = true} })
			defenderUnit.unitGroup.start_moving()
		else
			defenderUnit.unitGroup.set_command({ type = defines.command.go_to_location, destination = player.position, radius = defender_distance, distraction = defines.distraction.by_enemy, pathfind_flags = {allow_paths_through_own_entities = true, cache = false, no_break  = true, prefer_straight_paths = true} })
			defenderUnit.unitGroup.start_moving()
		end

	end

end



script.on_init(combatRobotOverhaul_init)
script.on_load(combatRobotOverhaul_load)

script.on_event(defines.events.on_runtime_mod_setting_changed, configuration_changed)
script.on_event({defines.events.on_player_joined_game, defines.events.on_player_created}, function(event) 
	initCombatGroups(event.player_index)
end)

script.on_event({defines.events.on_lua_shortcut, "keyboard-toggle-defender"}, toggleDefenderFollow)
script.on_event(defines.events.on_chunk_charted, checkAreaForEnemyBase)

script.on_event(defines.events.on_entity_died, entityDied)
script.on_event(defines.events.on_player_mined_entity, removeCombatRobotFromGroup, {{ filter = "name", name = modDefines.units.destroyer }, { filter = "name", name = modDefines.units.defender }, { filter = "name", name = modDefines.units.sentry }})
script.on_event(defines.events.on_entity_damaged, entityDamaged)

script.on_event(defines.events.on_player_used_capsule, usedCapsule)
script.on_event(defines.events.script_raised_built, raisedBuilt, {{ filter = "name", name = modDefines.units.destroyer }, { filter = "name", name = modDefines.units.defender }, { filter = "name", name = modDefines.units.sentry }})
script.on_event(defines.events.on_trigger_created_entity, triggerCreatedEntity)

script.on_event(defines.events.on_unit_added_to_group, unitAddedToGroup)
script.on_event(defines.events.on_unit_group_finished_gathering, finishedGathering)
--script.on_event(defines.events.on_unit_removed_from_group, unitRemovedFromGroup)
script.on_event(defines.events.on_ai_command_completed, commandCompleted)

script.on_event(defines.events.on_player_changed_position, updateFollowingDefenderUnits)
script.on_nth_tick(60, handleUnitGroupsOnTick) 

commands.add_command("resetUnitGroup", "Remove Units from UnitGroup", resetUnitGroup)
commands.add_command("resetAttackList", "Remove invalid Units from attackList", resetAttackList)

--script.on_event(defines.events.on_console_command, resetUnitGroup)