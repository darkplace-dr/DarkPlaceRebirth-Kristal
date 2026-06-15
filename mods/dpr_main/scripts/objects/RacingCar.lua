local RacingCar, super = Class(Object)

function RacingCar:init(x, y)
    super.init(self, x, y, width, height)

    self.layer = WORLD_LAYERS["top"]

    self:setHitbox(0, 0, 40, 40)
	
    self.original_x = x
    self.original_y = y
    self.target_x = x
    self.target_y = y
    self.speed = 12

    -- 1px movement increments
    self.partial_x = (self.x % 1)
    self.partial_y = (self.y % 1)

    self.last_collided_x = false
    self.last_collided_y = false

    self.x = math.floor(self.x)
    self.y = math.floor(self.y)

    self.moving_x = 0
    self.moving_y = 0
    self.can_move = false
	
	self.color = {1, 0, 1}
	self.sfx_buffer = 5
	self.sfx_buffer_timer = 0
	self.sfx_honk_buffer = 90
	self.sfx_honk_buffer_timer = 0
end

function RacingCar:checkSolidCollision()
    if NOCLIP then return false end
    Object.startCache()
    for _, solid in ipairs(Game.stage:getObjects(RacingSolid)) do
        if solid:collidesWith(self.collider) then
            Object.endCache()
            return true, solid
        end
    end
    Object.endCache()
    return false
end

function RacingCar:isMoving()
    return self.moving_x ~= 0 or self.moving_y ~= 0
end

function RacingCar:getExactPosition(x, y)
    return self.x + self.partial_x, self.y + self.partial_y
end

function RacingCar:setExactPosition(x, y)
    self.x = math.floor(x)
    self.partial_x = x - self.x
    self.y = math.floor(y)
    self.partial_y = y - self.y
end

function RacingCar:move(x, y, speed)
    local movex, movey = x * (speed or 1), y * (speed or 1)

    local mxa, mxb = self:moveX(movex, movey)
    local mya, myb = self:moveY(movey, movex)

    local moved = (mxa and not mxb) or (mya and not myb)
    local collided = (not mxa and not mxb) or (not mya and not myb)

    return moved, collided
end

function RacingCar:moveX(amount, move_y)
    local last_collided = self.last_collided_x and (Utils.sign(amount) == self.last_collided_x)

    if amount == 0 then
        return not last_collided, true
    end

    self.partial_x = self.partial_x + amount

    local move = math.floor(self.partial_x)
    self.partial_x = self.partial_x % 1

    if move ~= 0 then
        local moved = self:moveXExact(move, move_y)
        return moved
    else
        return not last_collided
    end
end

function RacingCar:moveY(amount, move_x)
    local last_collided = self.last_collided_y and (Utils.sign(amount) == self.last_collided_y)

    if amount == 0 then
        return not last_collided, true
    end

    self.partial_y = self.partial_y + amount

    local move = math.floor(self.partial_y)
    self.partial_y = self.partial_y % 1

    if move ~= 0 then
        local moved = self:moveYExact(move, move_x)
        return moved
    else
        return not last_collided
    end
end

function RacingCar:moveXExact(amount, move_y)
    local sign = Utils.sign(amount)
    for i = sign, amount, sign do
        local last_x = self.x
        local last_y = self.y

        self.x = self.x + sign

        if not self.noclip then
            Object.uncache(self)
            Object.startCache()
            local collided, target = self:checkSolidCollision(self)
            if self.slope_correction then
                if collided and not (move_y > 0) then
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.y = self.y - 1
                        collided, target = self:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
                if collided and not (move_y < 0) then
                    self.y = last_y
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.y = self.y + 1
                        collided, target = self:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
            end
            Object.endCache()

            if collided then
                self.x = last_x
                self.y = last_y

                if target and target.onCollide then
                    target:onCollide(self)
                end

                self.last_collided_x = sign
                return false, target
            end
        end
    end
    self.last_collided_x = 0
    return true
end

function RacingCar:moveYExact(amount, move_x)
    local sign = MathUtils.sign(amount)
    for i = sign, amount, sign do
        local last_x = self.x
        local last_y = self.y

        self.y = self.y + sign

        if not self.noclip then
            Object.uncache(self)
            Object.startCache()
            local collided, target = self:checkSolidCollision(self)
            if self.slope_correction then
                if collided and not (move_x > 0) then
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.x = self.x - 1
                        collided, target = self:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
                if collided and not (move_x < 0) then
                    self.x = last_x
                    for j = 1, 2 do
                        Object.uncache(self)
                        self.x = self.x + 1
                        collided, target = self:checkSolidCollision(self)
                        if not collided then break end
                    end
                end
            end
            Object.endCache()

            if collided then
                self.x = last_x
                self.y = last_y

                if target and target.onCollide then
                    target:onCollide(self)
                end

                self.last_collided_y = sign
                return i ~= sign, target
            end
        end
    end
    self.last_collided_y = 0
    return true
end

function RacingCar:doMovement()
    local speed = self.speed

    local move_x, move_y = 0, 0

    -- Keyboard input:
    if Input.down("left") then move_x = move_x - 1 end
    if Input.down("right") then move_x = move_x + 1 end
    if Input.down("up") then move_y = move_y - 1 end
    if Input.down("down") then move_y = move_y + 1 end

    self.moving_x = move_x
    self.moving_y = move_y

    if move_x ~= 0 or move_y ~= 0 then
        if not self:move(move_x, move_y, speed * DTMULT) then
            self.moving_x = 0
            self.moving_y = 0
		else
			if self.sfx_buffer_timer > 0 then
				self.sfx_buffer_timer = self.sfx_buffer_timer - DTMULT
			end
		end
    else
		if self.sfx_buffer_timer > 0 then
			self.sfx_buffer_timer = self.sfx_buffer_timer - DTMULT
		end
	end
end

function RacingCar:update()
	super.update(self)
	if self.can_move then
        self:doMovement()
		if self.sfx_honk_buffer_timer <= 0 then
			if self:isMoving() then
				Assets.playSound("carhonk", 0.25, 1.8)
				self.sfx_honk_buffer_timer = self.sfx_honk_buffer
			end
		else
			self.sfx_honk_buffer_timer = self.sfx_honk_buffer_timer - DTMULT
		end
		Object.startCache()
		if self.parent.goal then
			if self.parent.goal:collidesWith(self.collider) then
				self.parent:winGame()
			end
		end
		Object.endCache()
	end
end

function RacingCar:draw()
    if DEBUG_RENDER and self.collider then
        self.collider:drawFill(self:getColor())
    end

    super.draw(self)
end

return RacingCar