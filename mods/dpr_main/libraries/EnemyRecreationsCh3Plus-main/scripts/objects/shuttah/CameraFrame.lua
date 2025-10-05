local CameraFrame, super = Class(Object)

function CameraFrame:init(x, y)
    self.target_width = 160
    self.target_height = 120
    super.init(self, x, y, self.target_width, self.target_height)
    self:setOrigin(0.5, 0.5)

    self.left_hand = Sprite('enemies/shuttah/snapact/hand_left')
    self.right_hand = Sprite('enemies/shuttah/snapact/hand_right')
    self.left_hand:setScale(2, 2)
    self.right_hand:setScale(2, 2)
    self.left_hand:setColor(self.color)
    self.right_hand:setColor(self.color)
    self.left_hand:setOrigin(0.5, 0.5)
    self.right_hand:setOrigin(0.5, 0.5)
    self:addChild(self.left_hand)
    self:addChild(self.right_hand)

    self.inherit_color = true

    self.canvas = nil
    self.border_on = false

    self.timer = 0
    self.started_capture = false
    self.reticle_green = false

    self.collider = Hitbox(self, 0, 0, self.target_width, self.target_height)
end

function CameraFrame:getHandDistances()
    local distance_from_box = 5
    local box_half_width = self.width / 2
    local hand_distance = box_half_width + distance_from_box
    local distance_x_left, distance_y_left = -distance_from_box, -distance_from_box
    local distance_x_right, distance_y_right = self.target_width + distance_from_box, self.target_height + distance_from_box
    local multiplier = self:getSizeMultiplier()
    return distance_x_left * multiplier, distance_y_left * multiplier, distance_x_right * multiplier, distance_y_right * multiplier
end

function CameraFrame:capture()
    Assets.playSound('camera_flash')
    love.graphics.captureScreenshot(function(imageData)
        self.snapped = true
        self.canvas = love.graphics.newImage(imageData)
        self.border_on = Kristal.Config["borders"] ~= "off"
    end)
end

function CameraFrame:getSizeMultiplier()
    return Utils.ease(0.8, 1, self.timer / 10, 'outBack')
end

function CameraFrame:update()
    super.update(self)

    self.timer = self.timer + DTMULT

    local distance_x_left, distance_y_left, distance_x_right, distance_y_right = self:getHandDistances()
    self.left_hand:setPosition(distance_x_left, distance_y_left)
    self.right_hand:setPosition(distance_x_right, distance_y_right)

    local speed = 8
    if not self.snapped then
        if Input.down("left")  then self.x = self.x - speed * DTMULT end
        if Input.down("right") then self.x = self.x + speed * DTMULT end
        if Input.down("up")    then self.y = self.y - speed * DTMULT end
        if Input.down("down")  then self.y = self.y + speed * DTMULT end

        local border_x, border_y = 100, 80
        self.x = Utils.clamp(self.x, border_x, SCREEN_WIDTH - border_x)
        self.y = Utils.clamp(self.y, border_y, 340 - border_y)
    end

    if Input.pressed("confirm") and self.timer > 15 and not self.snapped then self:capture() end
    if self.snapped then
        self.visible = false
    end
    local multiplier = self:getSizeMultiplier()
    self.width = self.target_width * multiplier
    self.height = self.target_height * multiplier
end

function CameraFrame:setReticleGreen(boolean)
    self.reticle_green = boolean
end

function CameraFrame:draw()
    super.draw(self)

    local line_width = 2
    local half_line_width = line_width / 2
    Draw.setColor(COLORS.red)
    love.graphics.setLineWidth(line_width)
    love.graphics.rectangle("line", half_line_width, half_line_width, self.width - half_line_width, self.height - half_line_width)

    if self.reticle_green then
        Draw.setColor(COLORS.lime)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", self.width/2, self.height/2, 9)
    else
        Draw.setColor(COLORS.gray)
        love.graphics.setLineWidth(1)
        love.graphics.circle("line", self.width/2, self.height/2, 8)
    end

    if DEBUG_RENDER then
        self.collider:draw(1, 0, 1, 0.5)
    end
end

return CameraFrame