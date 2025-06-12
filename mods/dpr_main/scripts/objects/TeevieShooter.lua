local TeevieShooter, super = Class(Object)

function TeevieShooter:init(x, y)
    super.init(self, x, y)
	
	self.quiz_face = Assets.getFrames("world/events/teevie_tvs/face")
	self.quiz_static = Assets.getFrames("world/events/teevie_tvs/static")

	self.screen_x = -1
	self.screen_y = -1
	self.screen_sprite = self.quiz_static
	self.screen_index = 1
	self.screen_anim = self.screen_sprite[1]
	self.screen_animated = false
	self.alpha = 0
	
	self.shoot_sequence_timer = 0
	self.shoot_sequence_con = 0
end

function TeevieShooter:update()
	super.update(self)
	
	self.shoot_sequence_timer = self.shoot_sequence_timer + DTMULT
	if self.shoot_sequence_timer >= 1 and self.shoot_sequence_con == 0 then
		self.screen_sprite = self.quiz_static
		self.screen_index = 1
		self.screen_animated = true
		self.alpha = 1
		self.shoot_sequence_con = 1
	elseif self.shoot_sequence_timer >= 10 and self.shoot_sequence_con == 1 then
		self.screen_sprite = self.quiz_face
		self.screen_index = 1
		self.screen_animated = false
		self.shoot_sequence_con = 2
	elseif self.shoot_sequence_timer >= 17 and self.shoot_sequence_con == 2 then
		self.screen_index = 2
		Assets.playSound("wing", 1, 1.4)
		Game.world:spawnBullet("teeviebullet", self.x + 40, self.y + 40)
		self.shoot_sequence_con = 3
	elseif self.shoot_sequence_timer >= 32 and self.shoot_sequence_con == 3 then
		self.screen_sprite = self.quiz_static
		self.screen_index = 1
		self.screen_animated = true
		self.shoot_sequence_con = 4
	elseif self.shoot_sequence_timer >= 48 and self.shoot_sequence_con == 4 then
		self.screen_index = 1
		self.screen_animated = false
		self.alpha = 0
		self.shoot_sequence_con = 5
	end
	
	if self.screen_animated then
		self.screen_index = self.screen_index + 0.2 * DTMULT
	end
	self.screen_anim = self.screen_sprite[(math.floor(self.screen_index - 1) % #self.screen_sprite) + 1]
end

return TeevieShooter