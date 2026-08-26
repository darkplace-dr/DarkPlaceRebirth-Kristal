local Matrix4x4 = modRequire('libraries.lz3d.src.Matrix4x4')
---@class Transform3D : Class
---@field private _rotation_x number
---@field private _rotation_y number
---@field private _rotation_z number
---@field private _scale_x number
---@field private _scale_y number
---@field private _scale_z number
---@field private _x number
---@field private _y number
---@field private _z number
---@field private _cached_transform Matrix4x4?
---@overload fun(x: number, y: number, z: number): Transform3D
local Transform3D = Class(nil, "Transform3D")

Transform3D._rotation_x = 0.0
Transform3D._rotation_y = 0.0
Transform3D._rotation_z = 0.0
Transform3D._scale_x = 1.0
Transform3D._scale_y = 1.0
Transform3D._scale_z = 1.0
Transform3D._x = 0.0
Transform3D._y = 0.0
Transform3D._z = 0.0

---@param x number
---@param y number
---@param z number
function Transform3D:init(x, y, z)
    self._x = x
    self._y = y
    self._z = z
end

---@return Matrix4x4
function Transform3D:getMatrix()
    if self._cached_transform then
        return self._cached_transform
    end
    self._cached_transform = self:createMatrix()
    return self._cached_transform
end

---@return Matrix4x4
function Transform3D:createMatrix()
    local m1 = Matrix4x4()
    local m2 = Matrix4x4()

    -- Translation
    m2:setAll(
        1, 0, 0, self:getX(),
        0, 1, 0, self:getY(),
        0, 0, 1, self:getZ(),
        0, 0, 0, 1
    )
    m1:apply(m2)

    -- Rotation (X)
    m2:setAll(
        1, 0, 0, 0,
        0, math.cos(math.rad(self:getRotationX())), -math.sin(math.rad(self:getRotationX())), 0,
        0, math.sin(math.rad(self:getRotationX())), math.cos(math.rad(self:getRotationX())), 0,
        0, 0, 0, 1
    )
    m1:apply(m2)

    -- Rotation (Y)
    m2:setAll(
        math.cos(math.rad(self:getRotationY())), 0, math.sin(math.rad(self:getRotationY())), 0,
        0, 1, 0, 0,
        -math.sin(math.rad(self:getRotationY())), 0, math.cos(math.rad(self:getRotationY())), 0,
        0, 0, 0, 1
    )
    m1:apply(m2)

    -- Rotation (Z)
    m2:setAll(
        math.cos(math.rad(self:getRotationZ())), -math.sin(math.rad(self:getRotationZ())), 0, 0,
        math.sin(math.rad(self:getRotationZ())), math.cos(math.rad(self:getRotationZ())), 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    )
    m1:apply(m2)

    -- Scale
    m2:setAll(
        self:getScaleX(), 0,0,0,
        0, self:getScaleY(), 0, 0,
        0, 0, self:getScaleZ(), 0,
        0, 0, 0, 1
    )
    m1:apply(m2)


    return m1
end

function Transform3D:markTransformDirty()
    self._cached_transform = nil
end

---@param rotation number Degrees
function Transform3D:setRotationX(rotation)
    self._rotation_x = rotation
    self:markTransformDirty()
end

function Transform3D:getRotationX()
    return self._rotation_x
end

---@param rotation number Degrees
function Transform3D:setRotationY(rotation)
    self._rotation_y = rotation
    self:markTransformDirty()
end

function Transform3D:getRotationY()
    return self._rotation_y
end

---@param rotation number Degrees
function Transform3D:setRotationZ(rotation)
    self._rotation_z = rotation
    self:markTransformDirty()
end

function Transform3D:getRotationZ()
    return self._rotation_z
end

---@param scale number
function Transform3D:setScaleX(scale)
    self._scale_x = scale
    self:markTransformDirty()
end

function Transform3D:getScaleX()
    return self._scale_x
end

---@param scale number
function Transform3D:setScaleY(scale)
    self._scale_y = scale
    self:markTransformDirty()
end

function Transform3D:getScaleY()
    return self._scale_y
end

---@param scale number
function Transform3D:setScaleZ(scale)
    self._scale_z = scale
    self:markTransformDirty()
end

function Transform3D:getScaleZ()
    return self._scale_z
end

---@param x number
function Transform3D:setX(x)
    self._x = x
    self:markTransformDirty()
end

function Transform3D:getX()
    return self._x
end

---@param y number
function Transform3D:setY(y)
    self._y = y
    self:markTransformDirty()
end

function Transform3D:getY()
    return self._y
end

---@param z number
function Transform3D:setZ(z)
    self._z = z
    self:markTransformDirty()
end

function Transform3D:getZ()
    return self._z
end

return Transform3D
