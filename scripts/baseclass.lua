local BaseClass = {}

BaseClass.metatable = {__index = BaseClass}

function BaseClass:new(player)

    local group = {
        player = player,
        members = {[player.surface.index] = {} },
        position = {x = 0, y = 0},
        created_tick = game.tick,
        last_update_tick = game.tick,
    }

    setmetatable(group, BaseClass.metatable)
    return group

end

function BaseClass:destroy()

    for _, group in pairs(self.members) do 
        for _, member in pairs(group) do 
            member.destroy()
        end
    end    
    
end

function BaseClass:add_member(entity)

    self.members[entity.surface.index][entity.unit_number] = entity
    self.last_update_tick = game.tick

end

function BaseClass:remove_member(entity)

    self.members[entity.surface.index][entity.unit_number] = nil
    self.last_update_tick = game.tick

    if not self:has_members() then 
        self.player.print({"messages.combatgroup-destroyed", entity.name, string.format("[gps= %d, %d]", self.position.x, self.position.y)})
    end

end

function BaseClass:has_members(surface_index)

    return next(self.members[surface_index or self.player.surface.index])

end

function BaseClass:get_member_count(surface_index)

    local count = 0

    for _, member in pairs(self.members[surface_index or self.player.surface.index]) do
        count = count + 1
    end

    return count

end

function BaseClass:update_group_position(surface_index)

    local count = 0
    local position = {x = 0, y = 0}

    for _, member in pairs(self.members[surface_index or self.player.surface.index]) do 
        count = count + 1
        position.x = position.x + member.position.x
        position.y = position.y + member.position.y
    end

    self.position = {x = (position.x / count), y = (position.y / count)}

end

function BaseClass:changed_surface()

    if not self.members[self.player.surface.index] then 
        self.members[self.player.surface.index] = {}
    end
    
end

return BaseClass


