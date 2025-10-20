local PipisDefusal, super = Class(Wave)

function PipisDefusal:init()
    super.init(self)
	
	self.time = -1
	self:setArenaSize(110, 240)
	self:setArenaPosition(230, 175)
end

function PipisDefusal:onStart()
    self.timer:script(function(wait)
		local omega = Game.battle.enemies[1]
		local arena = Game.battle.arena
		self.timer:tween(0.2, omega, {y = 720}, "linear")
		wait(1)
		self:spawnObject(GigaPipisBomb(), arena.right+40, arena.y-100)
	end)
end

function PipisDefusal:onEnd()
end

return PipisDefusal