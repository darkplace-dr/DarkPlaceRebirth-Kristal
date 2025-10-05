local PhotoBullet, super = Class(Bullet)

Kristal.Shaders["InvertColor"] = love.graphics.newShader[[
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 pixel = Texel(texture, texture_coords); // get pixel color
        pixel.rgb = vec3(1.0) - pixel.rgb; // invert RGB
        return pixel * color; // multiply by input color (usually white)
    }
]]

function PhotoBullet:init(x, y)
    super.init(self, x, y)

    self:setLayer(BATTLE_LAYERS["above_bullets"])
    self.hand_distance = 50
    self.start_change = 35
    self.end_change = 5
    self.capture_width = 90
    self.collider.collidable = false

    self.color = {0.5, 0.5, 0.5}

    self.damage = 0
    self.destroy_on_hit = false
    self.tp = 0
    self.time_bonus = 0

    self.left_hand = Sprite('enemies/shuttah/cam_hand_left')
    self.right_hand = Sprite('enemies/shuttah/cam_hand_right')
    self.reticle = Sprite('enemies/shuttah/cam_reticle')
    self.left_hand:setColor(self.color)
    self.right_hand:setColor(self.color)
    self.reticle:setColor(self.color)
    self.left_hand.alpha = 0
    self.right_hand.alpha = 0
    self.reticle.alpha = 0
    self.left_hand:setOrigin(0.5, 0.5)
    self.right_hand:setOrigin(0.5, 0.5)
    self.reticle:setOrigin(0.5, 0.5)
    self:addChild(self.left_hand)
    self:addChild(self.right_hand)
    self:addChild(self.reticle)

    self.bullet_collider = Hitbox(self, 0, 0, self.capture_width, self.capture_width)
    self:updateCollider()

    self.timer = 0
    self.lifetime = math.huge
    self.total_rotation = 0
    self.rotation_per_second = 0
    self.rotation_windup = false

    self.easing_done = false

    self.screenshot = nil
    self.snapped = false

    self.fx = nil

    self.captured_bullets = {}
    self.bullet_original_color = {}
    self.bullet_original_position = {}
    self.bullet_original_rotation = {}
    self.bullet_destroy_on_hit = {}
    -- self.blacklisted_bullets = Kristal.getLibConfig("enemyrecreations-ch3+", "rotationSpeed")
    -- self.blacklisted_bullets = {"shuttah/photobullet", "shuttah/diamond_black"}

    self.released_bullets = false
    self.border_on = false
end

function PhotoBullet:updateCollider()
    self.bullet_collider.x = -self.capture_width * self.origin_x
    self.bullet_collider.y = -self.capture_width * self.origin_y
end

function PhotoBullet:getHandDistances(diff)
    -- Worst math in my life
    local origin_x_left, origin_y_left = self.origin_x, self.origin_y
    local distance_from_box = self.hand_distance - self.capture_width / 2
    local box_half_width = self.capture_width / 2
    local distance_x_left, distance_y_left = box_half_width * 2 * origin_x_left + distance_from_box, box_half_width * 2 * origin_y_left + distance_from_box
    local distance_x_right, distance_y_right = -distance_x_left + 2 * self.hand_distance, -distance_y_left + 2 * self.hand_distance
    return distance_x_left + diff + 2, distance_y_left + diff - 2, distance_x_right + diff + 2, distance_y_right + diff - 2
end

function PhotoBullet:getRemainingLifetime()
    return self.lifetime * 30 - (self.timer - 18 - 12)
end

function PhotoBullet:canCaptureBullet(bullet)
    local config = Kristal.getLibConfig('enemyrecreations-ch3+', 'shuttah')
    local use_whitelist, blacklist, whitelist = config.use_whitelist, config.blacklist, config.whitelist
    local first_condition = bullet:includes(Bullet) and bullet.active and self.bullet_collider:collidesWith(bullet.collider)
    if use_whitelist then
        return first_condition and Utils.containsValue(whitelist, bullet.id)
    else
        return first_condition and not Utils.containsValue(blacklist, bullet.id)
    end
end

function PhotoBullet:update()
    self.timer = self.timer + DTMULT

    if self.timer <= 14 then
        local progress = self.timer / 14
        local start_distance = self.hand_distance + self.start_change
        local distance = Ease.outQuad(progress, self.start_change, -self.start_change, 1)
        local distance_x_left, distance_y_left, distance_x_right, distance_y_right = self:getHandDistances(distance)
        self.left_hand.alpha = Utils.lerp(0, 1, progress)
        self.right_hand.alpha = Utils.lerp(0, 1, progress)
        self.left_hand:setPosition(-distance_x_left, -distance_y_left)
        self.right_hand:setPosition(distance_x_right, distance_y_right)
    elseif not self.easing_done then
        local distance_x_left, distance_y_left, distance_x_right, distance_y_right = self:getHandDistances(0)
        self.left_hand.alpha = 1
        self.right_hand.alpha = 1
        self.left_hand:setPosition(-distance_x_left, -distance_y_left)
        self.right_hand:setPosition(distance_x_right, distance_y_right)
        self.easing_done = true
    end

    if self.timer >= 18 and (self.total_rotation ~= 0 or self.rotation_per_second ~= 0) then
        self.reticle.alpha = 1
    end

    if self.timer >= 18 and not self.snapped then
        self.snapped = true
        Assets.playSound('camera_flash')
        love.graphics.captureScreenshot(function(imageData)
            self.screenshot = love.graphics.newImage(imageData)
            self.border_on = Kristal.Config["borders"] ~= "off"
        end)

        for _, bullet in ipairs(Game.battle.children) do
            if self:canCaptureBullet(bullet) then
                local rotation_origin_x, rotation_origin_y = bullet:getRotationOrigin()
                table.insert(self.captured_bullets, bullet)
                table.insert(self.bullet_original_color, bullet.color)
                table.insert(self.bullet_original_position, {bullet.x, bullet.y})
                table.insert(self.bullet_original_rotation, bullet.rotation)
                table.insert(self.bullet_destroy_on_hit, bullet.destroy_on_hit)
                bullet.active = false
                bullet.destroy_on_hit = false
                bullet:setColor(148 / 255, 222 / 255, 252 / 255)
                local self_x, self_y = self:getScreenPos()
            end
        end
    end

    local remaining = self:getRemainingLifetime()
    if self.timer > 18 + 12 and remaining >= 0 then
        local rotation_per_frame = 0
        if self.total_rotation ~= 0 then rotation_per_frame = math.rad(self.total_rotation / self.lifetime * DT)
        elseif self.rotation_per_second ~= 0 then rotation_per_frame = math.rad(self.rotation_per_second * DT) end
        if self.rotation_windup then
            rotation_per_frame = Utils.lerp(0, rotation_per_frame, (self.timer - 18 - 12) / 30 * 4)
        end
        self.rotation = self.rotation + rotation_per_frame
        self.reticle.rotation = -self.rotation
        for index, bullet in ipairs(self.captured_bullets) do
            bullet.rotation = self.bullet_original_rotation[index] + self.rotation
            local self_x, self_y = self:getScreenPos()
            local bullet_x, bullet_y = Utils.unpack(self.bullet_original_position[index])
            local rotation = Utils.angle(self_x, self_y, bullet_x, bullet_y) + self.rotation
            local distance = Utils.dist(self_x, self_y, bullet_x, bullet_y)
            
            local new_x, new_y = math.cos(rotation) * distance + self.x, math.sin(rotation) * distance + self.y
            bullet.x = new_x
            bullet.y = new_y
        end
    end

    if remaining >= -15 and remaining < 0 then
        if not self.released_bullets then
            self.released_bullets = true
            for index, bullet in ipairs(self.captured_bullets) do
                bullet.active = true
                bullet:setColor(self.bullet_original_color[index])
                bullet.destroy_on_hit = self.bullet_destroy_on_hit[index]
            end
        end
        local progress = 1 + remaining / 15
        local end_distance = self.hand_distance + self.end_change
        local distance = Ease.inQuad(progress, self.end_change, -self.end_change, 1)
        local distance_x_left, distance_y_left, distance_x_right, distance_y_right = self:getHandDistances(distance)
        self.left_hand.alpha = Utils.lerp(1, 0, 1 - progress)
        self.right_hand.alpha = Utils.lerp(1, 0, 1 - progress)
        if self.total_rotation ~= 0 then self.reticle.alpha = Utils.lerp(1, 0, 1 - progress) end
        self.left_hand:setPosition(-distance_x_left, -distance_y_left)
        self.right_hand:setPosition(distance_x_right, distance_y_right)
    elseif remaining < -15 then
        self:remove()
    end

    super.update(self)
end

function PhotoBullet:draw()
    local fadeout = 12
    if self.screenshot and self.timer < 18 + fadeout then
        Draw.setColor(1, 1, 1, Utils.lerp(1, 0, (self.timer - 18) / fadeout))
        local x, y = self:getScreenPos()
        local image = self.screenshot
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
        local image_offset_x = -(img_width * scale - SCREEN_WIDTH) / 4
        local image_offset_y = -(img_height * scale - SCREEN_HEIGHT) / 4

        local width = self.capture_width
        local last_shader = love.graphics.getShader()
        local shader = Kristal.Shaders["InvertColor"]
        love.graphics.setShader(shader)
        love.graphics.stencil(function()
            love.graphics.rectangle("fill", -width * self.origin_x, -width * self.origin_y, width, width)
        end, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        Draw.draw(image, -x/2 + image_offset_x, -y/2 + image_offset_y, 0, scale/2, scale/2)
        love.graphics.setShader(last_shader)
        love.graphics.setStencilTest()
    end

    if self.timer > 18 then
        local alpha = Utils.clamp(1 + self:getRemainingLifetime() / 15, 0, 1)
        local r, g, b = Utils.unpack(self.color)
        local width = self.capture_width
        Draw.setColor(r, g, b, alpha)
        love.graphics.setLineWidth(1)
        love.graphics.rectangle("line", -width * self.origin_x, -width * self.origin_y, width, width)
    end

    super.draw(self)
end

return PhotoBullet