---@class Battle : Battle
local JackensteinDancers, super = Class(Object)

function JackensteinDancers:init()
    super.init(self)

	self.dancing_jackolantern_con = 0
	self.dancing_jackolantern_timer = 0
	self.dancing_jackolantern_alpha = 1
	self.dancing_jackolantern_index = 0
	self.dancing_jackolantern_sprite = Assets.getFrames("ui/battle/dancing_lantern/dancing_lantern")
end

function JackensteinDancers:draw()
    super.draw(self)
	if self.dancing_jackolantern_con > 0 then
		if (Game.battle:getState() == "DEFENDING" or Game.battle:getState() == "DEFENDINGBEGIN") and self.dancing_jackolantern_alpha > 0 then
			self.dancing_jackolantern_alpha = self.dancing_jackolantern_alpha - 0.1*DTMULT
		elseif Game.battle:getState() ~= "DEFENDING" and self.dancing_jackolantern_alpha < 1 then 
			self.dancing_jackolantern_alpha = self.dancing_jackolantern_alpha + 0.1*DTMULT
		end
		self.dancing_jackolantern_timer = self.dancing_jackolantern_timer + DTMULT
		self.dancing_jackolantern_index = self.dancing_jackolantern_index + (1/3) * DTMULT
		Draw.setColor(1,1,1,self.dancing_jackolantern_alpha)
		if self.dancing_jackolantern_con == 1 then
			if self.dancing_jackolantern_timer > 768 then
				self.dancing_jackolantern_timer = self.dancing_jackolantern_timer - 128
			end
			for i = 0, 6 do
				Draw.draw(self.dancing_jackolantern_sprite[math.floor(self.dancing_jackolantern_index%#self.dancing_jackolantern_sprite)+1],
				SCREEN_WIDTH + i*128 - self.dancing_jackolantern_timer, -53, 0, 2, 2)
			end
		elseif self.dancing_jackolantern_con == 2 then
			if self.dancing_jackolantern_timer > 711 then
				self.dancing_jackolantern_timer = self.dancing_jackolantern_timer - 71
			end
			for i = 0, 10 do
				Draw.draw(self.dancing_jackolantern_sprite[math.floor(self.dancing_jackolantern_index%#self.dancing_jackolantern_sprite)+1],
				SCREEN_WIDTH + i*71 - self.dancing_jackolantern_timer, -53, 0, 2, 2)
			end
		elseif self.dancing_jackolantern_con == 3 then
			if self.dancing_jackolantern_timer > 686 then
				self.dancing_jackolantern_timer = self.dancing_jackolantern_timer - 46
			end
			for i = 0, 15 do
				Draw.draw(self.dancing_jackolantern_sprite[math.floor(self.dancing_jackolantern_index%#self.dancing_jackolantern_sprite)+1],
				SCREEN_WIDTH + i*46 - self.dancing_jackolantern_timer, -53, 0, 2, 2)
			end
		end
		Draw.setColor(1,1,1,1)
	end
end

return JackensteinDancers