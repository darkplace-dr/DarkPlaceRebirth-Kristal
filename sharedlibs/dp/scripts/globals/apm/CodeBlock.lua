---@class CodeBlock: Class
---@overload fun():CodeBlock
local CodeBlock, super = Class()

function CodeBlock:init()
    super.init(self)
    ---@type CodeBlock[]
    self.children = {}
    self.has_children = getmetatable(self) == CodeBlock
    self.text = "Do"
end

---@return any?
function CodeBlock:run(scope)
    scope = Utils.copy(scope)
    for _, block in ipairs(self.children) do
        block:fullRun(scope)
    end
end

---@return any?
function CodeBlock:fullRun(scope)
    return self:run(scope)
end

function CodeBlock:save()
    local data = {
        id = self.id,
        children = {}
    }
    for _, block in ipairs(self.children) do
        table.insert(data.children, block:save())
    end
    if #data.children == 0 then data.children = nil end
    self:onSave(data)
    return data
end

function CodeBlock:onSave(data) end

function CodeBlock:load(data)
    print("load:", Utils.dump(data))
    self.children = {}
    for _, value in pairs(data.children or {}) do
        self:addBlock(value.id):load(value)
    end
    self:onLoad(data)
end

function CodeBlock:onLoad(data) end

function CodeBlock:addBlock(block, pos)
    if type(block) == "string" then
        block = DP:createCodeblock(block)
    end
    print(Utils.dump(block))
    if pos then
        table.insert(self.children, pos, block)
    else
        table.insert(self.children, block)
    end
    return block
end

return CodeBlock