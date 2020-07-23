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

function tableContainsValue(table, value)

    for key, tableValue in pairs(table) do
        if tableValue == value or key == value then
            return key
        end
    end

    return false

end

function removeValueFromTable(table, value)

    local key = tableContainsValue(table, value)

    if key then
        table[key] = nil
    end

end

function getDistance(pos1, pos2) 

    local pxpx = pos1.x - pos2.x
    local pypy = pos1.y - pos2.y

    return (pxpx * pxpx + pypy * pypy) ^ 0.5

end