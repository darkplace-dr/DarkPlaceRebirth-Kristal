local MatrixUtils = modRequire('libraries.lz3d.src.MatrixUtils')
local Matrix4x4 = modRequire("libraries.lz3d.src.Matrix4x4")
---@class Graphics
local Graphics = {}

Graphics.depth_buffer = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT, {
    format = "depth32f",
    readable = true,
})

---@private
Graphics.object_matrix = Matrix4x4()

---@private
Graphics.view_matrix = Matrix4x4()

---@private
Graphics.projection_matrix = (Matrix4x4():buildOrthographicProjection(
    1, 1,
    -0, 5
))

-- Graphics.projection_matrix:set(3, 4, 0.002)
Graphics.projection_matrix:set(3, 2, -1)

---@private
Graphics.TEMP_TRANSFORM = love.math.newTransform()

Graphics.COUNTER_VIEWPROJECTION = (function()
    local m1 = Matrix4x4()
    local m2 = Matrix4x4()

    -- m2:setAll(unpack {
    --     1, 0, 0, SCREEN_WIDTH/2,
    --     0, 1, 0, SCREEN_HEIGHT/2,
    --     0, 0, 1, 1,
    --     0, 0, 0, 1
    -- })
    -- m1:apply(m2)

    m2:setAll(
        1, 0, 0, 0,
        0, -1, 0, 0,
        0, 0, -10, 00,
        0, 0, 0, 1
    )
    m1:apply(m2)

    -- m2:setAll(
    --     SCREEN_WIDTH/2, 0, 0, 0,
    --     0, SCREEN_HEIGHT/2, 0, 0,
    --     0, 0, 1, 0,
    --     0, 0, 0, 1
    -- )
    -- m1:apply(m2)

    return m1
end)()

---@param matrix Matrix4x4
function Graphics.applyMatrix(matrix)
    Graphics.TEMP_TRANSFORM:setMatrix("row", matrix)
    local transform = love.graphics.getTransformRef() ---@as love.Transform
    MatrixUtils.applyToTransform(matrix, transform)
    love.graphics.replaceTransform(transform)
end

local love12 = love.getVersion() >= 12 and false
function Graphics.updateTransform()
    Graphics.TEMP_TRANSFORM:reset()
    if love12 then
        love.graphics.setProjection("row", Graphics.projection_matrix)
    else
        Graphics.COUNTER_VIEWPROJECTION:applyToTransform(Graphics.TEMP_TRANSFORM)
        Graphics.TEMP_TRANSFORM:translate(SCREEN_WIDTH/2, -SCREEN_HEIGHT/2)
        Graphics.TEMP_TRANSFORM:scale(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        Graphics.projection_matrix:applyToTransform(Graphics.TEMP_TRANSFORM)
    end
    Graphics.view_matrix:applyToTransform(Graphics.TEMP_TRANSFORM)
    Graphics.object_matrix:applyToTransform(Graphics.TEMP_TRANSFORM)
    love.graphics.replaceTransform(Graphics.TEMP_TRANSFORM)
end

---@param matrix Matrix4x4
function Graphics.setObjectMatrix(matrix)
    Graphics.object_matrix = matrix
    Graphics.updateTransform()
end

---@param matrix Matrix4x4
function Graphics.setViewMatrix(matrix)
    Graphics.view_matrix = matrix
    Graphics.updateTransform()
end

---@param matrix Matrix4x4
function Graphics.setProjectionMatrix(matrix)
    Graphics.projection_matrix = matrix
    Graphics.updateTransform()
end

return Graphics
