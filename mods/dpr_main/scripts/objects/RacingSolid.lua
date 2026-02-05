local RacingSolid, super = Class(Object)

function RacingSolid:init(x, y, width, height)
    super.init(self, x, y, width, height)

    self.layer = WORLD_LAYERS["top"]

    if width and height then
        self:setHitbox(0, 0, width, height)
    end

	self.alpha = 0.5
	self.color = {0, 0, 1}
end

function RacingSolid:move(x, y, speed)
    local movex, movey = x * (speed or 1), y * (speed or 1)

    Object.startCache()
    local collided_x = self:doMoveAmount(movex, 1, 0)
    local collided_y = self:doMoveAmount(movey, 0, 1)
    Object.endCache()

    return collided_x or collided_y
end

function RacingSolid:moveTo(x, y)
    return self:move(x - self.x, y - self.y)
end

function RacingSolid:doMoveAmount(amount, x_mult, y_mult)
    local sign = MathUtils.sign(amount)

    local car_collided = false

    Object.startCache()
    for i = 1, math.ceil(math.abs(amount)) do
        local moved = sign
        if (i > math.abs(amount)) then
            moved = (math.abs(amount) % 1) * sign
        end

        self.x = self.x + (moved * x_mult)
        self.y = self.y + (moved * y_mult)
        Object.uncache(self)

        for _, soul in ipairs(self.stage:getObjects(Soul)) do
            if self:collidesWith(soul) then
                soul_collided = true

                self.collidable = false
                local _, collided = soul:move(sign * x_mult, sign * y_mult)
                Object.uncache(soul)
                if collided then
                    soul:onSquished(self)
                end
                self.collidable = true
            end
        end
    end
    Object.endCache()

    return car_collided
end

function RacingSolid:onCollide()
	if self.parent.car.sfx_buffer_timer <= 0 then
		Assets.playSound("bump")
		self.parent.car.sfx_buffer_timer = self.parent.car.sfx_buffer
	end
end

function RacingSolid:draw()
    if DEBUG_RENDER and self.collider then
        self.collider:drawFill(self:getColor())
    end

    super.draw(self)
end

return RacingSolid