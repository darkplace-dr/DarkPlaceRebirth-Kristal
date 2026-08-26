
---@class MatrixUtils
local MatrixUtils = {}

---@private
MatrixUtils.TEMP_TRANSFORM = love.math.newTransform()

---@param matrix Matrix4x4
---@param transform love.Transform
function MatrixUtils.applyToTransform(matrix, transform)
    MatrixUtils.TEMP_TRANSFORM:setMatrix("row", matrix)
    transform:apply(MatrixUtils.TEMP_TRANSFORM)
    return transform
end

return MatrixUtils
