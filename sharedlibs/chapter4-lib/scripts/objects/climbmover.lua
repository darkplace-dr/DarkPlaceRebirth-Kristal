---@class Event.climbcoin : Event
local ClimbMover, super = Class(Event, "ClimbMover")

function ClimbMover:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.marker = properties["marker"] or nil
	self.traveltime = properties["time"] or nil
	self.travelstyle = properties["style"] or 0
	self.oneway = properties["oneway"] or false
	self.exitflag = properties["exitflag"] or nil
	self.climb_obstacle = true
	if Game.world.map.cyltower then
		self.visible = false
	end
    self:setSprite("world/events/climbmover")
	self.con = 0
	self.timer = 0
	self.timercon = 0
	self.cyltimercon = 0
	self.movedwithclimb = 0
	self.init = false
	self.stick = false
	self.waittime = 5
	self.reset = false
	self.trigtype = 1
	self.xprediction = 0
	self.yprediction = 0
    self.climbable = true
	self.xlerp = nil
	self.ylerp = nil
	self.x1 = nil
	self.y1 = nil
	self.x2 = nil
	self.y2 = nil
	self.xtarg = 0
	self.ytarg = 0
end

function ClimbMover:onLoad()
    super.onLoad(self)
    if self.init == false then
		if not self.x1 then
			self.x1 = self.init_x
		end
		if not self.y1 then
			self.y1 = self.init_y
		end
		if self.marker then
			local mx, my = Game.world.map:getMarker(self.marker)
			if not self.x2 and mx then
				self.x2 = mx
			end
			if not self.y2 and my then
				self.y2 = my
			end
		end
		if not self.traveltime then
			self.traveltime = MathUtils.clamp(MathUtils.round(MathUtils.dist(self.x1, self.y1, self.x2, self.y2) / 12) + 1, 15, 60)
		end
		self.xtarg = self.x1
		self.ytarg = self.y1
		self.init = true
	end
end

function ClimbMover:update()
    super.update(self)
    local collider = Hitbox(self, 5, 5, 30, 30)
    if self.con == 0 then
        Object.startCache()
        if Game.world.player:collidesWith(collider) and Game.world.player.state == "CLIMB" and Game.world.player.neutralcon == 1 then
			Assets.playSound("noise")
            self.con = 2
			Game.lock_movement = true
			self.stick = true
			self.xprediction = self.x
			self.yprediction = self.y
			self.trigtype = 1
        end
        Object.endCache()
    end
    if self.con == 2 then
		self.timer = self.timer + DTMULT
		if self.timer >= (1 + self.waittime) and self.timercon == 0 then
			local ver = 0
			if self.xtarg == self.x2 and self.ytarg == self.y2 then
				ver = 1
			end
			local xtarg = self.x2
			local ytarg = self.y2
			if ver == 1 then
				xtarg = self.x1
				ytarg = self.y1
			end
			self.xtarg = xtarg
			self.ytarg = ytarg
			if self.travelstyle == 0 then
				self.xlerp = Game.world.timer:lerpVar(self, "x", self.x, xtarg, self.traveltime, 2, "out")
				self.ylerp = Game.world.timer:lerpVar(self, "y", self.y, ytarg, self.traveltime, -1, "in")
			end
			self.timercon = 1
		end
		if Game.world.map.cyltower then
			if self.timer >= self.waittime and self.cyltimercon == 0 then
				local ver = 0
				if self.xtarg == self.x2 and self.ytarg == self.y2 then
					ver = 1
				end
				local xtarg = self.x2
				local ytarg = self.y2
				self.movedwithclimb = 1 - ver
				if ver == 1 then
					xtarg = self.x1
					ytarg = self.y1
				end
				self.xprediction = self.x
				self.yprediction = self.y
				self.xlerp = Game.world.timer:lerpVar(self, "xprediction", self.x, xtarg, self.traveltime, 2, "out")
				self.ylerp = Game.world.timer:lerpVar(self, "yprediction", self.y, ytarg, self.traveltime, -1, "in")
				self.cyltimercon = 1
			end
			if self.timer > (1 + self.waittime) and self.timer <= (1 + self.waittime + self.traveltime) then
				local starttime = 1 + self.waittime
				local scale = 2 + (math.sin(math.min((self.timer - starttime) / (self.traveltime - starttime), 1) * math.pi) * 0.5)
				self.scale_x = scale
				self.scale_y = scale
			end
		end
		if self.timer >= (1 + self.traveltime + 1) and self.timercon == 1 then
			Assets.playSound("impact", 0.6, 1.2)
			Assets.playSound("noise", 0.7, 0.9)
			self.timercon = 2
		end
		if self.timer >= (1 + self.traveltime + (self.waittime * 2)) and self.timercon == 2 then
			self.con = 3
			self.timer = 0
			self.timercon = 0
			self.cyltimercon = 0
		end
	end
	if self.movedwithclimb == 1 and (Game.world.player.state ~= "CLIMB" or not Game.world.player.onrotatingtower) then
		self.xlerp = Game.world.timer:lerpVar(self, "x", self.x, self.x1, self.traveltime, 2, "out")
		self.ylerp = Game.world.timer:lerpVar(self, "y", self.y, self.y1, self.traveltime, -1, "in")
		self.movedwithclimb = 0
	end
	if self.con == 3 then
		if self.trigtype == 0 then
		else
			self.stick = false
			self.xtarg = self.xtarg
			self.ytarg = self.ytarg
			Game.world.player.x = self.x + 20
			Game.world.player.y = self.y + 40
			Game.world.player.scale_x = 2
			Game.world.player.scale_y = 2
			self.con = 3.1
			self.timer = 0
			Game.lock_movement = false
		end
	end
	if self.con == 3.1 then		
        Object.startCache()
        if not Game.world.player:collidesWith(collider) then
            self.con = 4
			self.timer = 0
			self.timercon = 0
        elseif Input.pressed("cancel") then
			self.con = 0
		end
        Object.endCache()
	end
	if self.con == 4 then
		self.timer = self.timer + DTMULT
		if self.timer >= (1 + (self.waittime * 2)) and self.timercon == 0 then
			if self.oneway then
				local xtarg = self.x1
				local ytarg = self.y1
				if self.xtarg == self.x1 and self.ytarg == self.y1 then
					xtarg = self.x2
					ytarg = self.y2
				end
				self.xlerp = Game.world.timer:lerpVar(self, "x", self.x, xtarg, self.traveltime)
				self.ylerp = Game.world.timer:lerpVar(self, "y", self.y, ytarg, self.traveltime)
			end
			self.timercon = 1
		end
		if (self.timer >= (1 + (self.waittime * 2) + self.traveltime) and self.timercon == 1) or not self.oneway then
			self.con = 0
			self.timercon = 0
			self.cyltimercon = 0
			self.timer = 0
		end
	end
	if self.reset then
		local returntime = 4
		self.con = -1
		self.timercon = 0
		self.cyltimercon = 0
		self.timer = 0
		Game.world.timer:after(returntime/30, function()
			self.con = 0
		end)
		if self.xlerp then
			Game.world.timer:cancel(self.xlerp)
			self.xlerp = nil
		end
		if self.ylerp then
			Game.world.timer:cancel(self.ylerp)
			self.ylerp = nil
		end
		self.xlerp = Game.world.timer:lerpVar(self, "x", self.x, self.x1, returntime, 2, "out")
		self.ylerp = Game.world.timer:lerpVar(self, "y", self.y, self.y1, returntime, 2, "out")
		self.reset = false
	end
	if self.stick then
		if Game.world.player.onrotatingtower then
			Game.world.player.x = self.xprediction + 20
			Game.world.player.y = self.yprediction + 40
		else
			Game.world.player.x = self.x + 20
			Game.world.player.y = self.y + 40
		end
		Game.world.player.scale_x = self.scale_x * 2
		Game.world.player.scale_y = self.scale_y * 2
	end
end

return ClimbMover
