---@class CodeBlock.skip : CodeBlock
local block, super = Class(CodeBlock, "skip")

function block:init()
    super.init(self)
    self.text = "Skip turn"
    self.description = "Skips the APM's turn. (This automatically happens if nothing is returned.)"
end

function block:run(scope)
    return {"SKIP", nil, nil, nil}
end

return block