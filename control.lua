require("util/util")

local combatUnitGroupTemplate = { playerID = true, unitType = true, unitGroup = true, surface = true, memberCount = 0, currentCommand = 0 }

local excludeList = {
	["defender-unit"] = true,
	["sentry-unit"] = true,
	["destroyer-unit"] = true,
	["locomotive"] = true,
	["fluid-wagon"] = true,
	["cargo-wagon"] = true,
}

function combatRobotOverhaul_init()

	if not global.combatUnitGroups then
		global.combatUnitGroups = {}
	end

	if not global.attackList then 
		global.attackList = {}
	end

	if not global.defendList then 
		global.defendList = {}
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

	global.combatUnitGroups[player_index] = {}

end

function toogleDefenderFollow(event)

	local player = game.players[event.player_index]
	local defenderUnit = global.combatUnitGroups[player.index]["defender-unit"]

	if event.prototype_name == "toggle-defender" then 
		if player.is_shortcut_toggled("toggle-defender") then 
			player.set_shortcut_toggled("toggle-defender", false)
		else 
			player.set_shortcut_toggled("toggle-defender", true)
		end
	end
end

function checkAreaForEnemyBase(event)

	for _, entity in pairs(game.surfaces[1].find_entities_filtered({ area = event.area, type = { 'unit-spawner', "turret" }, force = 'enemy' })) do
		if not tableContainsValue(global.attackList, entity) and entity.active then 
			table.insert(global.attackList, entity.unit_number, entity)
		end
	end
end

function usedCapsule(event)

	local player = game.players[event.player_index]
	local item = event.item
	local memberCount = 0

	if item.name == "defender-unit-capsule" or item.name == "destroyer-unit-capsule" or item.name == "sentry-unit-capsule" then

		--init global table for player if not already created
		if not global.combatUnitGroups[player.index] then
			initUnitGroupForPlayer(player.index)
		end

		-- get meberCount or leave it at zero if no combat group for this type has been created
		if global.combatUnitGroups[player.index][unitType] then
			memberCount = global.combatUnitGroups[player.index][unitType].memberCount
		end

		if memberCount <= game.forces.player.maximum_following_robot_count then 
			--handle prototype creation differently depending if player has character or is in sandbox mode (no character)
			if player.character then 
				game.surfaces[1].create_entity{ name = item.name, player = player, position = player.position, target = event.position, force = player.force, source = player.character, speed = 0.3, max_range = 25 }
			else
				local unitType = item.name:gsub("-capsule","")
				local entity = game.surfaces[1].create_entity{ name = unitType, player = player, position = player.position, force = player.force }
				
				-- raise event with event.entity and event.source.player.index
				script.raise_event(defines.events.on_trigger_created_entity, { entity = entity, source = { player = { index = player.index }}})
			end
		else
			player.create_local_flying_text{ text = {"messages.max_type_reached", combatRobot}, position = event.position }
		end
	end
end

function createdCombatRobot(event)

	local entity = event.entity
	local player = game.players[event.source.player.index]

	local combatUnitGroup = global.combatUnitGroups[player.index]

	if not combatUnitGroup[entity.name] then
		createCombatUnitGroup(combatUnitGroup, entity)
	end

	addMemberToGroup(combatUnitGroup[entity.name], entity)

end

function createCombatUnitGroup(combatUnitGroup, entity)

	local newCombatUnit = shallowcopy(combatUnitGroupTemplate)

	--newCombatUnit.playerID = player_index
	newCombatUnit.unitType = entity.name
	newCombatUnit.surface = entity.surface
	newCombatUnit.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity. force })

	combatUnitGroup[entity.name] = newCombatUnit

end 

function addMemberToGroup(combatUnitGroup, entity)

	if not combatUnitGroup.unitGroup.valid then
		combatUnitGroup.unitGroup = entity.surface.create_unit_group({ position = entity.position, force = entity.force })
	end

	if entity.name == "destroyer-unit" and not combatUnitGroup.unitGroup.command then 
		combatUnitGroup.createdTick = game.tick
	end

	combatUnitGroup.unitGroup.add_member(entity)
	combatUnitGroup.memberCount = combatUnitGroup.memberCount + 1

end

function entityDied(event)

	local entity = event.entity
	local force = event.force

	if entity.force.name == 'enemy' then
		if entity.type == "unit-spawner" or entity.type == "turret" then
			removeFromList(entity, global.attackList)
		else
			removeFromList(entity, global.defendList)
		end
	elseif entity.name == "destroyer-unit" or entity.name == "defender-unit" or entity.name == "sentry-unit" then
		removeRobotFromGroup(event)
	end

end

function removeFromList(entity, table)

	local key = tableContainsValue(table, entity) 

	if key then 
		table[key] = nil
	end
end

function removeRobotFromGroup(event)

	local player = game.players[event.entity.last_user.index]
	local combatUnitGroup = global.combatUnitGroups[player.index][event.entity.name]

	combatUnitGroup.memberCount = combatUnitGroup.memberCount - 1

	if combatUnitGroup.memberCount == 0 then 
		combatUnitGroup.unitGroup.destroy()
		player.add_alert( event.entity, defines.alert_type.entity_destroyed )

	end
end

function entityDamaged(event)

	if event.force.name == "enemy" and event.entity.has_flag("player-creation") and not excludeList[event.entity.name] and event.cause and event.cause.type == "unit" then 
		if event.cause.valid and not tableContainsValue(global.defendList, event.cause) then 
			table.insert(global.defendList, event.cause.unit_number, event.cause)
		end
	end
end

function handleUnitGroupsOnTick(event)

	for player_index, player in pairs(game.players) do

		for unitType, unit in pairs(global.combatUnitGroups[player_index]) do

			if unitType == "destroyer-unit" and unit.unitGroup.valid then 

				local waitTick = unit.createdTick + ( settings.global["time-before-attack"].value * 60)

				if game.tick > waitTick and next(global.attackList) then 
					handleDestroyerUnit(unit.unitGroup)
				end

			elseif unitType == "defender-unit" and unit.unitGroup.valid then 
				
				if player.is_shortcut_toggled("toggle-defender") then 
					defendPlayer(unit.unitGroup, player)
				else
					defendBase(unit.unitGroup)
				end
			end
		end
	end
end

function handleDestroyerUnit(unitGroup)
	
	if next(global.attackList) then

			if not unitGroup.command or unitGroup.command.type ~= defines.command.attack then 

				local targetEntity = unitGroup.surface.get_closest(unitGroup.position, global.attackList)

				if targetEntity and targetEntity.valid then 

					unitGroup.set_command({ type = defines.command.attack, target = targetEntity, distraction = defines.distraction.by_enemy })
					unitGroup.start_moving()
				end
			end
	elseif not unitGroup.command or unitGroup.command.type ~= defines.command.wander then
		unitGroup.set_command({ type = defines.command.wander, radius = 10, distraction = defines.distraction.by_enemy })
		unitGroup.start_moving()
	end
end

function defendPlayer(unitGroup, player)

	local defender_distance = settings.get_player_settings(player.index)["defender-distance"].value

	if not unitGroup.command or unitGroup.command.type ~= 2 then 

		if player.character then 
			unitGroup.set_command({ type = defines.command.go_to_location, destination_entity = player.character, radius = defender_distance, distraction = defines.distraction.by_enemy })
			unitGroup.start_moving()
		elseif not player.character then
			unitGroup.set_command({ type = defines.command.go_to_location, destination = player.position, radius = defender_radius, distraction = defines.distraction.by_enemy })
			unitGroup.start_moving()
		end
	end
end

function defendBase(unitGroup)

	if next(global.defendList) then 

		for _, entity in pairs(global.defendList) do

			if not unitGroup.command or unitGroup.command.type ~= defines.command.attack then
			
				local targetEntity = unitGroup.surface.get_closest(unitGroup.position, global.defendList)

				if targetEntity and targetEntity.valid and getDistance(targetEntity.position, unitGroup.position) < settings.global["base-defender-radius"].value then 

					unitGroup.set_command({ type = defines.command.attack, target = targetEntity, radius = 20, distraction = defines.distraction.by_enemy })
					unitGroup.start_moving()
				end		
			end
		end
	elseif not unitGroup.command or unitGroup.command.type ~= defines.command.wander then
		unitGroup.set_command({ type = defines.command.wander, radius = 20, distraction = defines.distraction.by_enemy})
		unitGroup.start_moving()
	end
end

script.on_init(combatRobotOverhaul_init)
script.on_configuration_changed(combatRobotOverhaul_init)
script.on_event(defines.events.on_player_joined_game, function(event) initUnitGroupForPlayer(event.player_index) end)

script.on_event(defines.events.on_lua_shortcut, toogleDefenderFollow) 
script.on_event(defines.events.on_chunk_charted, checkAreaForEnemyBase )

script.on_event(defines.events.on_player_used_capsule, usedCapsule)
script.on_event(defines.events.on_trigger_created_entity, createdCombatRobot)

script.on_event(defines.events.on_player_mined_entity, removeRobotFromGroup, {{ filter = "name", name = "destroyer-unit" }, { filter = "name", name = "defender-unit" }, { filter = "name", name = "sentry-unit"}})
script.on_event(defines.events.on_entity_died, entityDied)
script.on_event(defines.events.on_entity_damaged, entityDamaged)

script.on_nth_tick(60, handleUnitGroupsOnTick)