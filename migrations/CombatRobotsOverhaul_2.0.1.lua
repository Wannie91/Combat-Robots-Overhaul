local util = require("__CombatRobotsOverhaul__/scripts/util")
local DefenderGroup = require("__CombatRobotsOverhaul__/scripts/defendergroup")
local SentryGroup = require("__CombatRobotsOverhaul__/scripts/sentrygroup")
local DestroyerGroup = require("__CombatRobotsOverhaul__/scripts/destroyergroup")

local data = global.combatRobotsOverhaulData

data.defenderGroups = {}
data.sentryGroups = {}
data.destroyerGroups = {}

if data.combatUnits then

    for _, combatUnit in pairs(data.combatUnits) do 

        local player = combatUnit.player

        if combatUnit.unitType == "defender-unit" then 
            local defenderGroup = DefenderGroup:new(player)
            defenderGroup.surface = combatUnit.player.surface
            table.insert(data.defenderGroups, defenderGroup)           
        elseif combatUnit.unitType == "sentry-unit" then 
            local sentryGroup = SentryGroup:new(player)
            sentryGroup.surface = combatUnit.player.surface
            table.insert(data.sentryGroups, sentryGroup)        
        elseif combatUnit.unitType == "destroyer-unit" then 
            local destroyerGroup = DestroyerGroup:new(player)
            destroyerGroup.surface = combatUnit.player.surface
            table.insert(data.destroyerGroups, destroyerGroup)      
        end

    end

    local sentryUnits = game.surfaces["nauvis"].find_entities_filtered({name = "sentry-unit"})

    for _, unit in pairs(sentryUnits) do 

        local sentryGroup = util.get_group(data.sentryGroups, unit.last_user.index, unit.surface.index)

        if not sentryGroup then 
            sentryGroup = SentryGroup:new(unit.last_user)
        end

        sentryGroup:add_member(unit)

    end

    local destroyerUnits = game.surfaces["nauvis"].find_entities_filtered({name = "destroyer-unit"})

    for _, unit in pairs(destroyerUnits) do 

        local destroyerGroup = util.get_group(data.destroyerGroups, unit.last_user.index, unit.surface.index)

        if not destroyerGroup then 
            destroyerGroup = DestroyerGroup:new(unit.last_user)
        end

        destroyerGroup:add_member(unit)

    end

end

if data.attackList then 

    data.targetList = {}

    for _, entity in pairs(data.attackList) do 
        if entity.valid then 

            if not data.targetList[entity.surface.index] then
                data.targetList[entity.surface.index] = {}
            end

            data.targetList[entity.surface.index][entity.unit_number] = entity
        end
    end

end

data.combatUnits = nil
data.attackList = nil

global.combatRobotsOVerhaulData = data
