---@class CodeBlock.act : CodeBlock
local block, super = Class(CodeBlock, "act")

function block:init()
    super.init(self)
    self.target = DP:createCodeblock("literal")
    self.target.value = 1
    self.text = "X-ACT on enemy #[expr:target]"
end

function block:run(scope)
    return {"ACT", assert(Game.battle.enemies[self.target:run(scope)], "Enemy " .. self.target.value .. " not found."), nil, {name = "Standard"}}
end

function block:onSave(data)
    data.target = self.target and self.target:save() or nil
end

function block:onLoad(data)
    if data.target then
        self.target = DP:createCodeblock(data.target.id, data.target)
    end
end

return block