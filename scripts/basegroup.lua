local util = require("util")
local BaseGroup = {}

function BaseGroup:new(player)

    local basegroup = 
    {
        player = player,
        surface = player.surface,
        members = {},
        group_position = {x = 0, y = 0},
        created_tick = game.tick, 
        last_update_tick = game.tick,
        last_attack_tick = 0,
        current_target = false,
        is_attacking = false,
        is_moving = false,
    }

    setmetatable(basegroup, {__index = BaseGroup})
    return basegroup

end

function BaseGroup:add_member(entity)

    self.members[entity.unit_number] = entity 
    self.last_update_tick = game.tick

end

function BaseGroup:remove_member(entity)

    self.members[entity.unit_number] = nil 

    if not self:has_members() then 
        self.player.print({"messages.group-destroyed", entity.name, string.format("[gps= %d, %d]", self.group_position.x, self.group_position.y)})
    end

end

function BaseGroup:get_group_position()

    local count = 0
    local position = {x = 0, y = 0}

    for _, member in pairs(self.members) do
        if member.valid then          
            position.x = position.x + member.position.x
            position.y = position.y + member.position.y
        
            count = count + 1
        end
    end

    self.group_position = {x = (position.x / count), y = (position.y / count)}
 
end

function BaseGroup:get_member_count()

    local count = 0
     
    for _, member in pairs(self.members) do
        if member.valid then 
            count = count + 1
        end
    end

    return count 

end

function BaseGroup:has_members()

    if not next(self.members) then 
        return false 
    end

    return true

end

function BaseGroup:valid_entity(entity)

    if entity and entity.valid and entity.surface.index == self.surface.index then 
        return true 
    end

    return false 

end

function BaseGroup:move_to_target(target) 

    for _, member in pairs(self.members) do 

        local position = member.position 

        position.x = target.position.x - math.random(-10, 10)
        position.y = target.position.y - math.random(-10, 10)

        member.autopilot_destination = position

    end
    
    self.current_target = target
    self.is_moving = true 

end

function BaseGroup:search_for_enemy_near_position(position, radius)

    local search_area = {{self.group_position.x - radius, self.group_position.y - radius}, {self.group_position.x + radius, self.group_position.y + radius}}
    local enemies = self.surface.find_entities_filtered({area = search_area, type = {"unit", "turret", "unit-spawner", "segment", "segmented-unit", "spider-unit"}, force = "enemy"})

    for _, enemy in pairs(enemies) do 
        if self:valid_entity(enemy) then 
            self:attack_enemy(enemy) 
            return
        end
    end

end

function BaseGroup:attack_enemy(enemy)

    for _, member in pairs(self.members) do 

        local distance = util.get_distance(member.position, enemy.position) - 16
        local position = member.position

        if math.abs(distance) > 2 then 

            local offset = util.get_offset(member.position, enemy.position, distance, (distance < 0 and math.pi/4) or 0)

            position.x = position.x + offset[1] - math.random(-10, 10)
            position.y = position.y + offset[2] - math.random(-10, 10)

            member.autopilot_destination = position
        end
    end

    self.last_attack_tick = game.tick 
    self.is_attacking = true 
    self.is_moving = false
    self.current_target = enemy

end

return BaseGroup