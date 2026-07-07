local util = require("scripts/util")
local DefenderGroup = require("scripts/defendergroup")
local DestroyerGroup = require("scripts/destroyergroup")
local SentryGroup = require("scripts/sentrygroup")

data = storage.combatRobotsOverhaulData

for key, defenderGroup in pairs(data.defenderGroups) do 

    combatGroup = DestroyerGroup:new(defenderGroup.player)
    combatGroup.members = defenderGroup.members
    combatGroup.player = defenderGroup.player
    combatGroup.group_position = defenderGroup.group_position
    combatGroup.created_tick = defenderGroup.created_tick
    combatGroup.last_update_tick = defenderGroup.last_update_tick
    combatGroup.last_attack_tick = defenderGroup.last_attack_tick
    combatGroup.current_target = defenderGroup.current_target
    combatGroup.is_attacking = defenderGroup.is_attacking
    combatGroup.is_moving = defenderGroup.is_moving

    data.defenderGroups[key] = combatGroup
    
end

for key, sentryGroup in pairs(data.sentryGroups) do 
    
    combatGroup = SentryGroup:new(sentryGroup.player)
    combatGroup.members = sentryGroup.members
    combatGroup.player = sentryGroup.player
    combatGroup.group_position = sentryGroup.group_position
    combatGroup.created_tick = sentryGroup.created_tick
    combatGroup.last_update_tick = sentryGroup.last_update_tick
    combatGroup.last_attack_tick = sentryGroup.last_attack_tick
    combatGroup.current_target = sentryGroup.current_target
    combatGroup.is_attacking = sentryGroup.is_attacking
    combatGroup.is_moving = sentryGroup.is_moving

    data.sentryGroups[key] = combatGroup
end

for key, destroyerGroup in pairs(data.destroyerGroups) do 
    
    combatGroup = DestroyerGroup:new(destroyerGroup.player)
    combatGroup.members = destroyerGroup.members
    combatGroup.player = destroyerGroup.player
    combatGroup.group_position = destroyerGroup.group_position
    combatGroup.created_tick = destroyerGroup.created_tick
    combatGroup.last_update_tick = destroyerGroup.last_update_tick
    combatGroup.last_attack_tick = destroyerGroup.last_attack_tick
    combatGroup.current_target = destroyerGroup.current_target
    combatGroup.is_attacking = destroyerGroup.is_attacking
    combatGroup.is_moving = destroyerGroup.is_moving

    data.destroyerGroups[key] = combatGroup

end

