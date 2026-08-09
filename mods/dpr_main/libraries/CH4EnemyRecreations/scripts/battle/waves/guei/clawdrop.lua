local ClawDrop, super = Class(Wave)

function ClawDrop:init()
    super.init(self)

    self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = #self.enemies
	self.ratio = 1
	if #Game.battle.enemies == 2 then
		self.ratio = 1.6
	elseif #Game.battle.enemies == 3 then
		self.ratio = 2.3
	end
end

function ClawDrop:onStart()
    -- Every 0.5 seconds...
	for sameattacker = 0, #self.enemies-1 do
		self.timer:everyInstant((12*self.ratio)/30, function()
			-- Get all enemies that selected this wave as their attack
			local spawned = {}
			local swipe_width = 50 + self.sameattack * 5
			if #Game.battle:getActiveEnemies() > self.sameattack then
				swipe_width = swipe_width + 40 - 10 * self.sameattack
			end
			local aim_override = 0
			local side = Utils.pick({-1, 1})
			local xx, yy, tempangle
			if sameattacker < 1 then
				xx = Game.battle.arena.x - 40 + MathUtils.randomInt(80)
				yy = Game.battle.arena.y - 160
				if MathUtils.randomInt(4) == 0 or aim_override == 4 then
					temp_angle = -math.rad(254 + MathUtils.randomInt(32))
					aim_override = 0
				else
					temp_angle = Utils.angle(xx, yy, Game.battle.soul.x, Game.battle.soul.y)
					aim_override = aim_override + 1
				end
			else
				xx = Game.battle.arena.x + 160 * side
				yy = Game.battle.arena.y - 60 + MathUtils.randomInt(120)
				if MathUtils.randomInt(4) == 0 then
					temp_angle = -math.rad((90 + (side * 90) - 16) + MathUtils.randomInt(32))
					aim_override = 0
				else
					temp_angle = Utils.angle(xx, yy, Game.battle.soul.x, Game.battle.soul.y)
					aim_override = aim_override + 1
				end
			end
			if sameattacker ~= 2 then
				local sm = 0
				if self.sameattack == 2 then
					sm = 1
				end
				for i = 0,2-sm do
					local bul
					if sameattacker == 0 then
						bul = self:spawnBullet("guei/diamondbullet", (xx - (swipe_width * side)) + (i * (swipe_width * side)), yy, temp_angle, 3, temp_angle)
					else
						bul = self:spawnBullet("guei/diamondbullet", xx, (yy - (swipe_width * side)) + (i * (swipe_width * side)), temp_angle, 3, temp_angle)
					end
					bul.alpha = 0
					if i == 1 then
						bul.physics.speed = 2
					end
					bul.physics.friction = -0.05
					table.insert(spawned, bul)
					Game.stage.timer:lerpVar(bul, "alpha", 0, 1, 10)
					self.timer:after(15/30, function()
						bul.physics.friction = -0.85
						Game.stage.timer:lerpVar(bul, "scale_x", bul.scale_x, 2.75, 13)
						Game.stage.timer:lerpVar(bul, "scale_y", bul.scale_x, 0.5, 13)
					end)
					self.timer:after(30/30, function()
						bul.physics.friction = 1.2
						Game.stage.timer:lerpVar(bul, "scale_x", 2.75, 1, 10)
						Game.stage.timer:lerpVar(bul, "scale_y", 0.5, 1, 10)
					end)
					self.timer:after(35/30, function()
						bul.physics.friction = 0
					end)
					self.timer:after(40/30, function()
						Game.stage.timer:lerpVar(bul, "alpha", 1, 0, 10)
					end)
				end
			end
		end)
	end
end

function ClawDrop:update()
    -- Code here gets called every frame

    super.update(self)
end

return ClawDrop