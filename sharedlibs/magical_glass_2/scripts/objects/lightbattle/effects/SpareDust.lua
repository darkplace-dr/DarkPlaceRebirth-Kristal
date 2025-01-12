local SpareDust, super = Class(Sprite, "SpareDust")

function SpareDust:init(x, y, rightside, topside)
    super.init(self, "effects/spare/dustcloud", x, y)

    self.layer = BATTLE_LAYERS["above_ui"] + 3

    self.rightside = rightside
    self.topside = topside

    self:play(5/30, false, function(sprite) sprite:remove() end)

    self.physics.friction = 0.8

    self:setScale(Utils.random(0, 1, 1) + 0.7)

    Game.battle.timer:after(1/30, function()
        self:spread()
    end)
end

function SpareDust:spread()
    self.physics.direction = math.rad(Utils.random(360)) -- why

    local low = 0.75
    local high = 1.25

    if self.rightside < low then
        self.physics.direction = math.rad(180)
    end
    if self.rightside > high then
        self.physics.direction = math.rad(0)
    end
    if self.topside > high and self.rightside > high then
        self.physics.direction = math.rad(45)
    end
    if self.topside > high and self.rightside > low and self.rightside < high then
        self.physics.direction = math.rad(90)
    end
    if self.topside > high and self.rightside < low then
        self.physics.direction = math.rad(135)
    end
    if self.topside < low and self.rightside > high then
        self.physics.direction = math.rad(315)
    end
    if self.topside < low and self.rightside > low and self.rightside < high then
        self.physics.direction = math.rad(270)
    end
    if self.topside < low and self.rightside < low then
        self.physics.direction = math.rad(235)
    end
    
    self.physics.speed = 8
end

function SpareDust:update()
    self.alpha = self.alpha - 0.03 * DTMULT

    super.update(self)
end

return SpareDust