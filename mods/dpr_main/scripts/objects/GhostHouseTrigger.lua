local GhostHouseTrigger, super = Class(Object)

function GhostHouseTrigger:init(x, y, width, height, active)
    super.init(self, x, y, width, height)
    self:setOrigin(0, 0)
	self.collider = Hitbox(self, 0, 0, width, height)
	self.active = active or false
	self.damage = 0
end

function GhostHouseTrigger:getDamage()
	return 0
end

function GhostHouseTrigger:onCollide(soul)
	super.onCollide(soul)
	if self.active then
		self.active = false
		for _,bullet in ipairs(self.wave.bullets) do
			if bullet:isBullet("jackenstein/jackolantern") then
				bullet.pause = true
			end
		end
		local x = self.wave.pumpkin_x or SCREEN_WIDTH/2
		local y = self.wave.pumpkin_y or SCREEN_HEIGHT/2
		local ptype = self.wave.pumpkin_type or 0
		self.wave:spawnBullet("jackenstein/jackolantern", x, y, ptype)
		for _,arena in ipairs(Game.stage:getObjects(GhostHouseArena)) do
			arena:setColor(COLORS["yellow"])
		end
		for _,lock in ipairs(Game.stage:getObjects(GhostHouseLock)) do
			lock:setColor(COLORS["yellow"])
		end
		self:remove()
	end
end

function GhostHouseTrigger:update()
    super.update(self)
end

return GhostHouseTrigger