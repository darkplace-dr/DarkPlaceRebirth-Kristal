local BlueSoul, super = Class(LightSoul)

function BlueSoul:init(x, y)
    super.init(self, x, y)

    -- Do not modify these variables
    self.color = {0, 60/255, 255/255, 1}
    self.jumped = false
    self.gravity = 0

    -- Variables that can be changed
    self.can_jump = true     -- Can the blue soul jump? [boolean] (true; false) | default: true
    self.jump_height = 6     -- How high can the blue soul jump? [number] (positive number) | default: 6
    self.direction = "down"  -- What directiion is the soul facing and falling? [string] ("down"; "left"; "up"; "right") | default: "down"
end

function BlueSoul:update()
    super.update(self)
    
    if self:getDirection() == "down" then self.rotation = math.rad(0) end
    if self:getDirection() == "up" then self.rotation = math.rad(180) end
    if self:getDirection() == "left" then self.rotation = math.rad(90) end
    if self:getDirection() == "right" then self.rotation = math.rad(270) end
    
    if self.transitioning then
        self.jumped = true
        self.gravity = 0
    end
end

function BlueSoul:getDirection()
    return self.direction
end

function BlueSoul:setDirection(direction)
    self.direction = direction
end

function BlueSoul:doMovement()
    local speed = self.speed

    if Input.down("cancel") then speed = speed / 2 end -- Focus mode.

    local move_x, move_y = 0, 0
    
    self:doGravity()

    if self:getDirection() == "down" then
        -- Keyboard input:
        if Input.down("left")  then move_x = move_x - 1 end
        if Input.down("right") then move_x = move_x + 1 end
        if Input.down("up") then 
            self:jumpStart()
        end
        if Input.released("up") then
            self:jumpEnd()
        end
        
        move_y = self.gravity
        
        if self.last_collided_y == 1 and self.gravity >= 0 then
            self:jumpReset()
        else
            self.jumped = true
        end
        if self.last_collided_y == -1 and self.gravity < 0 then
            self.gravity = 0
        end
    elseif self:getDirection() == "up" then
        -- Keyboard input:
        if Input.down("left")  then move_x = move_x - 1 end
        if Input.down("right") then move_x = move_x + 1 end
        if Input.down("down") then 
            self:jumpStart()
        end
        if Input.released("down") then
            self:jumpEnd()
        end
        
        move_y = self.gravity
        
        if self.last_collided_y == -1 and self.gravity >= 0 then
            self:jumpReset()
        else
            self.jumped = true
        end
        if self.last_collided_y == 1 and self.gravity < 0 then
            self.gravity = 0
        end
    elseif self:getDirection() == "left" then
        -- Keyboard input:
        if Input.down("up")  then move_y = move_y - 1 end
        if Input.down("down") then move_y = move_y + 1 end
        if Input.down("right") then 
            self:jumpStart()
        end
        if Input.released("right") then
            self:jumpEnd()
        end
        
        move_x = self.gravity
        
        if self.last_collided_x == -1 and self.gravity >= 0 then
            self:jumpReset()
        else
            self.jumped = true
        end
        if self.last_collided_x == 1 and self.gravity < 0 then
            self.gravity = 0
        end
    elseif self:getDirection() == "right" then
        -- Keyboard input:
        if Input.down("up")  then move_y = move_y - 1 end
        if Input.down("down") then move_y = move_y + 1 end
        if Input.down("left") then 
            self:jumpStart()
        end
        if Input.released("left") then
            self:jumpEnd()
        end
        
        move_x = self.gravity
        
        if self.last_collided_x == 1 and self.gravity >= 0 then
            self:jumpReset()
        else
            self.jumped = true
        end
        if self.last_collided_x == -1 and self.gravity < 0 then
            self.gravity = 0
        end
    end
    
    if self:getDirection() == "down" then
        if move_x ~= 0 or move_y ~= 0 then
            self:move(move_x * speed, move_y, DTMULT)
        end
    elseif self:getDirection() == "up" then
        if move_x ~= 0 or move_y ~= 0 then
            self:move(move_x * speed, -move_y, DTMULT)
        end
    elseif self:getDirection() == "left" then
        if move_x ~= 0 or move_y ~= 0 then
            self:move(-move_x, move_y * speed, DTMULT)
        end
    elseif self:getDirection() == "right" then
        if move_x ~= 0 or move_y ~= 0 then
            self:move(move_x, move_y * speed, DTMULT)
        end
    end

    self.moving_x = move_x
    self.moving_y = move_y
end

function BlueSoul:draw()
    local r, g, b, a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    super.draw(self)

    self.color = {r, g, b, a}
end

function BlueSoul:jumpStart()
    if self.can_jump and not self.jumped then
        self.gravity = -self.jump_height
    end
end

function BlueSoul:jumpEnd()
    if self.gravity < -1 then
        self.gravity = -1
    end
end

function BlueSoul:jumpReset()
    self.gravity = 0
    self.jumped = false
end

function BlueSoul:doGravity()
    local function getAccel(velocity)
        if velocity <= -4 then
            return 0.2
        elseif velocity <= -1 then
            return 0.5
        elseif velocity <= 0.5 then
            return 0.2
        elseif velocity < 8 then
            return 0.6
        else
            return 0
        end
    end
    
    self.gravity = self.gravity + getAccel(self.gravity) * DTMULT
end

return BlueSoul