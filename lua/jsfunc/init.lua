require("jsfunc.luaspecial")
local function iter_to_array(iter)
    local arr = {}
    local item = nil
    while true do
        item = iter()
        if item == nil then
            break
        end
        table.insert(arr, item)
    end
    return arr
end
function string:split(separator)
    local t = {}
    local items =
        iter_to_array(
        (function()
            local __tmp = self
            return __tmp:gmatch(string.format([=[[^%s]+]=], separator))
        end)()
    )
    do
        local i = 0
        while i < #items do
            table.insert(t, items[i + 1])
            local _null
            (function()
                i = i + 1
                return i
            end)()
        end
    end
    return t
end
function string:contains(pattern)
    return (function()
        local __tmp = self
        return __tmp:find(pattern, 1, true)
    end)() ~= nil
end
function string:starts_with(pattern)
    return (function()
        local __tmp = self
        return __tmp:sub(1, #pattern)
    end)() == pattern
end
function string:ends_with(pattern)
    return pattern == "" or (function()
            local __tmp = self
            return __tmp:sub(-(#pattern))
        end)() == pattern
end
function string:replace(pattern, replacement)
    local str = self
    local search_start_idx = 1
    local idx = pack2(str:find(pattern, search_start_idx, true))
    if not idx[1] then
        return str
    end
    local postfix = str:sub(idx[2] + 1)
    str = string.format([=[%s%s%s]=], str:sub(1, idx[1] - 1), replacement, postfix)
    return str
end
function string:replace_all(pattern, replacement)
    local str = self
    local search_start_idx = 1
    while true do
        local idx = pack2(str:find(pattern, search_start_idx, true))
        if not idx[1] then
            break
        end
        local postfix = str:sub(idx[2] + 1)
        str = string.format([=[%s%s%s]=], str:sub(1, idx[1] - 1), replacement, postfix)
        search_start_idx = -1 * postfix:len()
    end
    return str
end
function string:insert(pos, text)
    return string.format(
        [=[%s%s%s]=],
        (function()
            local __tmp = self
            return __tmp:sub(1, pos - 1)
        end)(),
        text,
        (function()
            local __tmp = self
            return __tmp:sub(pos)
        end)()
    )
end
string["repeat"] = function(self, count)
    local out = ""
    do
        local i = 0
        while i < count do
            out = string.format([=[%s%s]=], out, self)
            local _null
            (function()
                i = i + 1
                return i
            end)()
        end
    end
    return out
end
table.shift = function(tbl)
    table.remove(tbl, 1)
end
table.pop = function(tbl)
    table.remove(tbl)
end
table.map = function(sequence, transformation)
    local newlist = {}
    do
        local i = 0
        while i < #sequence do
            table.insert(newlist, transformation(sequence[i + 1]))
            local _null
            (function()
                i = i + 1
                return i
            end)()
        end
    end
    return newlist
end
table.filter = function(sequence, predicate)
    local newlist = {}
    do
        local i = 0
        while i < #sequence do
            if predicate(sequence[i + 1]) then
                table.insert(newlist, sequence[i + 1])
            end
            (function()
                i = i + 1
                return i
            end)()
        end
    end
    return newlist
end
table.reduce = function(sequence, operator)
    if #sequence == 0 then
        return nil
    end
    local out = nil
    do
        local i = 0
        while i < #sequence do
            out = operator(out, sequence[i + 1])
            local _null
            (function()
                i = i + 1
                return i
            end)()
        end
    end
    return out
end

