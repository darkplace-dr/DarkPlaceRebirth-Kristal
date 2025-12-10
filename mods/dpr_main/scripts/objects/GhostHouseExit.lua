local GhostHouseExit, super = Class(Object)

function GhostHouseExit:init(x, y, width, height)
    super.init(self, x, y, width, height)
    self:setOrigin(0.5, 0.5)
	self.collider = Hitbox(self, 0, 0, width, height)
	self.damage = 0
end

function GhostHouseExit:getDamage()
	return 0
end

function GhostHouseExit:createExitArrow()
	for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
		local side = MathUtils.sign(lock.width)
		local exit_arrow = GhostHouseExitArrow(lock.x + 32 * side, lock.y + lock.height/2 - lock.offsety)
		exit_arrow:setLayer(self.layer)
		exit_arrow.timer = 0
		exit_arrow.rotation = 0
		exit_arrow.scale_x = exit_arrow.scale_x * side
		Game.battle.timer:tween(1, exit_arrow, {alpha = 1}, "in-linear")
		Game.battle:addChild(exit_arrow)
	end
end

function GhostHouseExit:onCollide(soul)
	super.onCollide(soul)
	Game.battle.finished_waves = true
    Game.battle.encounter:onWavesDone()
end

function GhostHouseExit:update()
    super.update(self)
end

return GhostHouseExit