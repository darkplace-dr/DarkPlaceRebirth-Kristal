---@class CodeBlock.safelua : CodeBlock.run_lua
local block, super = Class("run_lua")

function block:init()
    super.init(self)
    self.text = "Lua: [literal:sourcecode,string]"
end

function block:createEnv(scope)
    local function protected(t)
        if type(t) ~= "table" then return t end
        if type(t) == "function" then return end
        return setmetatable({
            math = math,
            love = {math = love.math},
        }, {
            __index = function (_, k)
                print("indexing " .. tostring(k))
                print("returning protected ".. (tostring(t[k])))
                return protected(t[k])
            end
        })
    end
    return setmetatable({}, {
        __index = function (_, k)
            if scope[k] ~= nil then return scope[k] end
            return protected(_G)[k]
        end,
    })
end

return block