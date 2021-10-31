local util = require("scripts/util")
local modDefines = require("scripts/defines")
local DefenderGroup = require("scripts/defendergroup")
local DestroyerGroup = require("scripts/destroyergroup")
local SentryGroup = require("scripts/sentrygroup")

local data = 
{
    defenderGroups = {},
    sentryGroups = {},
    destroyerGroups = {},
    targetList = {},
    defenceExcludeList = {},
}

local get_combatGroup = function(type, player_index, surface_index) 

    if type == modDefines.units.defender then 
        return util.get_group(data.defenderGroups, player_index, surface_index)
    elseif type == modDefines.units.sentry then 
        return util.get_group(data.sentryGroups, player_index, surface_index) 
    elseif type == modDefines.units.destroyer then 
        return util.get_group(data.destroyerGroups, player_index, surface_index)
    end

end
    
local on_init = function() 

    global.combatRobotsOverhaulData = global.combatRobotsOverhaulData or data

    if game.forces["player"].technologies["defender"].researched then 
        game.forces["player"].recipes["defender-unit"].enabled = true
        game.forces["player"].recipes["sentry-unit"].enabled = true
        game.forces["player"].recipes["destroyer-unit"].enabled = true
    end

    data.defenceExcludeList = util.create_exclude_list(data.defenceExcludeList)

end

local on_load = function()

    --copy data to or from global when game is saved / loaded
    data = global.combatRobotsOverhaulData or data
    global.combatRobotsOverhaulData = data 

    for _, defenderGroup in pairs(data.defenderGroups) do 
        setmetatable(defenderGroup, {__index = DefenderGroup})
    end

    for _, sentryGroup in pairs(data.sentryGroups) do 
        setmetatable(sentryGroup, {__index = SentryGroup})
    end

    for _, destroyerGroup in pairs(data.destroyerGroups) do 
        setmetatable(destroyerGroup, {__index = DestroyerGroup})
    end

end

local modsettings_changed = function(event) 

    if event.setting ~= "defence-exclude-list" then return end

    data.defenceExcludeList = util.create_exclude_list(data.defenceExcludeList)

end

local toggle_defender_follow = function(event)

    local player = game.get_player(event.player_index)
    local input = event.prototype_name or event.input_name

    if input ~= "defend-player" then return end 

    player.set_shortcut_toggled(input, not player.is_shortcut_toggled(input))

    if not player.is_shortcut_toggled(input) then 

        local combatGroup = get_combatGroup(modDefines.units.defender, player.index, player.surface.index)

        if combatGroup then 
            combatGroup:stop_following_player()
        end 
    end

end

local check_area_for_enemy_bases = function(event)

    if not data.targetList[event.surface_index] then 
        data.targetList[event.surface_index] = {}
    end

    for _, entity in pairs(game.get_surface(event.surface_index).find_entities_filtered({area = event.area, force = "enemy", type  = {"unit-spawner", "turret"}})) do 
        if not util.table_contains_value(data.targetList[event.surface_index], entity.unit_number) and entity.active then 
            data.targetList[event.surface_index][entity.unit_number] = entity
        end
    end

end

local entity_died = function(event)

    local entity = event.entity
    if entity.force.name == "enemy" and (entity.type == "unit-spawner" or entity.type == "turret") then 
        if util.table_contains_value(data.targetList[entity.surface.index], entity.unit_number) then  
            data.targetList[entity.surface.index][entity.unit_number] = nil 
        end
    elseif entity.force.name == "player" and (entity.name == modDefines.units.defender or entity.name == modDefines.units.sentry or entity.name == modDefines.units.destroyer) then 
        local combatGroup = get_combatGroup(entity.name, entity.last_user.index, entity.surface.index)

        if combatGroup then 
            combatGroup:remove_member(entity)
        end
    end

end

local entity_mined = function(event)

    if not event.entity.last_user then return end

    local entity = event.entity 
    local combatGroup = get_combatGroup(entity.name, entity.last_user.index, entity.surface.index)

    if combatGroup then 
        combatGroup:remove_member(entity)
    end

end

local remote_used = function(event)

    if event.vehicle.name == modDefines.units.defender or event.name == modDefines.units.destroyer then 
        event.vehicle.follow_target = nil
        event.vehicle.autopilot_destination = nil    
    end

end

local player_used_capsule = function(event) 

    local item = event.item 

    if (item.name == modDefines.capsules.defender) or (item.name == modDefines.capsules.sentry) or (item.name == modDefines.capsules.destroyer) then 

        local player = game.get_player(event.player_index)
        local unitType = modDefines.associations[item.name]
        local combatGroup = get_combatGroup(unitType, player.index, player.surface.index) 

        if not combatGroup or combatGroup:get_member_count() < game.forces.player.maximum_following_robot_count then 
            if player.character then 
                player.surface.create_entity{name = item.name, player = player, position = player.position, target = event.position, force = player.force, source = player.character, speed = 0.3, max_range = 25}
            else
                player.surface.create_entity{name = unitType, player = player, position = event.position, force = player.force, raise_built = true}
            end
        else
            player.create_local_flying_text{text = {"messages.max-type-reached", unitType}, create_at_cursor = true}
            player.insert{name = item.name, count = 1}
        end
    end

end

local created_entity = function(event) 

    if event.entity.name ~= modDefines.units.defender and event.entity.name ~= modDefines.units.sentry and event.entity.name ~= modDefines.units.destroyer then return end 

    local entity = event.entity
    local player = game.get_player(event.entity.last_user.index)
    local combatGroup = get_combatGroup(entity.name, player.index, entity.surface.index)

    if not combatGroup then 
        if entity.name == modDefines.units.defender then 
            combatGroup = DefenderGroup:new(player)
            table.insert(data.defenderGroups, combatGroup)
        elseif entity.name == modDefines.units.sentry then 
            combatGroup = SentryGroup:new(player)
            table.insert(data.sentryGroups, combatGroup)
        elseif entity.name == modDefines.units.destroyer then 
            combatGroup = DestroyerGroup:new(player)
            table.insert(data.destroyerGroups, combatGroup)
        end
    end

    combatGroup:add_member(entity)

end

local player_changed_surface = function(event) 

    local combatGroup = get_combatGroup(modDefines.units.defender, event.player_index, event.surface_index)

    if combatGroup then 
        combatGroup:stop_following_player()
    end 

end

local defend_base = function(event) 

    if event.force.name == "enemy" and event.entity.has_flag("player-creation") and not data.defenceExcludeList[event.entity.name] then 
        for player_index, defenderGroup in pairs(data.defenderGroups) do
            defenderGroup:defend_base(event.entity)
        end
    end

end

local on_tick = function()

    for _, defenderGroup in pairs(data.defenderGroups) do 
        defenderGroup:update()
    end

    for _, destroyerGroup in pairs(data.destroyerGroups) do 
        destroyerGroup:update(data.targetList)
    end

end

script.on_init(on_init)
script.on_load(on_load)

script.on_configuration_changed(configuration_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed, modsettings_changed)

script.on_event(defines.events.on_player_changed_surface, player_changed_surface)
script.on_event({defines.events.on_lua_shortcut, "defend-player"}, toggle_defender_follow)
script.on_event(defines.events.on_chunk_charted, check_area_for_enemy_bases)

script.on_event(defines.events.on_entity_died, entity_died)
script.on_event(defines.events.on_player_mined_entity, entity_mined, modDefines.eventFilters)

script.on_event(defines.events.on_player_used_spider_remote, remote_used)
script.on_event(defines.events.on_player_used_capsule, player_used_capsule)
script.on_event(defines.events.script_raised_built, created_entity, modDefines.eventFilters)
script.on_event(defines.events.on_trigger_created_entity, created_entity)
script.on_event(defines.events.on_entity_damaged, defend_base)

script.on_nth_tick(60, on_tick)


    
