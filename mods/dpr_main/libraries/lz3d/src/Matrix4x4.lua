---@class Matrix4x4 : Class
---@field private [1] number
---@field private [2] number
---@field private [3] number
---@field private [4] number
---@field private [5] number
---@field private [6] number
---@field private [7] number
---@field private [8] number
---@field private [9] number
---@field private [10] number
---@field private [11] number
---@field private [12] number
---@field private [13] number
---@field private [14] number
---@field private [15] number
---@field private [16] number
---@overload fun() : Matrix4x4
---@overload fun(xx:number,xy:number,xz:number,xw:number,yx:number,yy:number,yz:number,yw:number,zx:number,zy:number,zz:number,zw:number,wx:number,wy:number,wz:number,ww:number) : Matrix4x4
local Matrix4x4 = Class(nil, "Matrix4x4")

---@private
Matrix4x4.TEMP_TRANSFORM_A = love.math.newTransform()
---@private
Matrix4x4.TEMP_TRANSFORM_B = love.math.newTransform()

function Matrix4x4:init(...)
    TableUtils.merge(self, {
        1, 0, 0, 0;
        0, 1, 0, 0;
        0, 0, 1, 0;
        0, 0, 0, 1;
    })
    if select("#", ...) == 0 then
        return
    elseif select("#", ...) == 16 then
        local copy = {...}
        for i=1,16 do
            self[i] = copy[i]
        end
    else
        error("Bad argument count " .. select("#", ...))
    end
end

---@return self
function Matrix4x4:setAll(...)
    local copy = {...}
    for i=1,16 do
        self[i] = copy[i]
    end
    return self
end

---@param transform love.Transform
function Matrix4x4:setToTransform(transform)
    transform:setMatrix("row", self)
end

function Matrix4x4:applyToTransform(transform)
    Matrix4x4.TEMP_TRANSFORM_A:setMatrix("row", self)
    transform:apply(Matrix4x4.TEMP_TRANSFORM_A)
end

---@param other Matrix4x4
function Matrix4x4:apply(other)
    Matrix4x4.TEMP_TRANSFORM_A:setMatrix("row", self)
    Matrix4x4.TEMP_TRANSFORM_B:setMatrix("row", other)
    Matrix4x4.TEMP_TRANSFORM_A:apply(Matrix4x4.TEMP_TRANSFORM_B)
    local copy = {Matrix4x4.TEMP_TRANSFORM_A:getMatrix()}
    for i=1,16 do
        self[i] = copy[i]
    end
    return self
end

---@return self
function Matrix4x4:inverse()
    -- Because inverting a matrix is H"E"LL
    Matrix4x4.TEMP_TRANSFORM_A:setMatrix("row", self)
    local inverse = Matrix4x4.TEMP_TRANSFORM_A:inverse()
    self:setAll(inverse:getMatrix())
    inverse:release()
    return self
end

---@param x number
---@param y number
---@param z number
---@param w number
---@return number, number, number, number
function Matrix4x4:transformPoint(x,y,z,w)
    return
        x*self:get(1, 1) + y*self:get(2, 1) + z*self:get(3, 1) + w*self:get(4, 1),
        x*self:get(1, 2) + y*self:get(2, 2) + z*self:get(2, 3) + w*self:get(4, 2),
        x*self:get(1, 3) + y*self:get(2, 3) + z*self:get(3, 3) + w*self:get(4, 3),
        x*self:get(1, 4) + y*self:get(2, 4) + z*self:get(3, 4) + w*self:get(4, 4)
end

---@public
---@param x integer
---@param y integer
---@return number
function Matrix4x4:get(x, y)
    return self[x + ((y-1)*4)]
end

---@public
---@param x integer
---@param y integer
---@param value number
function Matrix4x4:set(x,y, value)
    self[x + ((y-1)*4)] = value
end

-- Builders - similar to GameMaker's matrix_build_* functions

function Matrix4x4:buildIdentity()
    for i=1, 4 do
        for j = 1, 4 do
            self[i + ((j-1) * 4)] = (i == j) and 1 or 0
        end
    end
    return self
end

---@return self
function Matrix4x4:buildOrthographicProjection(width, height, clip_near, clip_far)
    self:buildIdentity()
    -- clip_near = -clip_near
    -- clip_far = clip_far + (clip_near * 1.5)
    clip_near, clip_far = clip_far, clip_near
    -- clip_near, clip_far = -clip_far, -clip_near
    self:set(1,1, 2 / width)
    self:set(2, 2, 2 / height)
    self:set(4, 3, -(clip_far+clip_near)/(clip_far-clip_near))
    self:set(3, 3, (-2)/(clip_far - clip_near))
    return self
end

---@return self
function Matrix4x4:build2P5DProjection(width, height, perspective_factor, clip_near, clip_far)
    do
        clip_near = clip_near + ((clip_near * perspective_factor))
        --clip_far = clip_far * (1 + math.abs(clip_far * perspective_factor))
        self:buildOrthographicProjection(
            width, height, clip_near, clip_far
        )
        self:set(3, 4, perspective_factor)
        self:set(3, 2, self:get(3, 2) + 0.005)
        return self
    end
    self:buildIdentity()
    -- clip_near, clip_far = -clip_far, -clip_near
    clip_near = clip_near * ((clip_near + perspective_factor))
    clip_far = clip_far * ((clip_far + perspective_factor))
    -- clip_near = -clip_near
    -- clip_far = clip_far + (clip_near * 1.5)
    self:set(1,1, 2 / width)
    self:set(2, 2, 2 / height)
    self:set(4, 3, -(clip_far+clip_near)/(clip_far-clip_near))
    self:set(3, 4, perspective_factor)
    self:set(3, 3, (-2)/(clip_far - clip_near))
    return self
end

return Matrix4x4
