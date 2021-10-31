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

function DestroyerGroup:add_member(entity)

    BaseGroup.add_member(self, entity)
    
    entity.grid.put{name = "destroyer-unit-equipment"}
    entity.operable = false 

end

function DestroyerGroup:valid_entity(entity)

    if entity and entity.valid and entity.surface.index == self.surface.index then 
        return true
    end

    return false

end

function DestroyerGroup:ready_for_attack()

    if game.tick > (self.last_update_tick + (settings.global["attack-delay"].value * 60)) then 
        return true 
    end

    return false 

end

function DestroyerGroup:move_to_target(target) 

    for _, member in pairs(self.group_members) do 

        local position = member.position
        local offset = {x = 0,  y = 0}

        offset.x = self.group_position.x - position.x
        offset.y = self.group_position.y - position.y 

        position.x = target.position.x - offset.x
        position.y = target.position.y - offset.y 

        member.autopilot_destination = position
    end

    self.current_target = target
    self.is_moving_to_target = true

end

function DestroyerGroup:search_for_enemy_near_target_position()

    local search_area = {{self.group_position.x - 32, self.group_position.y - 32}, {self.group_position.x + 32, self.group_position.y + 32}}
    local enemies = self.surface.find_entities_filtered({area = search_area, type = {"unit", "turret", "unit-spawner"}, force = "enemy"})

    for _, enemy in pairs(enemies) do 
        if enemy.valid then 
            self:attack_enemy(enemy)
            return 
        end
    end

end

function DestroyerGroup:attack_enemy(target)
  
    local position = {x = self.group_position.x, y = self.group_position.y}
    local distance = util.get_distance(self.group_position, target.position) - 16

    for _, member in pairs(self.group_members) do 

        if math.abs(distance) > 2 then 

            local offset = util.get_offset(position, target.position, distance, (distance < 0 and math.pi/4) or 0)

            position.x = position.x + offset[1]
            position.y = position.y + offset[2]

            member.autopilot_destination = position
        end
    end

    self.last_attack_tick = game.tick 
    self.is_attacking = true
    self.current_target = enemy

end

function DestroyerGroup:update(targetList)

    if not self:ready_for_attack() then return end 

    self:get_group_position()

    local was_attacking = self.is_attacking 
    self.is_attacking = (game.tick - self.last_attack_tick) < 60

    if self:has_members() and was_attacking and not self.is_attacking then 
        self:search_for_enemy_near_target_position()
    end

    if was_attacking and self.is_attacking then return end

    if next(targetList[self.surface.index]) and self:has_members() then 

        --get closest target
        local target_entity = self.surface.get_closest(self.group_position, targetList[self.surface.index]) 

        if not self:valid_entity(self.current_target) or (self.current_target ~= target_entity and util.get_distance(self.group_position, self.current_target.position) > util.get_distance(self.group_position, target_entity.position)) then 
            self:move_to_target(target_entity) 
        end

        if self.is_moving_to_target and self.last_attack_tick ~= 0 and (game.tick - self.last_attack_tick) > 18000 then 
            for _, member in pairs(self.group_members) do 
                if not member.autopilot_destination then 
                    member.autopilot_destination = self.current_target 
                end
            end
        end

        if self.is_moving_to_target and (util.get_distance(self.group_position, self.current_target.position) <= 32) then
            self:search_for_enemy_near_target_position() 
        end        

    end

end

return DestroyerGroup


