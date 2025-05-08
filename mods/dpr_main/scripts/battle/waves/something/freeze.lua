local DiamondsAim, super = Class(Wave)

function DiamondsAim:init()
	super.init(self)
	self:setArenaSize(70, 140)
end

function DiamondsAim:onStart()
	-- Our X position is offscreen, to the right
	local x = SCREEN_WIDTH + 20
	-- Get a random Y position between the top and the bottom of the arena
	local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)
	if Utils.random(0,1) <= 0.5 then
		self:spawnBullet("ice", x, Game.battle.arena.top + 20, math.rad(180), 6)
		self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
		self:spawnBullet("ice_b", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
		self:spawnBullet("ice", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
	else
		self:spawnBullet("ice", x, Game.battle.arena.top + 20, math.rad(180), 6)
		self:spawnBullet("ice_b", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
		self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
		self:spawnBullet("ice", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
	end
    self.timer:every(1.2, function()
        -- Our X position is offscreen, to the right
        local x = SCREEN_WIDTH + 20
        -- Get a random Y position between the top and the bottom of the arena
        local y = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
		if Utils.random(0,1) <= 0.5 then
			if Utils.random(0,1) <= 0.5 then
				self:spawnBullet("ice_b", x, Game.battle.arena.top + 20, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
				self:spawnBullet("ice", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
			else
				self:spawnBullet("ice", x, Game.battle.arena.top + 20, math.rad(180), 6)
				self:spawnBullet("ice_b", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
				self:spawnBullet("ice", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
			end
		else
			if Utils.random(0,1) <= 0.5 then
				self:spawnBullet("ice", x, Game.battle.arena.top + 20, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
				self:spawnBullet("ice_b", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
				self:spawnBullet("ice", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
			else
				self:spawnBullet("ice", x, Game.battle.arena.top + 20, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 - 15, math.rad(180), 6)
				self:spawnBullet("ice", x, (Game.battle.arena.top + Game.battle.arena.bottom)/2 + 15, math.rad(180), 6)
				self:spawnBullet("ice_b", x, Game.battle.arena.bottom - 20, math.rad(180), 6)
			end
		end
    end)
end

return DiamondsAim