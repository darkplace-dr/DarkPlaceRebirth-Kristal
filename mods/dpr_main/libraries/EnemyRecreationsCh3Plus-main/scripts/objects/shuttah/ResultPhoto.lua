local ResultPhoto, super = Class(Object)

function ResultPhoto:init(image, border_on, photo_x, photo_y, photo_width, photo_height)
    super.init(self, 185, 400, photo_width, photo_height)
    self:setScale(1.5)
    self:setLayer(BATTLE_LAYERS["below_ui"])
    self.border_on = border_on
    self.timer = 0
    self.photo_x = photo_x
    self.photo_y = photo_y
    self.photo = image
    self.move_down_timer = 0
    self.move_down_started = false
    self.white_padding = 10
end

function ResultPhoto:update()
    super.update(self)

    self.timer = self.timer + DTMULT

    self.y = Utils.ease(400, 100, self.timer / 20,'outBack')
    self.rotation = math.rad(Utils.ease(20, -10, self.timer / 20, 'outBack'))

    if self.move_down_started then
        self.move_down_timer = self.move_down_timer + DTMULT
        self.y = Utils.ease(100, 400, self.move_down_timer / 20, 'inQuart')
    end
end

function ResultPhoto:moveDown()
    self.move_down_started = true
end

function ResultPhoto:draw()
    super.draw(self)

    local white_padding = self.white_padding

    Draw.setColor(COLORS.white)
    local width, height = self.width, self.height
    love.graphics.rectangle("fill", 0, 0, width + 2 * white_padding, height + 2 * white_padding)

    Draw.setColor(COLORS.white)

    -- This looks like a bombfield but it works
    local x, y = self.photo_x, self.photo_y
    local image = self.photo
    local img_width, img_height = image:getDimensions()

    local scale_x, scale_y
    local image_ratio = img_width / img_height
    local screen_ratio = SCREEN_WIDTH / SCREEN_HEIGHT
    if self.border_on then
        scale_x, scale_y = BORDER_WIDTH * BORDER_SCALE / img_width, BORDER_HEIGHT * BORDER_SCALE / img_height
    else
        scale_x, scale_y = SCREEN_WIDTH / img_width, SCREEN_HEIGHT / img_height
    end

    local scale = math.max(scale_x, scale_y)
    local image_offset_x = -(img_width * scale - SCREEN_WIDTH) / 2
    local image_offset_y = -(img_height * scale - SCREEN_HEIGHT) / 2

    love.graphics.stencil(function()
        love.graphics.rectangle("fill", white_padding, white_padding, width, height)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    Draw.draw(image, -x + image_offset_x + white_padding, -y + image_offset_y + white_padding, 0, scale, scale)
    love.graphics.setStencilTest()
end

return ResultPhoto