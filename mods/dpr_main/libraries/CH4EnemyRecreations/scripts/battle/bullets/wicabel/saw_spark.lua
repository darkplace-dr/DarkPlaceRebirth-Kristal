local SawSpark, super = Class(Bullet)

function SawSpark:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/wicabel/spark")

    self:setScale(1)
    self:setOriginExact(6, 6)
	
	self.sprite:play(1/30)
	self:setSpeed(speed or 2)
	self.physics.direction = -math.rad(dir) or -math.rad(0)

    self.tp = 0.4
    self.time_bonus = 1
    self.damage = 10
    self.inv_frames = 60
	
    self.spin = false
    self.spinspeed = 0
end

function SawSpark:onAdd(parent)
    super.onAdd(self, parent)

    self.spinspeed = -self.physics.speed_y
    self.spin = true
    Game.stage.timer:after(45/30, function() self:remove() end)
    Game.stage.timer:after(1, function() 
        self:setColor(ColorUtils.hexToRGB("#808080"))
        self.collidable = false
        Game.stage.timer:lerpVar(self, "scale_x", 1, 0, 15)
        Game.stage.timer:lerpVar(self, "scale_y", 1, 0, 15)
    end)
end

function SawSpark:update()
    if self.spin == true  then
        self.rotation = self.rotation + -math.rad(self.spinspeed) * DTMULT
    end

    super.update(self)
end

return SawSpark