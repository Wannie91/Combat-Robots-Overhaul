local util = {

    -- from http://lua-users.org/wiki/CopyTable
    shallowcopy = function (orig)
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

    end,

    getDistance = function(pos1, pos2)
        local pxpx = pos1.x - pos2.x
        local pypy = pos1.y - pos2.y
    
        return (pxpx * pxpx + pypy * pypy) ^ 0.5
    end,

    samePosition = function(pos1, pos2)
        if pos1.x == pos2.x and pos1.y == pos2.y then 
            return true
        else
            return false
        end
    end,

    createDefenceExcludeList = function(defenceExcludeList)

        --reset defenceExcludeList
        defenceExcludeList = {}

        for entry in string.gmatch(settings.global["defence-exclude-list"].value, "[^.]+") do 
            defenceExcludeList[entry] = true
        end

    end,

    tableContainsValue = function(table, value) 

        for key, tableValue in pairs(table) do 
            if tableValue == value or key == value then 
                return key 
            end
        end

        return false

    end,
}

return util
