local LightRudeBusterBeam, super = Class(Sprite, "LightRudeBusterBeam")

function LightRudeBusterBeam:init(red, x, y, target_x, target_y)
    super.init(self, red and "effects/rudebuster/beam_red" or "effects/rudebuster/beam", x, y)

    self:setOrigin(0.5)
    if red then
        self:setScale(5)
    else
        self:setScale(4)
    end

    self:play(1/30, true)

    self.layer = BATTLE_LAYERS["above_ui"]

    self.target_x = target_x
    self.target_y = target_y
    self.red = red

    self.rotation = Utils.angle(self.x, self.y, self.target_x, self.target_y)
    self.physics.speed = 8
    self.physics.friction = -3
    self.physics.match_rotation = true

    self.alpha = 0

    self.afterimg_timer = 0
end

function LightRudeBusterBeam:update()
    self.alpha = Utils.approach(self.alpha, 1, 0.25 * DTMULT)
    self:setScale(Utils.approach(self:getScale(), 2, 0.2 * DTMULT))

    self.afterimg_timer = self.afterimg_timer + DTMULT
    if self.afterimg_timer >= 1 then
        self.afterimg_timer = 0

        local sprite = Sprite(self.red and "effects/rudebuster/beam_red" or "effects/rudebuster/beam", self.x, self.y)
        sprite:fadeOutSpeedAndRemove()
        sprite:setOrigin(0.5)
        if self.red then
            sprite:setScale(2.4, 2.2)
        else
            sprite:setScale(2, 1.8)
        end
        sprite.rotation = self.rotation
        sprite.alpha = self.alpha - 0.2
        sprite.layer = self.layer - 0.01
        sprite.graphics.grow_y = -0.1
        sprite.graphics.remove_shrunk = true
        sprite:play(1/15, true)
        self.parent:addChild(sprite)
    end

    super.update(self)
end

return LightRudeBusterBeam