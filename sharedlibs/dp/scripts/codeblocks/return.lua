---@class CodeBlock.return : CodeBlock
local block, super = Class(CodeBlock, "return")

function block:init()
    super.init(self)
    ---@type CodeBlock
    self.expr = nil
    self.text = "Return [expr:expr]"
    self.description = "Returns the result of an expression. When used at the top-level (outside of a custom function), runs a battle action."
end

function block:run(scope)
    if self.expr then
        coroutine.yield(self.expr:fullRun(scope))
    else
        coroutine.yield()
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