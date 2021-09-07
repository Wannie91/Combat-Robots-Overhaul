local util = require("util")
local BaseGroup = require("basegroup")

local DestroyerGroup = {}
setmetatable(DestroyerGroup, {__index = BaseGroup})

function DestroyerGroup:new(player) 

    local destroyerGroup = BaseGroup:new(player) 
    destroyerGroup.is_attacking = false

    setmetatable(destroyerGroup, {__index = DestroyerGroup})
    return destroyerGroup

end

function DestroyerGroup:ready_for_attack()

    if game.tick > (self.last_update_tick + (settings.global["attack-delay"].value * 60)) then 
        return true 
    end

    return false 

end

function DestroyerGroup:attack_enemy(target)

    for _, member in pairs(self.group_members) do 
        if member.valid then 
            member.set_command({type = defines.command.attack_area, destination = target.position, radius = 15, distraction = defines.distraction.by_enemy})
        end    
    end

    self.last_attack_tick = game.tick 
    self.is_attacking = true
    self.current_target = target

end

function DestroyerGroup:update(targetList)

    self:get_group_position()

    if not self:ready_for_attack() then return end 

    local was_attacking = self.is_attacking 
    self.is_attacking = (game.tick - self.last_attack_tick) < 60

    if not self.is_attacking and not was_attacking then 

        if next(targetList[self.surface.index]) and self:has_members() then 

            local target_entity = self.surface.get_closest(self.group_position, targetList[self.surface.index]) 

            if target_entity and target_entity.valid and target_entity ~= self.current_target  then 
                self:attack_enemy(target_entity)
            end
        end
    end

end

return DestroyerGroup


