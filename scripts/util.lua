local util = {}

util.get_group = function(table, player_index, surface_index)

    for _, group in pairs(table) do 
        if group.player.index == player_index and group.surface.index == surface_index then 
            return group 
        end
    end

    return nil

end

util.table_contains_value = function(table, value)

    for key, tableValue in pairs(table) do 
        if key == value or tableValue == value then 
            return key
        end
    end

    return false

end

util.create_exclude_list = function(defenceExcludeList)

    --reset list
    defenceExcludeList = {}

    for entry in string.gmatch(settings.global["defence-exclude-list"].value, "[^.]+") do 
        defenceExcludeList[entry] = true 
    end

end

util.angle = function(pos1, pos2)

    local dx = (pos2[1] or pos2.x) - (pos1[1] or pos1.x)
    local dy = (pos2[2] or pos2.y) - (pos1[2] or pos1.y)

    return math.atan2(dy, dx)

end

util.rotate_vector = function(vector, orientation)

    local x = vector[1] or vector.x
    local y = vector[2] or vector.y

    local angle = (orientation) * math.pi * 2
    
    return {
        x = (math.cos(angle) * x) - (math.sin(angle) * y),
        y = (math.sin(angle) * x) + (math.cos(angle) * y)
    }
end

util.get_offset = function(current_position, target_position, length, angle_adjustment)

    local angle = util.angle(current_position, target_position)
    angle = angle + (math.pi / 2) + (angle_adjustment or 0)

    local x1 = (length * math.sin(angle))
    local y1 = (-length * math.cos(angle))

    return {x1, y1}

end

util.get_distance = function(pos1, pos2)
    local pxpx = pos1.x - pos2.x
    local pypy = pos1.y - pos2.y

    return (pxpx * pxpx + pypy * pypy) ^ 0.5
end

util.same_position = function(pos1, pos2)
    if pos1.x == pos2.x and pos1.y == pos2.y then 
        return true
    else
        return false
    end
end

util.get_closest = function(pos, table)

    local x, y = pos.x, pos.y 
    local closest = MAX_INT32
    local entity

    for _, value in pairs(table) do 
        if value.valid then 
            local distance = util.get_distance(pos, value.position)

            if distance < closest then 
                x, y = value.position.x, value.position.y1
                closest = distance 
                entity = value
            end
        end
    end

    return entity

end

return util