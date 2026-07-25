local Racket2, super = Class(Bullet)

function Racket2:init(x, y, dir, speed)
    super.init(self, x, y, "battle/bullets/tennisracket")

    self.physics.direction = dir
    self.physics.speed = speed

	self.can_graze = false
	self.destroy_on_hit = false
	self.time_bonus = 0

	--self.collider = Collider(self, Hitbox(self, 0, 0, 16, 24))
end

function Racket2:update()
	self.x = Game.battle.soul.x - 16
	self.y = Game.battle.soul.y - 24

    super.update(self)
end

function Racket2:onCollide(soul)
	-- don't deal damage
end

return Racket2