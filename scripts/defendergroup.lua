local util = require("util")
local BaseGroup = require("basegroup")

local DefenderGroup = {}
setmetatable(DefenderGroup, {__index = BaseGroup})

function DefenderGroup:new(player)

    local defenderGroup = BaseGroup:new(player)
    defenderGroup.is_defending = false 

    setmetatable(defenderGroup, {__index = DefenderGroup})
    return defenderGroup 

end

function DefenderGroup:add_member(entity)

    BaseGroup.add_member(self, entity)

    if self:get_member_count() > 0 then 
        self.player.set_shortcut_available("defend-player", true)
    end

    entity.grid.put{name = "defender-unit-equipment"}
    entity.operable = false 
    
end

function DefenderGroup:remove_member(entity)

    BaseGroup.remove_member(self, entity)

    if not self:has_members() and self.player.surface.index == self.surface.index then 
        self.player.set_shortcut_available("defend-player", false)
    end

end

function DefenderGroup:stop_following_player()

    for _, member in pairs(self.group_members) do 
        member.follow_target = nil 
        -- member.autopilot_destination = nil 
    end

end

function DefenderGroup:search_for_enemies_near_player() 

    local search_area = {{self.player.position.x - 32, self.player.position.y - 32}, {self.player.position.x + 32, self.player.position.y + 32}}
    local enemies = self.player.surface.find_entities_filtered({area = search_area, type = {"unit", "turret", "unit-spawner"}, force = "enemy"})

    for _, enemy in pairs(enemies) do 
        if enemy.valid then 
            self:attack_enemy(enemy)
            return 
        end
    end

end

function DefenderGroup:defend_entity(entity) 

    for _, member in pairs(self.group_members) do 
        member.autopilot_destination = entity.position
    end

    self.last_attack_tick = game.tick 
    self.is_defending = true
    self.current_target = entity

end

function DefenderGroup:attack_enemy(enemy) 

    local group_position = self.group_position
    local distance = util.get_distance(self.group_position, enemy.position) - 16

    for _, member in pairs(self.group_members) do 

        if math.abs(distance) > 2 then 

            local offset = util.get_offset(group_position, enemy.position, distance, (distance < 0 and math.pi/4) or 0)

            group_position.x = group_position.x + offset[1]
            group_position.y = group_position.y + offset[2]

            member.autopilot_destination = group_position
        end
    end

    self.last_attack_tick = game.tick 
    self.is_defending = true
    self.current_target = enemy

end

function DefenderGroup:get_player_speed(boost) 

    local boost = boost or 1.0 

    if self.player.vehicle then 
        return math.abs(self.player.vehicle.speed) * boost 
    elseif self.player.character then 
        return math.abs(self.player.character_running_speed) * boost 
    end

    return 0.3

end

function DefenderGroup:get_distance_boost(entity_position, position) 

    local distance = util.get_distance(entity_position, position)

    if distance > 500 then 
        return (distance / 150) 
    elseif distance > 250 then 
        return (distance / 200)
    elseif distance > 50 then 
        return (distance / 250)
    end

    return 1

end

function DefenderGroup:get_speed_sticker(entity)

    if entity.stickers then 
        for key, sticker in pairs(entity.stickers) do 
            if sticker.name == "speed-sticker" then 
                return entity.stickers[key]
            end
        end

    end

    return nil 

end

function DefenderGroup:create_speed_sticker(entity) 

    local speed_sticker = entity.surface.create_entity{name = "speed-sticker", target = entity, force = entity.force, position = entity.position}
    speed_sticker.active = false 

    return speed_sticker

end

function DefenderGroup:set_member_speed(entity, speed)

    if speed == entity.speed then return end 

    local speed_sticker = self:get_speed_sticker(entity) or self:create_speed_sticker(entity)

    local ratio = speed/(0.25 * 1)

    if ratio <= 1 then 
        speed_sticker.destroy()
    else
        speed_sticker.time_to_live = 1 + ((100/10) * ratio)
    end

end

function DefenderGroup:follow_player()

    local count = 0 
    local followers = {}

    for _, member in pairs(self.group_members) do 
        if member.valid then 
            count = count + 1 
            followers[count] = member
        end
    end

    if count == 0 then return end 

    local length = math.max(5 + (count * 0.33), settings.get_player_settings(self.player.index)["defender-distance"].value)
    local player_speed = self:get_player_speed()
    local dong = 0.75 + (0.75 / count) 
    local shift = {x = 0, y = 0}

    if self.player.vehicle then 
        local orientation = self.player.vehicle.orientation 

        dong = dong + orientation 
        shift = util.rotate_vector({0, -player_speed * 15}, orientation)

    elseif self.player.character then 
        local walking_state = self.player.character.walking_state 

        if walking_state.walking then 
            shift = util.rotate_vector({0, -player_speed * 15}, walking_state.direction / 8)
        end
    end

    local offset = {length, 0}
    local position = self.player.position 

    for key, follower in pairs(followers) do 
        local angle = (key / count) + dong 
        local follow_offset = util.rotate_vector(offset, angle) 
        local target = follower.follow_target  

        follow_offset.x = follow_offset.x + shift.x
        follow_offset.y = follow_offset.y + shift.y 

        if not (target and target.valid) then 
            if self.player.character then 
                follower.follow_target = self.player.character 
            else
                follower.autopilot_destination = {position.x + follow_offset.x, position.y + follow_offset.y}
            end
        end

        follower.follow_offset = follow_offset 
        self:set_member_speed(follower, follower.speed + self:get_distance_boost(follower.position, follower.autopilot_destination))
        self.last_update_tick = game.tick

    end

end

function DefenderGroup:defend_base(attacked_entity)

    if (self.surface.index == attacked_entity.surface.index and self.player.is_shortcut_toggled("defend-player")) or (self.current_target and self.current_target.valid and util.same_position(attacked_entity.position, self.current_target.position)) or not self:has_members() then return end 
    
    local distance_to_target = util.get_distance(attacked_entity.position, self:get_group_position())

    if distance_to_target < settings.global["base-defence-perimeter"].value and not self.is_defending or (self.current_target.valid and self.current_target.position and distance_to_target < util.get_distance(self.current_target.position, self:get_group_position())) then 
        
        self:defend_entity(attacked_entity)
        
        for _, member in pairs(self.group_members) do 
            if member.autopilot_destination then 
                self:set_member_speed(member, member.speed + self:get_distance_boost(member.position, member.autopilot_destination))
            end
        end
    end

end

function DefenderGroup:update()

    self:get_group_position()

    if self.player.is_shortcut_toggled("defend-player") and self.player.surface.index == self.surface.index then 

        local was_defending = self.is_defending 
        self.is_defending = (game.tick - self.last_attack_tick) < 60 

        self:search_for_enemies_near_player() 

        if not was_defending and not self.is_defending then 
            self:follow_player()
        end
    
    elseif self.is_defending then 
        self.is_defending = (game.tick - self.last_attack_tick) < 60
    end

end

return DefenderGroup