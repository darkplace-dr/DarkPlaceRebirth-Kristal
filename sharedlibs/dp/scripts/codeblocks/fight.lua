---@class CodeBlock.fight : CodeBlock
local block, super = Class(CodeBlock, "fight")

function block:init()
    super.init(self)
    self.target = DP:createCodeblock("literal")
    self.target.value = 1
    self.text = "Attack enemy #[expr:target]"
end

function block:run(scope)
    return {"AUTOATTACK", assert(Game.battle.enemies[self.target:run(scope)], "Enemy " .. self.target.value .. " not found."), nil, {points = 150}}
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