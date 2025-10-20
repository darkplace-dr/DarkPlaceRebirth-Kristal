---@class CodeBlock.error : CodeBlock
local block, super = Class(CodeBlock, "error")

function block:init()
    super.init(self)
    self.text = "Error"
    self.description = "Immediately errors the code. Useful for testing."
end

function block:run(scope)
    error("Error called!")
end

return block