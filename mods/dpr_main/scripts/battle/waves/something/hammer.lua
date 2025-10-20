local HammerSwing, super = Class(Wave)

function HammerSwing:init()
    super.init(self)
	self:setArenaSize(110, 440)
    self:setArenaOffset(0, 70)
end

function HammerSwing:onStart()
    -- Get all enemies that selected this wave as their attack
	local attackers = self:getAttackers()

	-- Loop through all attackers
	self.timer:script(function(wait)
		for _, attacker in ipairs(attackers) do

			-- Get the attacker's center position
			local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

			-- Get the angle between the bullet position and the soul's position
			local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

			-- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
			self:spawnBullet("hammerspark_sp", x, y, angle, 16)
			self:spawnBullet("smallddd", x, y, angle, 14)
			self:spawnBullet("smallddd", x, y, angle, 12)
			Assets.playSound("impact")
		end
	end)
	-- Every 0.5 seconds...
    self.timer:every(0.5, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
		self.timer:script(function(wait)
			for _, attacker in ipairs(attackers) do

				-- Get the attacker's center position
				local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

				-- Get the angle between the bullet position and the soul's position
				local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

				-- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
				self:spawnBullet("hammerspark_sp", x, y, angle, 16)
				self:spawnBullet("smallddd", x, y, angle, 14)
				self:spawnBullet("smallddd", x, y, angle, 12)
				Assets.playSound("impact")
			end
		end)

    end)
end

function HammerSwing:update()
    -- Code here gets called every frame

    super.update(self)
end

return HammerSwing
