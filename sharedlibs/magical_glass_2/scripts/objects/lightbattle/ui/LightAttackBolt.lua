local LightAttackBolt, super = Class(Object, "LightAttackBolt")

function LightAttackBolt:init(x, scale_y, color, start_inactive)
    super.init(self, x, 0)

    self.scale_y = scale_y or 1

    self.layer = BATTLE_LAYERS["above_ui"]

    self.active_tex = "ui/lightbattle/targetchoice"
    self.inactive_tex = "ui/lightbattle/targetchoice_2"
    self.fade_tex = "ui/lightbattle/targetchoice_fade"

    self:setColor(color or COLORS.white)

    self:setOrigin(0.5, 0)

    self.sprite = Sprite(self.active_tex)
    if start_inactive and start_inactive ~= nil then
        self.sprite:setSprite(self.inactive_tex)
    end
    self.sprite.inherit_color = true
    self.sprite:setScaleOrigin(0.5)
    self:addChild(self.sprite)

    self.width = self.sprite.width
    self.height = self.sprite.height

    self.bursting = false
    self.perfect = false
    self.fading = false

    self.flash_speed = 1/15
    self.fade_speed = 0.2
    self.burst_speed = 0.1
end

function LightAttackBolt:flash()
    self:resetPhysics()

    self.sprite:play(self.flash_speed, true)
end

function LightAttackBolt:fade()
    self.fading = true
end

function LightAttackBolt:activate()
    self.sprite:setSprite(self.active_tex)
end

function LightAttackBolt:burst()
    self:resetPhysics()

    self.sprite:setSprite(self.fade_tex)
    self.bursting = true
end

function LightAttackBolt:update()
    if self.fading then
        self.alpha = self.alpha - (self.fade_speed * DTMULT)
        if self.alpha < 0.1 then
            self:remove()
        end
    end

    if self.perfect then
        local color = Utils.round((Kristal.getTime() * 30) % 2)

        if color == 0 then
            self:setColor(192/255, 0, 0)
        elseif color == 1 then
            self:setColor(128/255, 1, 1)
        elseif color == 2 then
            self:setColor(1, 1, 64/255)
        end
    end

    if self.bursting then
        self.alpha = self.alpha - self.burst_speed * DTMULT
        if self.alpha < (0 + self.burst_speed) then
            self:remove()
        end
        self.sprite.scale_x = self.sprite.scale_x + self.burst_speed * DTMULT
        self.sprite.scale_y = self.sprite.scale_y + self.burst_speed * DTMULT
    end

    super.update(self)
end

return LightAttackBolt