local WingladeActorSprite, super = Class(ActorSprite)

function WingladeActorSprite:init(actor)
    super.init(self, actor)

    self.horn = Sprite(self:getTexturePath("horn"), 18, 0)
    self.horn.debug_select = false
    self.horn:setScaleOrigin(0.5, 1)
    self:addChild(self.horn)

    self.sword = Sprite(self:getTexturePath("sword"), 18, 22)
    self.sword.debug_select = false
    self.sword:setScaleOrigin(0.5, 0)
    self:addChild(self.sword)

    self.left_wing = Sprite(self:getTexturePath("left_wing"), -3)
    self.left_wing.debug_select = false
    self.left_wing:play(1/6)
    self:addChild(self.left_wing)

    self.right_wing = Sprite(self:getTexturePath("right_wing"), -3)
    self.right_wing.debug_select = false
    self.right_wing:play(1/6)
    self:addChild(self.right_wing)

    self.black = Sprite(self:getTexturePath("black"), 19, 16)
    self.black.debug_select = false
    self:addChild(self.black)

    self.halo = Sprite(self:getTexturePath("halo"), 16, 13)
    self.halo.debug_select = false
    self:addChild(self.halo)

    self.eye_white = Sprite(self:getTexturePath("eye_white"), 27, 23)
    self.eye_white:setOriginExact(5, 3)
    self.eye_white.debug_select = false
    self:addChild(self.eye_white)

    self.eye_pupil = Sprite(self:getTexturePath("eye_pupil"), 27, 23)
    self.eye_pupil:setOriginExact(2, 2)
    self.eye_pupil.debug_select = false
    self:addChild(self.eye_pupil)

    self.timer = 0
    self.speed = 0.05

    self.eye_default_position = {27, 23}
    self.eye_target_x = 0
    self.eye_target_y = 0
    self.eye_target_set = false
    self.eye_timer = 0

    self.retract_timer = 0
end

function WingladeActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function WingladeActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function WingladeActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function WingladeActorSprite:addColorMask(object, color, amount, id)
    if not object:getFX(id) then
        local fx = ColorMaskFX(color, amount)
        fx.id = id
        object:addFX(fx)
    end
end

function WingladeActorSprite:update()
    super.update(self)

    self.timer = self.timer + DTMULT

    local speed = self.speed
    self.y = self.y + (math.sin(self.timer * speed) - math.sin((self.timer - 1) * speed)) * 3 * DTMULT

    local anim = self.anim or 'idle'
    if anim == 'idle' or anim == 'spared' then
        self.eye_timer = self.eye_timer + DTMULT
        if self.eye_timer > 30 and not self.eye_target_set then
            local eye_angle = 160 + MathUtils.roundToMultiple(MathUtils.random(0, 40), 1)
            self.eye_target_x = math.cos(math.rad(eye_angle)) * 3
            self.eye_target_y = math.sin(math.rad(eye_angle)) * 3
            self.eye_target_set = true
        end
        if self.eye_timer > 90 then
            self.eye_target_set = false
            self.eye_timer = MathUtils.roundToMultiple(MathUtils.random(0, 8), 1) - MathUtils.roundToMultiple(MathUtils.random(0, 8), 1)
            self.eye_target_x = 0
            self.eye_target_y = 0
        end
        local eye_start_x, eye_start_y = self.eye_default_position[1], self.eye_default_position[2]
        self.eye_white.x = MathUtils.lerp(self.eye_white.x, eye_start_x + self.eye_target_x / 5, 0.2 * DTMULT)
        self.eye_white.y = MathUtils.lerp(self.eye_white.y, eye_start_y + self.eye_target_y / 5, 0.2 * DTMULT)
        self.eye_pupil.x = MathUtils.lerp(self.eye_pupil.x, eye_start_x + self.eye_target_x, 0.2 * DTMULT)
        self.eye_pupil.y = MathUtils.lerp(self.eye_pupil.y, eye_start_y + self.eye_target_y, 0.2 * DTMULT)
    end
    if anim == 'spared' then
        self.eye_pupil.visible = false
        self.eye_white:setSprite(self:getTexturePath("eye_white_spare"))
    end

    if anim == 'retract' or anim == 'retract_shoot' then
        self.retract_timer = self.retract_timer + DTMULT

        self.horn.scale_y = MathUtils.clamp(1 - self.retract_timer / 10, 0, 1)
        self.sword.scale_y = MathUtils.clamp(1 - self.retract_timer / 10, 0, 1)

        self:addColorMask(self.left_wing, COLORS.black, 0.5, 'colormask')
        self:addColorMask(self.right_wing, COLORS.black, 0.5, 'colormask')
        self:addColorMask(self.halo, COLORS.black, 0.5, 'colormask')
        self:addColorMask(self.eye_white, COLORS.black, 0.5, 'colormask')
        self:addColorMask(self.halo, COLORS.white, 0, 'colormaskwhite')
        self:addColorMask(self.eye_white, COLORS.white, 0, 'colormaskwhite')
        self:addColorMask(self.eye_pupil, COLORS.white, 0, 'colormaskwhite')
    else
        self.retract_timer = MathUtils.clamp(self.retract_timer - DTMULT, 0, 10)
        self.horn.scale_y = MathUtils.clamp(1 - self.retract_timer / 10, 0, 1)
        self.sword.scale_y = MathUtils.clamp(1 - self.retract_timer / 10, 0, 1)
        if self.retract_timer == 0 then
            if self.left_wing:getFX('colormask') then self.left_wing:removeFX('colormask') end
            if self.right_wing:getFX('colormask') then self.right_wing:removeFX('colormask') end
            if self.halo:getFX('colormask') then self.halo:removeFX('colormask') end
            if self.eye_white:getFX('colormask') then self.eye_white:removeFX('colormask') end
            if self.halo:getFX('colormaskwhite') then self.halo:removeFX('colormaskwhite') end
            if self.eye_white:getFX('colormaskwhite') then self.eye_white:removeFX('colormaskwhite') end
            if self.eye_pupil:getFX('colormaskwhite') then self.eye_pupil:removeFX('colormaskwhite') end
        end
    end

    if anim == 'stare' then
        self:addColorMask(self, COLORS.lime, 0, 'colormaskgreen')
    else
        if self:getFX('colormaskgreen') then self:removeFX('colormaskgreen') end
    end

    if anim == 'retract' or anim == 'retract_shoot' or anim == 'stare' then
        local x_screen_pos, y_screen_pos = self:getScreenPos()
        x_screen_pos, y_screen_pos = x_screen_pos + self.eye_default_position[1], y_screen_pos + self.eye_default_position[2]
        local x_soul, y_soul = Game.battle.soul.x, Game.battle.soul.y
        local eye_angle = MathUtils.angle(x_screen_pos + 27, y_screen_pos + 23, x_soul, y_soul)
        self.eye_pupil.visible = true
        self.eye_white:setSprite(self:getTexturePath("eye_white"))
        local eye_start_x, eye_start_y = self.eye_default_position[1], self.eye_default_position[2]
        self.eye_target_x = math.cos(eye_angle) * 2
        self.eye_target_y = math.sin(eye_angle) * 2
        self.eye_white.x = MathUtils.lerp(self.eye_white.x, eye_start_x + self.eye_target_x / 5, 0.2 * DTMULT)
        self.eye_white.y = MathUtils.lerp(self.eye_white.y, eye_start_y + self.eye_target_y / 5, 0.2 * DTMULT)
        self.eye_pupil.x = MathUtils.lerp(self.eye_pupil.x, eye_start_x + self.eye_target_x, 0.2 * DTMULT)
        self.eye_pupil.y = MathUtils.lerp(self.eye_pupil.y, eye_start_y + self.eye_target_y, 0.2 * DTMULT)
    end
end

return WingladeActorSprite