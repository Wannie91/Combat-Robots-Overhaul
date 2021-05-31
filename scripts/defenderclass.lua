local BaseClass = require("baseclass")
local util = require("util")

local DefenderClass = {}
setmetatable(DefenderClass, {__index = BaseClass})

function DefenderClass:new(player)

    local defenderGroup = BaseClass:new(player)
    defenderGroup.is_defending = false

    setmetatable(defenderGroup, {__index = DefenderClass})
    return defenderGroup

end

function DefenderClass:add_member(entity)

    BaseClass.add_member(self, entity)

    if self:has_members() then 
        self.player.set_shortcut_available("defend-player", true)
    end

end

function DefenderClass:remove_member(entity)

    BaseClass.remove_member(self, entity)

    if not self:has_members() then 
        self.player.set_shortcut_available("defend-player", false)
    end

end

function DefenderClass:player_changed_surface(old_surface_index)

    self.player_changed_surface()

    for _, member in pairs(self.members[surface_index]) do
        member.follow_target = nil
    end

end

function DefenderClass:update()

    self:update_group_position()

    if self.player.is_shortcut_toggled("defend-player") then --and next(self.members[self.player.surface.index]) then 

       
    end

end

return DefenderClass