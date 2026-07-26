local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)

    self.time = 7
end

function Basic:onStart()
	local attackers = self:getAttackers()
	self.racket1bullet = nil
	self.racket2bullet = nil

	for i = 1, #attackers do
		self:spawnBullet("balldudebullet", Game.battle.arena:getRight() - 16, Game.battle.arena:getTop() + 16 + ((i - 1) * 20), 0, 0)
	end

	if Game.battle.racket1 then
        Game.battle.racket1 = false
		self.racket1bullet = self:spawnBullet("racket1", Game.battle.soul.x + 16, Game.battle.soul.y - 8, 0, 0)
	end
	if Game.battle.racket2 then
        Game.battle.racket2 = false
		self.racket2bullet = self:spawnBullet("racket2", Game.battle.soul.x - 16, Game.battle.soul.y - 8, 0, 0)
	end
end

function Basic:update()

    super.update(self)
end

return Basic