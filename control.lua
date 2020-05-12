require("util/util")

local combatUnitGroupTemplate = { playerID = true, unitType = true, unitGroup = true, surface = true, memberCount = 0, currentCommand = 0 }

local excludeList = {
	["defender-unit"] = true,
	["sentry-unit"] = true,
	["destroyer-unit"] = true,
}

function combatRobotOverhaul_init()

	if not global.combatUnitGroups then
		global.combatUnitGroups = {}
	end

	if not global.attackList then 
		global.attackList = {}
	end

	if not global.killList then 
		global.killList = {}
	end

	if not global.lastCapsuleUser then
		global.lastCapsuleUser = ""
	end

	-- enable tech if already researched
	for _, force in pairs(game.forces) do
		if force.technologies["combat-robotics"].researched then
			force.recipes["destroyer-unit"].enabled = true
			force.recipes["defender-unit"].enabled = true
			force.recipes["sentry-unit"].enabled = true
		end
	end

	--create unitGroup for every player
	for _, player in pairs(game.players) do
		initUnitGroupForPlayer(player.index)
	end

end

function initUnitGroupForPlayer(player_index) 

	global.combatUnitGroups = global.combatUnitGroups or {}
	global.combatUnitGroups[player_index] = {}

end

function toogleDefenderFollow(event)

	local player = game.players[event.player_index]

	if player.is_shortcut_toggled("toggle-defender") then
		player.set_shortcut_toggled("toggle-defender", false)
	else
		player.set_shortcut_toggled("toggle-defender", true)
	end

end

function checkAreaForSpawner(event)

	if not global.attackList then 
		global.attackList = {}
	end

	for _, spawner in pairs(game.surfaces[1].find_entities_filtered({ area = event.area, type = 'unit-spawner', force = 'enemy' })) do
		if (tableContainsCoordinate(global.attackList, spawner.position) == false) and spawner.active then
			table.insert(global.attackList, spawner.position)
		end
	end
end

function usedCapsule(event)

	local player = game.players[event.player_index]
	local item = event.item
	local entities = game.surfaces[1].find_entities_filtered({ position = player.position, radius = 25, name = item.name })
	
	if item.name == "defender-unit-capsule" or item.name == "destroyer-unit-capsule" or item.name == "sentry-unit-capsule" then

		local combatRobot = item.name:gsub( "-capsule", "")
		if global.combatUnitGroups[player.index] ~= nil and global.combatUnitGroups[player.index][combatRobot] ~= nil then
			if global.combatUnitGroups[player.index][combatRobot].memberCount >= game.forces.player.maximum_following_robot_count then
				if entities then
					entities[1].destroy()
					player.insert{ name = item.name, count = 1 }
					player.create_local_flying_text{ text = {"capsule.error_msg", combatRobot}, position = event.position }
				end
			end
		end
	end

	global.lastCapsuleUser = player.index
end

function entityMined(event)

	global.combatUnitGroups[event.player_index][event.entity.name].memberCount = global.combatUnitGroups[event.player_index][event.entity.name].memberCount - 1 

end

function createdCombatRobot(event)

	local entity = event.entity 
	local player_index = ""

	if event.source == nil then
		player_index = global.lastCapsuleUser
	else
		player_index = event.source.player.index
	end
	
	if not global.combatUnitGroups[player_index] then
		initUnitGroupForPlayer(player_index)
	end

	if not global.combatUnitGroups[player_index][entity.name] then
		createCombatUnitGroup(global.combatUnitGroups[player_index], player_index, entity)
	end

	addMemberToUnit(global.combatUnitGroups[player_index][entity.name], player_index, entity)
end

function createCombatUnitGroup(combatUnitGroup, player_index, entity)

	combatUnitGroup[entity.name] = {}

	local newCombatUnit = shallowcopy(combatUnitGroupTemplate)

	newCombatUnit.playerID = player_index
	newCombatUnit.unitType = entity.name
	newCombatUnit.surface = entity.surface
	newCombatUnit.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity.force })

	combatUnitGroup[entity.name] = newCombatUnit
end 

function addMemberToUnit(combatUnitGroup, player_index, entity)

	if not combatUnitGroup.unitGroup.valid then 
		combatUnitGroup.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity.force })
	end

	if entity.name == "destroyer-unit" and not combatUnitGroup.unitGroup.command then 
		combatUnitGroup.createdTick = game.tick
	end

	combatUnitGroup.unitGroup.add_member(entity)
	combatUnitGroup.memberCount = combatUnitGroup.memberCount + 1

	entity.last_user = player_index
end

function entityDied(event)

	local entity = event.entity
	local force = event.force

	if entity.type == "unit-spawner" then
		removeSpawnerFromList(entity)
	elseif entity.name == "destroyer-unit" or entity.name == "defender-unit" or entity.name == "sentry-unit" then
		removeUnitFromGroup(entity)
	elseif event.entity.force.name == "enemy" and entity.type == "unit" and entity.active == true then
		removeFromKillList(entity)
	end

end

function removeSpawnerFromList(entity)

	if (tableContainsCoordinate(global.attackList, entity.position) == true) then
		local key = getKeyForValue(global.attackList, entity.position) 

		table.remove(global.attackList, key)

	end

end

function removeUnitFromGroup(entity)

	local player_index = entity.last_user.index

	if global.combatUnitGroups[player_index][entity.name] then 
		global.combatUnitGroups[player_index][entity.name].memberCount = global.combatUnitGroups[player_index][entity.name].memberCount - 1

		if global.combatUnitGroups[player_index][entity.name].memberCount == 0 then
			global.combatUnitGroups[player_index][entity.name].unitGroup.destroy()
		end

	end
end

function removeFromKillList(entity)

	if (tableContainsUnit(global.killList, entity.unit_number) == true) then
		local key = getKeyForEntity(global.killList, entity.unit_number)

		global.killList[key] = nil

	end
end

function entityDamaged(event) 

	if event.force.name == "enemy" and event.cause and event.entity.has_flag("player-creation") and (tableContainsUnit(global.killList, event.entity.unit_number) == false) and not excludeList[event.entity.name] then
		if event.entity.valid and event.cause.type == "unit" then 
			table.insert(global.killList, event.cause.unit_number, event.cause)
		end
	end
end

function handleUnitGroupsOnTick(event)

	for _, playerUnits in ipairs(global.combatUnitGroups) do

		for _, unit in pairs(playerUnits) do
			if unit.unitType == "destroyer-unit" and unit.unitGroup.valid then 
				
				local waitTick = unit.createdTick + ( settings.global["time-before-attack"].value * 60 )
				
				if game.tick > waitTick and next(global.attackList) ~= nil then 
					handleDestroyerUnit(unit.unitGroup)
				end

			elseif unit.unitType == "defender-unit" and unit.unitGroup.valid then
				if game.players[unit.playerID].is_shortcut_toggled("toggle-defender") then
					defendPlayer(unit.playerID, unit.unitGroup)
				else
					defendBase(unit.unitGroup)
				end

			elseif unit.unitType == "sentry-unit" and unit.unitGroup.valid then
				handleSentryUnit(unit.unitGroup)
			end
		end
	end
end

function handleDestroyerUnit(unitGroup)

	if not unitGroup.command then 
		
		local target = getClosestCoordinate(unitGroup.position, global.attackList)

		unitGroup.set_command({ type = defines.command.attack_area, destination = target, radius = 20, distraction = defines.distraction.by_enemy })
	end
	unitGroup.start_moving()
	
end

function defendPlayer(player_index, unitGroup)

	local player = game.players[player_index]

	local defender_distance = settings.get_player_settings(player.index)["defender-distance"].value

	if unitGroup.command == nil or unitGroup.command.type ~= 2 then
		
		if player.character then
			unitGroup.set_command({ type = defines.command.go_to_location, destination_entity = player.character, radius = defender_distance, distraction = defines.distraction.by_enemy })
			unitGroup.start_moving()
		elseif not player.character then 
			unitGroup.set_command({ type = defines.command.go_to_location, destination = player.position, radius = defender_distance, distraction = defines.distraction.by_enemy })
			unitGroup.start_moving()
		end
	end
end

function defendBase(unitGroup)

	if unitGroup.command == nil or unitGroup.command.type ~= 1 then
		
		local targetEntity = getClosestEntity(unitGroup.position, global.killList) 

		if targetEntity.valid and getDistance(targetEntity.position, unitGroup.position) < settings.global["base-defender-radius"].value then 
			unitGroup.set_command({ type = defines.command.attack, target = targetEntity, distraction = defines.distraction.by_enemy })
			unitGroup.start_moving()	
		end
	end
end
	
function handleSentryUnit(unitGroup)

	if unitGroup.command == nil then
		unitGroup.start_moving()
	end

	for _, member in pairs(unitGroup.members) do 
		if member.valid then --and member.has_command() then
			member.set_command({ type = defines.command.go_to_location, destination = member.position, radius = settings.global["sentry-radius"].value, distraction = defines.distraction.by_enemy})
		end
	end
end

function test(event)

	if event.result == 4 then 
		game.print("Test")
	end
end

script.on_init(combatRobotOverhaul_init)
script.on_configuration_changed(combatRobotOverhaul_init)
script.on_event(defines.events.on_player_joined_game, initUnitGroupForPlayer)
script.on_event(defines.events.on_lua_shortcut, toogleDefenderFollow) 
script.on_event(defines.events.on_chunk_charted, checkAreaForSpawner )
script.on_event(defines.events.on_player_used_capsule, usedCapsule)
script.on_event(defines.events.on_player_mined_entity, entityMined, {{ filter = "name", name = "destroyer-unit" }, { filter = "name", name = "defender-unit" }, { filter = "name", name = "sentry-unit"}})
script.on_event(defines.events.on_ai_command_completed, test)
script.on_event(defines.events.on_trigger_created_entity, createdCombatRobot)
script.on_event(defines.events.on_entity_died, entityDied)
script.on_event(defines.events.on_entity_damaged, entityDamaged)
script.on_event(defines.events.on_tick, handleUnitGroupsOnTick)