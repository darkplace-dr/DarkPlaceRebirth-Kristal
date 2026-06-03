---@class Chapter4Lib.ClimbWaterBucket : Event
---@field generator boolean *[Property `generate`]* Whether the bucket generates water rather than stopping it (Defaults to `false`)
---@field remote boolean *[Property `remote`]* Needs description! (Defaults to `false`)
---@field timer number *[Property `timer`]* Timer used for waiting to spawn water. Property can be used to add an offset to the cycle, like the phase of a wave. (Defaults to `0`)
---@field waittime number *[Property `waittime`]* Needs description! (Defaults to `60`)
---@field activetime number *[Property `activetime`]* Needs description! (Defaults to `60`)
---@field spawnrate number *[Property `spawnrate`]* Needs description! (Defaults to `4`)
---@field watermovetimer number *[Property `watermovetimer`]* Needs description! (Defaults to `0`)
---@field watermoverate number *[Property `watermoverate`]* Needs description! (Defaults to `4`)
---@field watertilelimit number *[Property `watertilelimit`]* Needs description! (Defaults to `12`)
---@field waterfallingtimer number *[Property `waterfallingtimer`]* Needs description! (Defaults to `12`)
local ClimbWaterBucket, super = Class(Event, "ClimbWaterBucket")

function ClimbWaterBucket:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.generator = properties["generate"] or false
	self:setOrigin(0, 0.5)
    self:setSprite("world/events/climbwater/climb_waterbucket")
	self.buffer = 0
	self:setHitbox(5, 0, 30, 40)
	self.drawwater = 0
	self.makewater = 0
	self.con = 0
	self.remote = properties["remote"] or false
	self.timer = properties["timer"] or 0
	self.waittime = properties["waittime"] or 60
	self.activetime = properties["activetime"] or 60
	self.spawnrate = properties["spawnrate"] or 4
	self.watermovetimer = properties["watermovetimer"] or 0
	self.watermoverate = properties["watermoverate"] or 4
	self.watertilelimit = properties["watertilelimit"] or 12
	self.waterfallingtimer = properties["waterfallingtimer"] or 12
	self.waterdir = properties["waterdir"] or "down"
	if self.generator then
		self:setScale(self.scale_x, -self.scale_y)
	end
	if Game.world.map.cyltower then
		self.visible = false
		self.x = self.x + 40
	end
	self.climb_obstacle = true
	self.stoptimerconds = nil
end

function ClimbWaterBucket:update()
    super.update(self)
	self.drawwater = self.drawwater - DTMULT
	if self.generator then
		if Game.world.player and Game.world.player:isMovementEnabled() then
			self.timer = self.timer + DTMULT
			local waterspawntype = 1
			if self.remote then
				waterspawntype = 2
			end
			if self.stoptimerconds == nil then
				if waterspawntype == 1 then
					if MathUtils.round(self.timer) == self.waittime - 6 then
						if self.world.map.cyltower then
							self.drawwater = MathUtils.round(3 * #Assets.getFrames("world/events/climbwater/climb_waterbucket_splash"))
						else
							local splash = Sprite("world/events/climbwater/climb_waterbucket_splash")
							splash:play(3 / 30, false, function () splash:remove() end)
							splash:setOrigin(0, 1)
							splash:setScale(2, -2)
							splash:setPosition(0, 20)
							splash.layer = self.layer + 0.1
							self:addChild(splash)
							if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
								self.stoptimerconds = self.timer
							end
						end
					end
					if MathUtils.round(self.timer) == self.waittime then
						local water = ClimbWater(self.x, self.y, 1, self.watermovetimer,
						self.watermoverate, self.watertilelimit, self.waterfallingtimer,
						self.waterdir, self.spawnrate, self.activetime)
						water.layer = self.world.player.layer + 0.01
						self.world:addChild(water)
						if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
							self.stoptimerconds = self.timer
						end
					end
				end
				if waterspawntype == 2 then
					self.makewater = self.makewater - DTMULT
					if MathUtils.round(self.makewater) == 6 then
						local splash = Sprite("world/events/climbwater/climb_waterbucket_splash")
						splash:play(3 / 30, false, function () splash:remove() end)
						splash:setOrigin(0, 1)
						splash:setScale(2, 2)
						splash:setPosition(0, 20)
						splash.layer = self.layer + 0.1
						self:addChild(splash)
						if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
							self.stoptimerconds = self.timer
						end
					end
					if MathUtils.round(self.makewater) == 0 then
						local water = ClimbWater(self.x, self.y, 2, self.watermovetimer,
						self.watermoverate, self.watertilelimit, self.waterfallingtimer,
						self.waterdir, self.spawnrate, self.activetime)
						water.layer = self.world.player.layer + 0.01
						self.world:addChild(water)
						if FRAMERATE > 30 or (FRAMERATE == 0 and FPS > 30) then
							self.stoptimerconds = self.timer
						end
					end
				end
			end
			if self.timer >= self.waittime + self.activetime then
				self.timer = 0
			end
		end
	else
		self.buffer = self.buffer - DTMULT
		Object.startCache()
		for _, wat in ipairs(Game.stage:getObjects(ClimbWater)) do
			if wat.collider and wat:collidesWith(self) then
				if wat.y < wat.endy - 10 then
					self.buffer = 1
				end
				if not wat.ending then
					wat.ending = true
				end
			end
		end
		Object.endCache()
		if MathUtils.round(self.buffer) == 0 then
			if self.world.map.cyltower then
				self.drawwater = MathUtils.round(3 * #Assets.getFrames("world/events/climbwater/climb_waterbucket_splash"))
			else
				local splash = Sprite("world/events/climbwater/climb_waterbucket_splash")
				splash:play(3 / 30, false, function () splash:remove() end)
				splash:setOrigin(0, 1)
				splash:setScale(2, 2)
				splash:setPosition(0, 20)
				splash.layer = splash.layer + 0.01
				self:addChild(splash)
			end
		end
	end
	if self.stoptimerconds ~= nil and self.timer >= self.stoptimerconds+0.6 then
		self.stoptimerconds = nil
	end
end

return ClimbWaterBucket
