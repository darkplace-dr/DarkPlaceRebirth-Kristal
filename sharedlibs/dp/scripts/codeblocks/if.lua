---@class CodeBlock.if : CodeBlock
local block, super = Class(CodeBlock, "if")

function block:init()
    super.init(self)
    self.has_children = true
    self.expr = DP:createCodeblock("literal")
    self.expr.value = true
    self.text = "If [expr:expr] then"
end

function block:run(scope)
    if self.expr:run(scope) then
        super.run(self, scope)
        return true
    end
end

function block:onSave(data)
    data.expr = self.expr and self.expr:save() or nil
end

function block:onLoad(data)
    if data.expr then
        self.expr = DP:createCodeblock(data.expr.id, data.expr)
    end
end

return block