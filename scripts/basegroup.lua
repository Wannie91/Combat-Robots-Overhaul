local BaseGroup = {}

-- BaseGroup.metatable = {__index = BaseGroup}

function BaseGroup:new(player)

    local group = 
    {
        player = player,
        surface = true,
        group_members = {},
        group_position = {x = 0, y = 0},
        created_tick = game.tick,
        last_update_tick = 0,
        last_attack_tick = 0, 
    }

    setmetatable(group, {__index = BaseGroup})
    return group

end

function BaseGroup:add_member(entity)

    if not self:has_members() then 
        self.surface = entity.surface
        self.group_position = entity.position 
    end

    self.group_members[entity.unit_number] = entity 
    self.last_update_tick = game.tick 

end

function BaseGroup:remove_member(entity)

    self.group_members[entity.unit_number] = nil 

    if not self:has_members() then 
        self.player.print({"messages.group-destroyed", entity.name, string.format("[gps= %d, %d]", self.group_position.x, self.group_position.y)})
    end

    -- self.last_update_tick = game.tick 

end

function BaseGroup:get_group_position()

    local count = 0 
    local position = {x = 0, y = 0}

    for _, member in pairs(self.group_members) do 
        position.x = position.x + member.position.x
        position.y = position.y + member.position.y

        count = count + 1
    end

    self.group_position = {x = (position.x / count), y = (position.y / count)}
    return self.group_position
end

function BaseGroup:get_member_count()

    local count = 0
     
    for _, member in pairs (self.group_members) do
        if member.valid then 
            count = count + 1
        end
    end

    return count 

end

function BaseGroup:has_members()

    if not next(self.group_members) then 
        return false 
    end

    return true

end

return BaseGroup