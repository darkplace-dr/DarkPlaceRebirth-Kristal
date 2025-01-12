local LightArena, super = Class(Object, "LightArena")

function LightArena:init(x, y, shape)
    super.init(self, x, y, shape)

    self:setOrigin(0.5, 1)

    self.x = math.floor(self.x)
    self.y = math.floor(self.y)

    self.collider = ColliderGroup(self)

    self.line_width = 5 -- You must call setShape if you change this.
    self:setShape(shape or {{0, 0}, {565, 0}, {565, 130}, {0, 130}})

    self.init_width = self.width
    self.init_height = self.height

    self.color = {1, 1, 1}
    self.bg_color = {0, 0, 0}

    self.sprite = ArenaSprite(self)
    self.sprite.color = {0, 0, 0, 0}
    self.sprite.layer = BATTLE_LAYERS["below_ui"]
    self:addChild(self.sprite)

    self.sprite_border = ArenaSprite(self)
    self.sprite_border.background = false
    self.sprite_border.layer = BATTLE_LAYERS["above_bullets"]
    Game.battle:addChild(self.sprite_border)

    self.mask = ArenaMask(1, 0, 0, self)
    self.mask.layer = BATTLE_LAYERS["above_ui"]
    self:addChild(self.mask)

    self.target_size = nil
    self.target_position = nil

    self.target_size_callback = nil
    self.target_position_callback = nil
end

function LightArena:disable()
    self.collidable = false
    self.active = false
    self.visible = false
    self.sprite_border.visible = false
end

function LightArena:enable()
    self.collidable = true
    self.active = true
    self.visible = true
    self.sprite_border.visible = true
end

function LightArena:isResizing()
    return not not self.target_size
end

function LightArena:isMoving()
    return not not self.target_position
end

function LightArena:resetSize(after)
    self:setTargetSize(self.init_width, self.init_height, after)
end

function LightArena:resetPosition(after)
    self:setTargetPos(self.init_x, self.init_y, after)
end

function LightArena:setTargetSize(tw, th, after)
    self.target_size = {width = tw or self.width, height = th or self.height}
    self.target_size_callback = after or function() end
end

function LightArena:setTargetPos(tx, ty, after)
    self.target_position = {x = tx or self.x, y = ty or self.y}
    self.target_position_callback = after or function() end
end

function LightArena:setSize(width, height)
    self:setShape{{0, 0}, {width, 0}, {width, height}, {0, height}}
end

function LightArena:setShape(shape)
    self.shape = Utils.copy(shape, true)
    self.processed_shape = Utils.copy(shape, true)
    
    local min_x, min_y, max_x, max_y
    for _,point in ipairs(self.shape) do
        min_x, min_y = math.min(min_x or point[1], point[1]), math.min(min_y or point[2], point[2])
        max_x, max_y = math.max(max_x or point[1], point[1]), math.max(max_y or point[2], point[2])
    end
    for _,point in ipairs(self.shape) do
        point[1] = point[1] - min_x
        point[2] = point[2] - min_y
    end
    self.width = max_x - min_x
    self.height = max_y - min_y

    self.processed_width = self.width
    self.processed_height = self.height

    self.left = math.floor(self.x - self.width / 2)
    self.right = math.floor(self.x + self.width / 2)
    self.top = math.floor(self.y - self.height)
    self.bottom = math.floor(self.y)

    self.triangles = love.math.triangulate(Utils.unpackPolygon(self.shape))

    self.border_line = {Utils.unpackPolygon(Utils.getPolygonOffset(self.shape, self.line_width/2))}

    self.clockwise = Utils.isPolygonClockwise(self.shape)

    self.area_collider = PolygonCollider(self, Utils.copy(shape, true))

    self.collider.colliders = {}
    for _,v in ipairs(Utils.getPolygonEdges(self.shape)) do
        table.insert(self.collider.colliders, LineCollider(self, v[1][1], v[1][2], v[2][1], v[2][2]))
    end
end

function LightArena:setBorderColor(r, g, b, a)
    self.border.color = {r, g, b, a or 1}
end

function LightArena:setBackgroundColor(r, g, b, a)
    self.bg_color = {r, g, b, a or 1}
end

function LightArena:getBorderColor()
    return self.border.color
end

function LightArena:getBackgroundColor()
    return self.bg_color
end

function LightArena:getCenter()
    return self:getRelativePos(self.width/2, self.height/2)
end

function LightArena:getTopLeft() return self:getRelativePos(0, 0) end
function LightArena:getTopRight() return self:getRelativePos(self.width, 0) end
function LightArena:getBottomLeft() return self:getRelativePos(0, self.height) end
function LightArena:getBottomRight() return self:getRelativePos(self.width, self.height) end

function LightArena:getLeft() local x, y = self:getTopLeft(); return x end
function LightArena:getRight() local x, y = self:getBottomRight(); return x end
function LightArena:getTop() local x, y = self:getTopLeft(); return y end
function LightArena:getBottom() local x, y = self:getBottomRight(); return y end

function LightArena:updateTransition()
    if self:isResizing() then
        if self.width ~= self.target_size.width then
            local new_width = Utils.approach(self.width, self.target_size.width, DTMULT * 30)
            self:setSize(new_width, self.height)
        end

        if self.height ~= self.target_size.height then
            local new_height = Utils.approach(self.height, self.target_size.height, DTMULT * 30)
            self:setSize(self.width, new_height)
        end

        if self.width == self.target_size.width and self.height == self.target_size.height then
            self:setSize(self.target_size.width, self.target_size.height)
            self.target_size = nil

            if self.target_size_callback then
                self.target_size_callback()
                self.target_size_callback = nil
            end
        end
    end

    if self:isMoving() then
        if self.x ~= self.target_position.x then
            self.x = Utils.approach(self.x, self.target_position.x, math.ceil(DTMULT * 15))
        end

        if self.y ~= self.target_position.y then
            self.y = Utils.approach(self.y, self.target_position.y, math.ceil(DTMULT * 15))
        end

        if self.x == self.target_position.x and self.y == self.target_position.y then
            self:setSize(self.width, self.height) -- needs to be called so top, bottom, left, and right work

            self.x = self.target_position.x
            self.y = self.target_position.y

            self.target_position = nil

            if self.target_position_callback then
                self.target_position_callback()
                self.target_position_callback = nil
            end
        end
    end
end

function LightArena:update()
    self:updateTransition()

    if not Utils.equal(self.processed_shape, self.shape, true) then
        self:setShape(self.shape)
    elseif self.processed_width ~= self.width or self.processed_height ~= self.height then
        self:setSize(self.width, self.height)
    end

    local x, y = self:getRelativePos()
    self.sprite_border:setPosition(math.ceil(x), math.ceil(y)) 
    
    super.update(self)

    if not Game.battle then return end
    if NOCLIP then return end

    local soul = Game.battle.soul
    if soul and Game.battle.soul.collidable then
        Object.startCache()
        local angle_diff = self.clockwise and -(math.pi/2) or (math.pi/2)
        for _,line in ipairs(self.collider.colliders) do
            local angle
            while soul:collidesWith(line) do
                if not angle then
                    local x1, y1 = self:getRelativePos(line.x, line.y, Game.battle)
                    local x2, y2 = self:getRelativePos(line.x2, line.y2, Game.battle)
                    angle = Utils.angle(x1, y1, x2, y2)
                end
                Object.uncache(soul)
                soul:setPosition(
                    soul.x + (math.cos(angle + angle_diff)),
                    soul.y + (math.sin(angle + angle_diff))
                )
            end
        end
        Object.endCache()
    end
end

function LightArena:drawMask()
    love.graphics.push()
    self.sprite:preDraw()
    self.sprite:drawBackground()
    self.sprite:postDraw()
    love.graphics.pop()
end

function LightArena:draw()
    super.draw(self)

    if DEBUG_RENDER and self.collider then
        self.collider:draw(0, 0, 1)
    end
end

return LightArena