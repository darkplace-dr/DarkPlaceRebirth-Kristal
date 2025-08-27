local Reticle, super = Class(Bullet)

function Reticle:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/darkclone/brenda/reticle")

    self.damage = 0
    self.destroy_on_hit = false
    self.can_graze = false
	
    self.physics.direction = dir
    self.physics.speed = speed
	
	self.alpha = 1
end

function Reticle:update()
    if self.state ~= "AIMED" then
        local newX = (self.x + Game.battle.soul.x)/2
        local newY = (self.y + Game.battle.soul.y)/2
        self.x = newX
        self.y = newY
    end

    super.update(self)
end

return Reticle