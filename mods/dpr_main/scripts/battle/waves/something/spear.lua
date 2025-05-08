local BandeeSpearThrow, super = Class(Wave)

function BandeeSpearThrow:init()
    super.init(self)
    self.time = 5
	self.intensity = 11
end

function BandeeSpearThrow:onStart()
	local attackers = self:getAttackers()
	for _, attacker in ipairs(attackers) do
		-- Get the attacker's center position
		local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

		-- Get the angle between the bullet position and the soul's position
		local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

		-- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
		self:spawnBullet("spear_thrown", x, y, angle - math.rad(10), self.intensity)
		self:spawnBullet("spear_thrown", x, y, angle + math.rad(5), self.intensity)
		self:spawnBullet("spear_thrown", x, y, angle + math.rad(20), self.intensity)
		self:spawnBullet("spear_thrown", x, y, angle + math.rad(35), self.intensity)
		self:spawnBullet("spear_thrown", x, y, angle + math.rad(50), self.intensity)
		Assets.playSound("laz_c")
		self.intensity = self.intensity + 1
	end
	-- Every 0.5 seconds...
	local attackers = self:getAttackers()
	self.timer:every((0.7), function()
        -- Loop through all attackers
		self.timer:script(function(wait)
			for _, attacker in ipairs(attackers) do

				-- Get the attacker's center position
				local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

				-- Get the angle between the bullet position and the soul's position
				local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

				-- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
				self:spawnBullet("spear_thrown", x, y, angle - math.rad(10), self.intensity)
				self:spawnBullet("spear_thrown", x, y, angle + math.rad(5), self.intensity)
				self:spawnBullet("spear_thrown", x, y, angle + math.rad(20), self.intensity)
				self:spawnBullet("spear_thrown", x, y, angle + math.rad(35), self.intensity)
				self:spawnBullet("spear_thrown", x, y, angle + math.rad(50), self.intensity)
				Assets.playSound("laz_c")
				self.intensity = self.intensity + 1
			end
		end)

    end)
end

function BandeeSpearThrow:update()
    -- Code here gets called every frame

    super.update(self)
end

return BandeeSpearThrow
