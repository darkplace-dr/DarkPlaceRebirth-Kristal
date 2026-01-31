local GreenRoomRacingGame, super = Class(Object)

function GreenRoomRacingGame:init()
    super.init(self, 0, 0)
    self.layer = WORLD_LAYERS["top"]
	self:setParallax(0)
	self.end_state = "NO_MOVE"
	self.finish = false
	self.timer = 150
	self.snd_timer = 30
	self.solids = {}
	self.player_moved = false
	self.car = RacingCar(SCREEN_WIDTH/2 - 60, SCREEN_HEIGHT / 2 + 20 + 61)
	self:addChild(self.car)
	self.goal = RacingGoal(SCREEN_WIDTH/2 + 40, SCREEN_HEIGHT / 2 + 80, 4*5, 4*20)
	self:addChild(self.goal)
	local solid_middle = RacingSolid(SCREEN_WIDTH/2 - 60, 160, 40*4, 40*4)
	self:addChild(solid_middle)
	table.insert(self.solids, solid_middle)
	local solid_top = RacingSolid(0, 0, 40*16, 40*2)
	self:addChild(solid_top)
	table.insert(self.solids, solid_top)
	local solid_bottom = RacingSolid(0, solid_middle.y + 240, 40*16, 40*2)
	self:addChild(solid_bottom)
	table.insert(self.solids, solid_bottom)
	local solid_left = RacingSolid(0, 80, 40*4, 40*8)
	self:addChild(solid_left)
	table.insert(self.solids, solid_left)
	local solid_right = RacingSolid(520, 80, 40*4, 40*8)
	self:addChild(solid_right)
	table.insert(self.solids, solid_right)
	local solid_divider = RacingSolid(320, 320, 40, 40*2)
	self:addChild(solid_divider)
	table.insert(self.solids, solid_divider)
	self.init = false
end

function GreenRoomRacingGame:timeUp()
	Assets.playSound("error")
	if self.player_moved then
		self.end_state = "LOSE"
	else
		self.end_state = "NO_MOVE"
	end
	self.car.can_move = false
	self.finish = true
end 

function GreenRoomRacingGame:winGame()
	Assets.playSound("won")
	Assets.playSound("crowd_cheer_single")
	self.end_state = "WIN"
	self.car.can_move = false
	self.finish = true
end 

function GreenRoomRacingGame:onRemove(parent)
	super.onRemove(self, parent)
	for _, solid in ipairs(self.solids) do
		solid:remove()
	end
	self.car:remove()
	self.goal:remove()
end 

function GreenRoomRacingGame:update()
	super.update(self)
	
	if self.init and not self.finish then
		if self.car:isMoving() then
			self.player_moved = true
		end
		self.timer = self.timer - DTMULT
		if self.timer < 0 then
			Assets.stopSound("racing")
			self:timeUp()
		else
			if self.snd_timer <= 0 then
				Assets.playSound("racing")
				self.snd_timer = 120
			else
				self.snd_timer = self.snd_timer - DTMULT
			end
		end
	end
end

return GreenRoomRacingGame