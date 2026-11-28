---@class BlendMode: Class
---@field love_mode LOVEBlendMode
---@field operationRGB BlendOperation
---@field operationA BlendOperation
---@field srcFactorRGB BlendFactor
---@field srcFactorA BlendFactor
---@field dstFactorRGB BlendFactor
---@field dstFactorA BlendFactor
---@overload fun(operationRGB: BlendOperation, operationA: BlendOperation, srcFactorRGB: BlendFactor, srcFactorA: BlendFactor, dstFactorRGB: BlendFactor, dstFactorA: BlendFactor, love_mode: LOVEBlendMode): BlendMode
---@overload fun(operation: BlendOperation, srcFactor: BlendFactor, dstFactor: BlendFactor, love_mode: LOVEBlendMode): BlendMode
local BlendMode = Class(nil, "BlendMode")

---@param operationRGB BlendOperation
---@param operationA BlendOperation
---@param srcFactorRGB BlendFactor
---@param srcFactorA BlendFactor
---@param dstFactorRGB BlendFactor
---@param dstFactorA BlendFactor
---@param love_mode LOVEBlendMode
---@overload fun(operation: BlendOperation, srcFactor: BlendFactor, dstFactor: BlendFactor): BlendMode
function BlendMode:init(operationRGB, operationA, srcFactorRGB, srcFactorA, dstFactorRGB, dstFactorA, love_mode)
    if type(srcFactorA) == "table" then

        ---@type BlendOperation, BlendFactor, BlendFactor
        local operation, srcFactor, dstFactor = operationRGB, operationA, srcFactorRGB
        love_mode = srcFactorA
        ---@diagnostic disable-next-line
        operationRGB, operationA, srcFactorRGB, srcFactorA, dstFactorRGB, dstFactorA = operation, operation, srcFactor, srcFactor, dstFactor, dstFactor
    end
    self.operationRGB = operationRGB
    self.operationA = operationA
    self.srcFactorRGB = srcFactorRGB
    self.srcFactorA = srcFactorA
    self.dstFactorRGB = dstFactorRGB
    self.dstFactorA = dstFactorA
    self.love_mode = love_mode
end

function BlendMode:__tostring()
    return string.format("BlendMode(%s, %s, %s, %s, %s, %s)", self.operationRGB, self.operationA, self.srcFactorRGB, self.srcFactorA, self.dstFactorRGB, self.dstFactorA)
end

return BlendMode
