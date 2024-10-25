local BaseGroup = require("basegroup")
local util = require("util")

local SentryGroup = {}
setmetatable(SentryGroup, {__index = BaseGroup})

SentryGroup.metatable = {__index = SentryGroup}

function SentryGroup:new(player)

    local sentryGroup = BaseGroup:new(player)

    setmetatable(sentryGroup, SentryGroup.metatable)
    return sentryGroup

end

function SentryGroup:add_member(entity)

    BaseGroup.add_member(self, entity)
    entity.commandable.set_command({ type = defines.command.wander, radius = settings.global["sentry-radius"].value, distraction = defines.distraction.by_enemy })

end

function SentryGroup:remove_member(entity)

    self.members[entity.unit_number] = nil 
    self.last_update_tick = game.tick 

end

return SentryGroup