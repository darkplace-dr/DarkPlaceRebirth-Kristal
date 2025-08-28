local Powder, super = Class(Bullet)

function Powder:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/darkclone/brenda/powder")
    self:setScale(1)

    self.damage = 0
    self.destroy_on_hit = false
    self.can_graze = false
	
    self.physics.direction = dir
    self.physics.speed = speed
	
	self.alpha = 0
end

function Powder:update()
    if self.alpha < 0.7 and self.state ~= "FADEOUT" then
        self.alpha = self.alpha + 0.02 * DTMULT
    end
    if self.alpha > 0 and self.state == "FADEOUT" then
        self.alpha = self.alpha - 0.02 * DTMULT
    end

    super.update(self)
end

return Powder