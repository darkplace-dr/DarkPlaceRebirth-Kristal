---@class CodeBlock.run_lua : CodeBlock
local block, super = Class(CodeBlock, "run_lua")

function block:init()
    super.init(self)
    self.sourcecode = "Game.battle:explode(nil, nil, true)"
end

function block:run(scope)
    local chunk = loadstring(self.sourcecode)
    setfenv(chunk, setmetatable({}, {
        __index = function (_, k)
            if scope[k] ~= nil then return scope[k] end
            return _G[k] -- TODO: Prevent exploit
        end,
    }))
    return chunk()
end

return block