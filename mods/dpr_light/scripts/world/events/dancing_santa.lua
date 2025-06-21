local DancingSanta, super = Class(Event)

function DancingSanta:init(data)
    super.init(self, data)
	
    self:setOrigin(0, 0)
    self:setSprite("world/events/dancing_santa/idle")
	local properties = data.properties or {}

	self.santa_type = properties["santa_type"] or 0
	self.is_active = false
	self.is_looping = true
	self.timer = 0
	self.loop_timer = 0
	self.con = 0
	self.play_time = 0
	self.audio_file = nil
end

function DancingSanta:onInteract(player, dir)
	self.timer = 0
	self.loop_timer = 0
	self.con = 0
	if self.is_active == true then
		self.is_active = false
		self.is_looping = false
		if self.audio_file then
			Assets.stopSound(self.audio_file)
		end
		self:setSprite("world/events/dancing_santa/idle")
	else
		self.is_active = true
		self.is_looping = true
		self:setSprite("world/events/dancing_santa/pressed")
	end
	self.sprite:stop()
	self.sprite:setFrame(1)
    Assets.playSound("noise")
end

function DancingSanta:onRemove(parent)
	super.onRemove(self, parent)
	self.is_active = false
	if self.audio_file then
		Assets.stopSound(self.audio_file)
	end
end

function DancingSanta:update()
	super.update(self)
	if self.is_active == true then
		self.timer = self.timer + DTMULT
		self.loop_timer = self.loop_timer + DTMULT
		if self.timer >= 1 and self.con == 0 then
			self.con = 1
			self.audio_file = "santa_laugh"
			local santa_pitch = 1
			if self.santa_type == 0 then
				self.sprite:play(1/7.5)
				self.play_time = 40
			elseif self.santa_type == 1 then
				self.sprite:play(1/4.5)
				self.play_time = 60
				self.audio_file = "santa_laugh_low_energy"
			elseif self.santa_type == 2 then
				self.sprite:play(1/12)
				self.play_time = 30
				self.audio_file = "santa_laugh_low_energy"
				santa_pitch = 2.5
			end
			Assets.playSound(self.audio_file, 1, santa_pitch)
			self.con = 1
		end
		if self.timer >= self.play_time then
			self.audio_file = nil
			self.timer = 0
			self.con = 0
			self.sprite:stop()
			self.sprite:setFrame(1)
			
			if not self.world:hasCutscene()
		 	  and self.world.state ~= "MENU"
			  and Game.state == "OVERWORLD"
			  and self.loop_timer >= 90 then
				self.is_looping = false
				self.loop_timer = 0
			end
			
			if not self.is_looping then
				self:setSprite("world/events/dancing_santa/idle")
				self.is_active = false
			end
		end
	end
end

return DancingSanta