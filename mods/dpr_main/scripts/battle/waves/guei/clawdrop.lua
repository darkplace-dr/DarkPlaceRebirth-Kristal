local Aiming, super = Class(Wave)

function Aiming:init()
    super.init(self)

    self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = 0
	self.sameattacker = 0
	if #self.enemies > 1 then
		self.sameattack = #self.enemies-1
	end
	self.ratio = 1
	if #Game.battle.enemies == 2 then
		self.ratio = 1.6
	elseif #Game.battle.enemies == 3 then
		self.ratio = 2.3
	end
end

function Aiming:onStart()
	self.notsameattacker = false
	Game:setFlag("gueiClawDrop", 0)
	for i = 1, #self.enemies do
		if self.sameattack >= 1 then
			if not self.notsameattacker then
				self.sameattacker = Game:getFlag("gueiClawDrop", 0)
				self.notsameattacker = true
			end
			Game:setFlag("gueiClawDrop", Game:getFlag("gueiClawDrop", 0)+1)
		end
	end
    -- Every 0.5 seconds...
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
		if self.sameattacker < 1 then
			xx = Game.battle.arena.x - 40 + love.math.random(80)
			yy = Game.battle.arena.y - 160
			if love.math.random(4) == 0 or aim_override == 4 then
				temp_angle = math.rad(254 + love.math.random(32))
				aim_override = 0
			else
				temp_angle = Utils.angle(xx, yy, Game.battle.soul.x, Game.battle.soul.y)
				aim_override = aim_override + 1
			end
		else
			xx = Game.battle.arena.x + 160 * side
			yy = Game.battle.arena.y - 60 + ove.math.random(120)
			if love.math.random(4) == 0 then
				temp_angle = math.rad((90 + (side * 90) - 16) + love.math.random(32))
				aim_override = 0
			else
				temp_angle = Utils.angle(xx, yy, Game.battle.soul.x, Game.battle.soul.y)
				aim_override = aim_override + 1
			end
		end
		if self.sameattacker ~= 2 then
			local sm = 0
			if self.sameattack == 2 then
				sm = 1
			end
			for i = 0,2-sm do
				local bul
				if self.sameattacker == 0 then
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
				Game.battle.timer:tween(10/30, bul, {alpha = 1}, "linear")
				self.timer:after(15/30, function()
					bul.physics.friction = -0.85
					Game.battle.timer:tween(13/30, bul, {scale_x = 2.75}, "linear")
					Game.battle.timer:tween(13/30, bul, {scale_y = 0.5}, "linear")
				end)
				self.timer:after(30/30, function()
					bul.physics.friction = 1.2
					Game.battle.timer:tween(10/30, bul, {scale_x = 1}, "linear")
					Game.battle.timer:tween(10/30, bul, {scale_y = 1}, "linear")
				end)
				self.timer:after(35/30, function()
					bul.physics.friction = 0
				end)
				self.timer:after(40/30, function()
					Game.battle.timer:tween(10/30, bul, {alpha = 0}, "linear")
				end)
			end
		end
    end)
end

function Aiming:update()
    -- Code here gets called every frame

    super.update(self)
end

return Aiming