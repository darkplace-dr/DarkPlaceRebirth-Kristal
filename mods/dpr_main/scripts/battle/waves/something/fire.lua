local WarnedFire, super = Class(Wave)

function WarnedFire:init()
	super.init(self)
	self:setArenaSize(284, 284)
end

function WarnedFire:onStart()
	-- Setting the X to the center of the arena so the warning spawns in the middle of it
	local arenacenter = Game.battle.arena.left + Game.battle.arena.right
	local x = arenacenter / 2
	-- Getting a random Y position inside the arena
	local y = Utils.random(Game.battle.arena.top + 35.5, Game.battle.arena.bottom - 35.5)
	self.timer:script(function(wait)
		--wait(0.5)
		-- Spawns the warning and makes it flicker, creating a sound each time it does
		Assets.playSound("mtt_prebomb")
		local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
		wait(0.1)
		Assets.playSound("mtt_prebomb")
		bullet:remove()
		wait(0.1)
		Assets.playSound("mtt_prebomb")
		local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
		wait(0.1)
		Assets.playSound("mtt_prebomb")
		bullet:remove()
		wait(0.1)
		Assets.playSound("mtt_prebomb")
		local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
		wait(0.1)
		Assets.playSound("mtt_prebomb")
		bullet:remove()
		-- A new X position for the bullets, which spawn offscreen
		local newx = SCREEN_WIDTH + 20
		-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
		local newy = Utils.random(y + 35.5, y - 35.5)
		local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
		-- Dont remove the bullet offscreen, because we spawn it offscreen
		newbullet.remove_offscreen = false
		-- A new X position for the bullets, which spawn offscreen
		local newx = SCREEN_WIDTH + 20
		-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
		local newy = Utils.random(y + 35.5, y - 35.5)
		local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
		-- Dont remove the bullet offscreen, because we spawn it offscreen
		newbullet.remove_offscreen = false
		-- A new X position for the bullets, which spawn offscreen
		local newx = SCREEN_WIDTH + 20
		-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
		local newy = Utils.random(y + 35.5, y - 35.5)
		local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
		-- Dont remove the bullet offscreen, because we spawn it offscreen
		newbullet.remove_offscreen = false
		self.timer:every(0.5, function()
			-- A new X position for the bullets, which spawn offscreen
			local newx = SCREEN_WIDTH + 20
			-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
			local newy = Utils.random(y + 35.5, y - 35.5)
			local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
			-- Dont remove the bullet offscreen, because we spawn it offscreen
			newbullet.remove_offscreen = false
		end)

	end)
	self.timer:every(0.5, function()
		local arenacenter = Game.battle.arena.left + Game.battle.arena.right
		local x = arenacenter / 2
		-- Getting a random Y position inside the arena
		local y = Utils.random(Game.battle.arena.top + 35.5, Game.battle.arena.bottom - 35.5)
		self.timer:script(function(wait)
			--wait(0.5)
			-- Spawns the warning and makes it flicker, creating a sound each time it does
			Assets.playSound("mtt_prebomb")
			local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
			wait(0.1)
			Assets.playSound("mtt_prebomb")
			bullet:remove()
			wait(0.1)
			Assets.playSound("mtt_prebomb")
			local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
			wait(0.1)
			Assets.playSound("mtt_prebomb")
			bullet:remove()
			wait(0.1)
			Assets.playSound("mtt_prebomb")
			local bullet = self:spawnBullet("firewarning", x, y, math.rad(180), 0)
			wait(0.1)
			Assets.playSound("mtt_prebomb")
			bullet:remove()
			-- A new X position for the bullets, which spawn offscreen
			local newx = SCREEN_WIDTH + 20
			-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
			local newy = Utils.random(y + 35.5, y - 35.5)
			local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
			-- Dont remove the bullet offscreen, because we spawn it offscreen
			newbullet.remove_offscreen = false
			-- A new X position for the bullets, which spawn offscreen
			local newx = SCREEN_WIDTH + 20
			-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
			local newy = Utils.random(y + 35.5, y - 35.5)
			local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
			-- Dont remove the bullet offscreen, because we spawn it offscreen
			newbullet.remove_offscreen = false
			-- A new X position for the bullets, which spawn offscreen
			local newx = SCREEN_WIDTH + 20
			-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
			local newy = Utils.random(y + 35.5, y - 35.5)
			local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
			-- Dont remove the bullet offscreen, because we spawn it offscreen
			newbullet.remove_offscreen = false
			self.timer:every(0.5, function()
				-- A new X position for the bullets, which spawn offscreen
				local newx = SCREEN_WIDTH + 20
				-- Gets a new Y position wich is randomly chosen from the Y positions of the warning
				local newy = Utils.random(y + 35.5, y - 35.5)
				local newbullet = self:spawnBullet("smallflame", newx, newy, math.rad(180), 16)
				-- Dont remove the bullet offscreen, because we spawn it offscreen
				newbullet.remove_offscreen = false
			end)

		end)
	end)
end

function WarnedFire:update()
    -- Code here gets called every frame

    super.update(self)
end

return WarnedFire
