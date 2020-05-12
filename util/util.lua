MAX_INT32 = 2147483647

local function new(x,y)
    return setmetatable({x = x, y = y})
end

-- from http://lua-users.org/wiki/CopyTable
function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function tableContainsCoordinate(table, paramVal) 
    for _, value in pairs(table) do
        if value.x == paramVal.x and value.y == paramVal.y then
            return true
        end
    end
    return false
end

function tableContainsUnit(table, paramVal)

    for key, _ in pairs(table) do
        if key == paramVal then
            return true
        end
    end
    return false
end

function getKeyForValue(table, paramVal)

    for key, value in pairs(table) do
        if value.x == paramVal.x and value.y == paramVal.y then
            return key
        end
    end
    return nil
end

function getKeyForEntity(table, paramVal)

    for key, value in pairs(table) do
        if key == paramVal then
            return key
        end
    end
    return nil
end

function getDistance(pos1, pos2) 
    local pxpx = pos1.x - pos2.x
    local pypy = pos1.y - pos2.y

    return (pxpx * pxpx + pypy * pypy) ^ 0.5

end

function getClosestCoordinate(pos1, table)
    local x, y = pos1.x, pos1.y
    local closest = MAX_INT32

    for _, pos in pairs(table) do
        local distance = getDistance(pos1, pos)
        if distance < closest then
            x, y = pos.x, pos.y
            closest = distance
        end
    end

    local closestCoordinate = { x = x, y = y }

    return closestCoordinate

end

function getClosestEntity(pos1, table)

    local closest = MAX_INT32
    local returnEntity = ""
    
    for _, entity in pairs(table) do
        if entity.valid then 
            local distance = getDistance(pos1, entity.position)

            if distance < closest then 
                returnEntity = entity
                closest = distance
            end
        end
    end

    return returnEntity
end

        
