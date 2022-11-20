local util = require("util")
local BaseGroup = require("basegroup")

local DestroyerGroup = {}
setmetatable(DestroyerGroup, {__index = BaseGroup})

function DestroyerGroup:new(player) 

    local destroyerGroup = BaseGroup:new(player) 

    setmetatable(destroyerGroup, {__index = DestroyerGroup})
    return destroyerGroup

end

function DestroyerGroup:ready_for_attack()

    if game.tick > (self.last_update_tick + (settings.global["attack-delay"].value * 60)) then 
        return true 
    end

    return false 

end

function DestroyerGroup:update(targetList)

    self:get_group_position()
   
    if not self:ready_for_attack() then return end 

    local was_attacking = self.is_attacking
    self.is_attacking = (game.tick - self.last_attack_tick) < 60

    if self:has_members() and was_attacking and not self.is_attacking then 
        self:search_for_enemy_near_position(self.group_position, 32)
    end

    if was_attacking and self.is_attacking then return end 

    if next(targetList[self.surface.index]) and self:has_members() then 

        local target_entity = self.surface.get_closest(self.group_position, targetList[self.surface.index])

        if not self.is_moving or not self:valid_entity(self.current_target) or not self:valid_entity(target_entity) or (self.current_target ~= target_entity and util.get_distance(self.group_position, self.current_target.position) < util.get_distance(self.group_position, target_entity.position)) then 
            self:move_to_target(target_entity)
        end

        if self.is_moving and self.last_attack_tick ~= 0 and (game.tick - self.last_attack_tick) > 18000 then 
            for _, member in pairs(self.members) do 
                if not member.autopilot_destination then 
                    member.autopilot_destination = self.current_target.position
                end
            end
        end

        if self.is_moving and (util.get_distance(self.group_position, self.current_target.position)) <= 48 then 
            self:search_for_enemy_near_position(self.group_position, 48)
        end
    end

end

return DestroyerGroup


