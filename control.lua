local util = require("scripts/util")
local modDefines = require("scripts/defines")
local DefenderGroup = require("scripts/defendergroup")
local DestroyerGroup = require("scripts/destroyergroup")
local SentryGroup = require("scripts/sentrygroup")
require("scripts/remote-interface")

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

    storage.combatRobotsOverhaulData = storage.combatRobotsOverhaulData or data

    if game.forces["player"].technologies["defender"].researched then 
        game.forces["player"].recipes["defender-unit"].enabled = true
        game.forces["player"].recipes["sentry-unit"].enabled = true
        game.forces["player"].recipes["destroyer-unit"].enabled = true
    end

    data.defenceExcludeList = util.create_exclude_list(data.defenceExcludeList)

end

local on_load = function()

    --copy data to or from storage when game is saved / loaded
    data = storage.combatRobotsOverhaulData or data
    storage.combatRobotsOverhaulData = data 

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

    for _, entity in pairs(game.get_surface(event.surface_index).find_entities_filtered({area = event.area, force = "enemy", type  = {"unit-spawner", "turret", "segmented", "segmented-unit", "spider-unit"}})) do 
        if entity.active or ( entity.type == "segmented-unit" or entity.type == "segmented" ) then 
            data.targetList[event.surface_index][entity.unit_number] = entity
            script.register_on_object_destroyed(entity)
        end
    end

end

local entity_died = function(event)

    local entity = event.entity
    if entity.force.name == "enemy" and (entity.type == "unit-spawner" or entity.type == "turret" or entity.type == "segment" or entity.type == "segmented-unit" or entity.type == "spider-unit") then 
        if data.targetList[entity.surface.index] then 
            data.targetList[entity.surface.index][entity.unit_number] = nil 
        end
    elseif entity.force.name == "player" and (entity.name == modDefines.units.defender or entity.name == modDefines.units.sentry or entity.name == modDefines.units.destroyer) then 
        local combatGroup = get_combatGroup(entity.name, entity.last_user.index, entity.surface.index)

        if combatGroup then 
            combatGroup:remove_member(entity)
        end        
    end

end

local entity_destroyed = function(event)

    if event.unit_number then 
        for surface_id, surface in pairs(data.targetList) do 
            if surface[event.unit_number] then 
                data.targetList[surface_id][event.unit_number] = nil
            end
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

local player_used_capsule = function(event) 

    local item = event.item 

    if (item.name == modDefines.capsules.defender) or (item.name == modDefines.capsules.sentry) or (item.name == modDefines.capsules.destroyer) then 

        local player = game.get_player(event.player_index)
        local unitType = modDefines.associations[item.name]
        local combatGroup = get_combatGroup(unitType, player.index, player.surface.index)

        local projectile = player.surface.find_entities_filtered{ name = item.name, position = player.position, radius = 5, force = player.force}
        projectile[1].destroy()  

        if not combatGroup or (combatGroup:get_member_count() + player.surface.count_entities_filtered{ name = item.name, position = player.position, radius = 25, force = player.force}) < player.force.maximum_following_robot_count then 
            
            local block_projectile = false

            if remote.interfaces.jetpack then 

                local jetpacks = remote.call("jetpack", "get_jetpacks", {})

                for _, jetpack in pairs(jetpacks) do 
                    if jetpack.player_index == player.index and jetpack.status >= 2 then 
                        block_projectile = true 
                    end
                end
            end
            
            if player.character and not block_projectile then
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

    if not entity.last_user then 

        local character_corpses = entity.surface.find_entities_filtered{ name = "character-corpse", position = entity.position, radius = 35 }
        local newest_corpse_index = 1
        
        if #character_corpses > 1 then 

            local latest_tick_of_death = 0

            for key, corpse in pairs(character_corpses) do 
                if corpse.character_corpse_tick_of_death > latest_tick_of_death then 
                    latest_tick_of_death = corpse.character_corpse_tick_of_death 
                    newest_corpse_index = key
                end
            end
        end

        -- entity.last_user = game.get_player(character_corpses[newest_corpse_index].character_corpse_player_index)

    end

    local combatGroup = get_combatGroup(entity.name, entity.last_user.index, entity.surface.index)

    if not combatGroup then 
        if entity.name == modDefines.units.defender then 
            combatGroup = DefenderGroup:new(entity.last_user)
            table.insert(data.defenderGroups, combatGroup)
        elseif entity.name == modDefines.units.sentry then 
            combatGroup = SentryGroup:new(entity.last_user)
            table.insert(data.sentryGroups, combatGroup)
        elseif entity.name == modDefines.units.destroyer then 
            combatGroup = DestroyerGroup:new(entity.last_user)
            table.insert(data.destroyerGroups, combatGroup)
        end
    end

    if entity.name == modDefines.units.defender or entity.name == modDefines.units.destroyer then 
        entity.grid.put{name = entity.name.."-equipment"}
        entity.operable = false
    end

    combatGroup:add_member(entity)

end

local player_changed_surface = function(event) 

    local player = game.get_player(event.player_index)
    local defenderGroup = get_combatGroup(modDefines.units.defender, player.index, event.surface_index) 

    if defenderGroup and player.is_shortcut_toggled("defend-player") then 
        defenderGroup:stop_following_player()
    end 
end

local surface_deleted = function(event) 

    data.targetList[event.surface_index] = nil 
    data.defenderGroups[event.surface_index] = nil 
    data.sentryGroups[event.surface_index] = nil 
    data.destroyerGroups[event.surface_index] = nil 

end

local defend_base = function(event) 

    if event.force.name == "enemy" and event.entity.has_flag("player-creation") and not data.defenceExcludeList[event.entity.name] and event.cause and event.cause.valid then
        for _, defenderGroup in pairs(data.defenderGroups) do
            defenderGroup:defend_base(event.cause)
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

-- script.on_configuration_changed(configuration_changed)
script.on_event(defines.events.on_runtime_mod_setting_changed, modsettings_changed)

script.on_event(defines.events.on_chunk_charted, check_area_for_enemy_bases)
script.on_event({defines.events.on_lua_shortcut, "defend-player"}, toggle_defender_follow)

script.on_event(defines.events.on_player_changed_surface, player_changed_surface)
script.on_event(defines.events.on_surface_deleted, surface_deleted)
script.on_event(defines.events.on_player_mined_entity, entity_mined, modDefines.eventFilters)
script.on_event(defines.events.on_player_used_capsule, player_used_capsule)

script.on_event(defines.events.on_entity_died, entity_died)
script.on_event(defines.events.on_object_destroyed, entity_destroyed)
script.on_event(defines.events.script_raised_built, created_entity, modDefines.eventFilters)
script.on_event(defines.events.on_trigger_created_entity, created_entity)
script.on_event(defines.events.on_entity_damaged, defend_base)

script.on_nth_tick(60, on_tick)

    
