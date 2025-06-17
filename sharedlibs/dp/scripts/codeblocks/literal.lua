---@class CodeBlock.literal : CodeBlock
local block, super = Class(CodeBlock, "literal")

function block:init()
    super.init(self)
    ---@type boolean|string|number
    self.value = "SKIP"
    self.text = "[literal:value,any]"
end

function block:run(scope)
    return self.value
end

function block:onSave(data)
    data.value = self.value
end

function block:onLoad(data)
    self.value = data.value
end

return block