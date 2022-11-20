local util = require("util")
local BaseGroup = require("basegroup")

local DefenderGroup = {}
setmetatable(DefenderGroup, {__index = BaseGroup})

function DefenderGroup:new(player)

    local defenderGroup = BaseGroup:new(player)

    setmetatable(defenderGroup, {__index = DefenderGroup})
    return defenderGroup 

end

function DefenderGroup:add_member(entity)

    BaseGroup.add_member(self, entity)

    if self:get_member_count() > 0 then 
        self.player.set_shortcut_available("defend-player", true)
    end

end

function DefenderGroup:remove_member(entity)

    BaseGroup.remove_member(self, entity)

    if not self:has_members() and self.player.surface.index == self.surface.index then 
        self.player.set_shortcut_available("defend-player", false)
    end

end

function DefenderGroup:stop_following_player()

    for _, member in pairs(self.members) do 
        member.follow_target = nil 
        member.autopilot_destination = nil
    end

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

    if distance > 1000 then 
        return (distance / 250) 
    elseif distance > 600 then 
        return (distance / 200)
    elseif distance > 100 then 
        return (distance / 50)
    end

    return 1
    -- local boost = distance / 50

    -- return boost

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

    for _, member in pairs(self.members) do 
        if member.valid then 
            count = count + 1 
            followers[count] = member
        end
    end

    if count == 0 then return end 

    local length = math.max(5 + (count * 0.33), self.player.mod_settings["defender-distance"].value)
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
        self:set_member_speed(follower, player_speed + self:get_distance_boost(follower.position, follower.autopilot_destination))
        self.last_update_tick = game.tick

    end

end

function DefenderGroup:defend_base(attacking_entity)

    if self.player.is_shortcut_toggled("defend-player") or (self:valid_entity(self.current_target) and self.current_target == attacking_entity) or not self:has_members() then return end 
    
    local distance_to_target = util.get_distance(attacking_entity.position, self.group_position) 

    if distance_to_target < settings.global["base-defence-perimeter"].value and (not self:valid_entity(self.current_taret) or distance_to_target < util.get_distance(self.current_target.position, self.group_position)) then 
 
        self:move_to_target(attacking_entity) 
        
        for _, member in pairs(self.members) do 
            if member.autopilot_destination then 
                self:set_member_speed(member, member.speed + self:get_distance_boost(member.position, member.autopilot_destination))
            end
        end
    end

end

function DefenderGroup:update()

    self:get_group_position()

    local was_attacking = self.is_attacking
    self.is_attacking = (game.tick - self.last_attack_tick) < 60

    if self:has_members() and was_attacking and not self.is_attacking then 
        self:search_for_enemy_near_position(self.group_position, 32)
        for _, member in pairs(self.members) do 
            if member.speed > 0.25 then 
                self:set_member_speed(member, 0.25)
            end
        end
    end

    if was_attacking and self.is_attacking then return end 

    if self.player.is_shortcut_toggled("defend-player") and self.player.surface.index == self.surface.index and self:has_members() then 

        self:search_for_enemy_near_position(self.player.position, 32)

        if not was_attacking and not self.is_attacking then 
            self:follow_player()
        end    
    elseif self.is_moving and self:valid_entity(self.current_target) and util.get_distance(self.group_position, self.current_target.position) <= 48 and self:has_members() then 
        self:search_for_enemy_near_position(self.group_position, 48)
    end

end

return DefenderGroup