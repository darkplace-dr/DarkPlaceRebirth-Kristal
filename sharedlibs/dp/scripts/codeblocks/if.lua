---@class CodeBlock.if : CodeBlock
local block, super = Class(CodeBlock, "if")

function block:init()
    super.init(self)
    self.expr = DP:createCodeblock("literal")
    self.expr.value = true
end

function block:run(scope)
    if self.expr:run(scope) then
        super.run(self, scope)
        return true
    end
end

return block