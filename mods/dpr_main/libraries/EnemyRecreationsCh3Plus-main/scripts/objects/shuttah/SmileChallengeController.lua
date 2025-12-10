local SmileChallengeController, super = Class(Object)

function SmileChallengeController:init()
    super.init(self)

    self.camera_collider = nil

    self.actor_sprites = {}
    self.color_sprites = {}
    self.collider_properties = {21, 28, 23, 15}

    for i = 1, 4 do
        local actor_sprite = ActorSprite('shuttahact')

        if i == 1 then
            self.collider = Hitbox(actor_sprite, TableUtils.unpack(self.collider_properties))
            actor_sprite:setSprite("smile")
        else
            if MathUtils.roundToMultiple(MathUtils.random(1, 4), 1) == 1 then actor_sprite:setSprite("banana")
            else actor_sprite:setSprite("frown") end
        end

        actor_sprite.alpha = 0
        actor_sprite.scale_x = -2
        actor_sprite:setOrigin(0.5, 1)
        actor_sprite:setScale(2, 2)
        actor_sprite:fadeTo(1, 5/30)

        local fx = ColorMaskFX(COLORS.black, 1)
        fx.id = "colormask"
        actor_sprite:addFX(fx)

        self:addChild(actor_sprite)
        table.insert(self.actor_sprites, actor_sprite)

        local color_sprite = actor_sprite:clone()
        color_sprite:fadeTo(1, 5/30)

        self:addChild(color_sprite)
        table.insert(self.color_sprites, color_sprite)
    end

    self.sprite_rotation_orig = MathUtils.random(1, 360+1)
    self.sprite_rotation = 0
    self.center_x = SCREEN_WIDTH / 2
    self.center_y = 220
    self.timer = 0
    self.scale_timer = 0
    self.flip_timer = 0
    self.flipped = false
end

function SmileChallengeController:update()
    super.update(self)

    self.timer = self.timer + DTMULT
    self.sprite_rotation = math.cos(math.max(0, self.timer - 40) / 10) * 60 + self.sprite_rotation_orig
    self.flip_timer = self.flip_timer - DTMULT
    if self.flip_timer < 0 then
        local flip_speed = 15
        if self.flip_timer >= -180 / flip_speed then self.scale_timer = self.scale_timer + DTMULT * flip_speed
        else
            self.scale_timer = MathUtils.round(self.scale_timer, 180)
            if math.floor(self.scale_timer / 180) % 2 == 1 then
                self.flip_timer = 10
            else
                if not self.flipped then
                    self.flip_timer = 30
                    self.flipped = true
                else self.flip_timer = MathUtils.roundToMultiple(MathUtils.random(10, 40), 1) end
            end
        end
    end
    
    for index, actor_sprite in ipairs(self.actor_sprites) do
        local color_sprite = self.color_sprites[index]
        local rotation = math.rad(self.sprite_rotation + (index - 0) / #self.actor_sprites * 360)
        local x, y = math.cos(rotation) * 180 + self.center_x, math.sin(rotation) * 60 + self.center_y
        actor_sprite:setPosition(x, y)
        color_sprite:setPosition(x - 5, y - 5)
        actor_sprite:setLayer(math.sin(rotation))
        color_sprite:setLayer(math.sin(rotation) - 0.01)
        actor_sprite.scale_x = math.cos(math.rad(self.scale_timer)) * -2
        color_sprite.scale_x = math.cos(math.rad(self.scale_timer)) * -2
        local x, y, width, height = TableUtils.unpack(self.collider_properties)
        local width_new = math.cos(math.rad(self.scale_timer)) * width
        local x_new = x + width / 2 - width_new / 2
        self.collider.x = x_new
        self.collider.width = width_new

        local r1, g1, b1 = TableUtils.unpack(index == 1 and COLORS.lime or COLORS.red)
        local r, g, b = 1/2, 1, 1
        local progress = (self.timer - 40) / 10
        color_sprite:getFX('colormask'):setColor(
            MathUtils.lerp(r1, r, progress),
            MathUtils.lerp(g1, g, progress),
            MathUtils.lerp(b1, b, progress)
        )

        if actor_sprite.scale_x < 0 then
            actor_sprite:getFX('colormask').amount = 1
            color_sprite.visible = true
        else
            actor_sprite:getFX('colormask').amount = 0
            color_sprite.visible = false
        end
    end
end

function SmileChallengeController:getCameraSpawn()
    local x = self.actor_sprites[1].x + self.collider.x + self.collider.width / 2
    local spawn_x = x - (SCREEN_WIDTH - 200) / 2
    if spawn_x < 100 then spawn_x = x + (SCREEN_WIDTH - 200) / 2 end
    return spawn_x , 175
end

function SmileChallengeController:checkSuccessAction()
    return self.camera_collider:collidesWith(self.collider) and
           self.actor_sprites[1].scale_x > 0
end

function SmileChallengeController:checkSuccessFinal()
    return self:checkSuccessAction()
end

return SmileChallengeController