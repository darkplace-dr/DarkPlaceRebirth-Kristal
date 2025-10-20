---@class CodeBlock.run_lua : CodeBlock
local block, super = Class(CodeBlock, "run_lua")

function block:init()
    super.init(self)
    self.text = "Unsafely run Lua: [literal:sourcecode,string]"
    self.sourcecode = "Game.battle:explode(nil, nil, true)"
end

function block:createEnv(scope)
    return setmetatable({}, {
        __index = function (_, k)
            if scope[k] ~= nil then return scope[k] end
            return _G[k] -- TODO: Prevent exploit
        end,
    })
end

function block:run(scope)
    local chunk = loadstring("return "..self.sourcecode)
    chunk = chunk or loadstring(self.sourcecode)
    setfenv(chunk, assert(self:createEnv(scope), "no env? :("))
    return chunk()
end

function block:onSave(data)
    data.sourcecode = self.sourcecode
end

function block:onLoad(data)
    self.sourcecode = data.sourcecode
end

return block