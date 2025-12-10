---@class Event.bell_button : Event
local event, super = Class(Event, "climbwaterbucket")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.generator = properties["generate"] or false
	self:setOrigin(0, 0.5)
    self:setSprite("world/events/climbwater/climb_waterbucket")
	self.buffer = 0
	self:setHitbox(0, 0, 40, 40)
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
end

function event:update()
    super.update(self)
	if self.generator then
		self.drawwater = self.drawwater - DTMULT
		if Game.world.player and Game.world.player:isMovementEnabled() then
			self.timer = self.timer + DTMULT
			local waterspawntype = 1
			if self.remote then
				waterspawntype = 2
			end
			if waterspawntype == 1 then
				if MathUtils.round(self.timer) == self.waittime - 6 then
					local splash = Sprite("world/events/climbwater/climb_waterbucket_splash")
					splash:play(3 / 30, false, function () splash:remove() end)
					splash:setOrigin(0, 1)
					splash:setScale(2, -2)
					splash:setPosition(0, 20)
					splash.layer = self.layer + 0.1
					self:addChild(splash)
				end
				if MathUtils.round(self.timer) == self.waittime then
					local water = ClimbWater(self.x, self.y, 1, self.watermovetimer,
					self.watermoverate, self.watertilelimit, self.waterfallingtimer,
					self.waterdir, self.spawnrate, self.activetime)
					water.layer = self.layer + 0.1
					self.world:addChild(water)
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
				end
				if Utils.round(self.makewater) == 0 then
					local water = ClimbWater(self.x, self.y, 2, self.watermovetimer,
					self.watermoverate, self.watertilelimit, self.waterfallingtimer,
					self.waterdir, self.spawnrate, self.activetime)
					water.layer = self.layer + 0.1
					self.world:addChild(water)
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

return event