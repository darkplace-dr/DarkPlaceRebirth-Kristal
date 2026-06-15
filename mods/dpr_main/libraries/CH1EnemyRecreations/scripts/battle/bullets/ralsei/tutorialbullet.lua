local TutorialBullet, super = Class(Bullet)

function TutorialBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/smallbullet")
    self:setScale(0)

    self.collidable = false
    self.alpha = 0
    self.damage = 1

    self.grazed = false
    self.tp = 2
    self.time_bonus = 5

    self.inv_timer = 120/30

    self.special = 0
end

function TutorialBullet:onAdd(parent)
    super.onAdd(self, parent)

    if self.y < 50 then
        self.y = 50
    end

    local afterimage = Sprite("battle/bullets/smallbullet_outline", self.x, self.y)
    afterimage.alpha = 1.4
    afterimage:setLayer(self.layer - 1)
    afterimage:setScale(0)
    afterimage:setOrigin(0.5, 0.5)
    afterimage.graphics.grow = 0.25
    afterimage:fadeOutSpeedAndRemove(0.1)
    Game.battle:addChild(afterimage)

    Game.battle.timer:after(20/30, function()
        if Game.battle.soul then
            self.physics.direction = MathUtils.angle(self.x, self.y, Game.battle.soul.x, Game.battle.soul.y)
            self:setSpeed(6)

            if self.special == 1 then
                self:setSpeed(-self.physics.speed)
            end
        end
    end)
end

function TutorialBullet:update()
    if self.scale_x <= 2 then
        self.scale_y = self.scale_y + (0.2 * DTMULT)
        self.scale_x = self.scale_x + (0.2 * DTMULT)
        self.alpha = self.alpha + (0.2 * DTMULT)
    
        if self.scale_x >= 2 then
            self.collidable = true
        end
    end

    super.update(self)
end

return TutorialBullet