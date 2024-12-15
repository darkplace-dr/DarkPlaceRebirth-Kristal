-- Various metatable tweaks

local string_metatable = getmetatable(" ")

-- "string" + "string2"
string_metatable.__add = function (a, b) return a .. tostring(b) end

-- "string" * number
string_metatable.__mul = function (a, b)
    local result = ""
    for i = 1, b do
        result = result .. a
    end
    return result
end

-- ("string")[1]
string_metatable.__index = function (a, b)
    if type(b) == "number" then
        return string.sub(a, b, b)
    else
        return string[b]
    end
end

-- "string is " .. true
-- "string" .. {1, 2, 3}
-- "string" .. Sprite()
string_metatable.__concat = function (a, b)
    -- Do not allow nil to be concatenated
    if type(a) == "nil" or type(b) == "nil" then
        return error("attempt to concatenate a nil value")
    end

    -- Handle the a value
    -- If it's a class, concatenate its name
    if isClass(a) then
        a = Utils.getClassName(a)
    -- If it's a table, dump it
    elseif type(a) == "table" then
        a = Utils.dump(a)
    -- If all fails, just convert it to a string
    else
        a = tostring(a)
    end

    -- Handle the b value
    -- If it's a class, concatenate its name
    if isClass(b) then
        b = Utils.getClassName(b)
    -- If it's a table, dump it
    elseif type(b) == "table" then
        b = Utils.dump(b)
    -- If all fails, just convert it to a string
    else
        b = tostring(b)
    end

    return a..b
end