local QueenRoom, super = Class(Map)

function QueenRoom:init(world, data)
	super.init(self, world, data)
	
	self.car_pause = false
	self.car_pause_toggle = false
	self.car_timer = 0
	self.car_con = 0
	self.car_x_alt = 0
	self.car_x_target = 0
	self.car_x_target_temp = 0
	self.car_x_start = 0
	self.car = nil
end

function QueenRoom:onEnter()
	super.onEnter(self)

	if Game:hasRecruit("shadowguy") then
		self.car = Game.world:spawnNPC("shadowguy_car", 800, 170, {cutscene = "floor2.queen_shadowguys"})
		self.car_x_start = self.car.x
		self.car_x_target = self.car_x_start
	end
end

function QueenRoom:update()
	super.update(self)
	if self.car then
		if not self.car_pause then
			self.car_timer = self.car_timer + DTMULT
			if self.car_timer >= 1 and self.car_con == 0 then
				self.car_x_alt = self.car_x_alt + 1
				if self.car_x_alt % 2 == 1 then
					self.car_x_target_temp = self.car_x_start
				else
					self.car_x_target_temp = self.car_x_start + 194
				end
				self.car_con = 1
			end
			self.car_x_target = MathUtils.lerp(self.car_x_target, self.car_x_target_temp, math.pow(self.car_timer / 20, 3))
			self.car.x = self.car_x_target
			if self.car_timer >= 17 and self.car_con == 1 then
				Assets.playSound("impact", 0.5, 1.5)
				self.car:shake()
				self.car_con = 2
			end
			if self.car_timer >= 60 and self.car_con == 2 then
				self.car_timer = 0
				self.car_con = 0
			end
		end
	end
end

return QueenRoom