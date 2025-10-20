local TeevieCameras, super = Class(Event)

function TeevieCameras:init(data)
    super.init(self, data)

	local properties = data.properties or {}
	
	self.top_crowd = properties["top_crowd"] or true
	self.bottom_crowd = properties["bottom_crowd"] or true

	self.bg_height = 158 * 2
	
	self.audience_sfx = Assets.newSound("berdly_audience")
    self.audience_sfx:setLooping(true)
    self.audience_sfx:setVolume(0)
	self.audience_sfx:play()
	
	self.siner = 0
	self.sound_volume = 0
	self.target_volume = 0
	self.siner_speed = 0
	self.glitz_active = false
	self.target_y_pos = 0
	self.current_y_pos = 0
	self.threshold_left = self.x
	self.threshold_right = self.x + self.width
	self.threshold_top = self.y - 20 + 60
	self.threshold_vert_max = 160
	self.threshold_bottom = self.threshold_top + self.threshold_vert_max
	
	self.timer = 0
	self.ooaatimer = 0
	self.timer_max = 30
	self.ooaa_max = 60
	self.flashes = {}
	self.lerp_speed = 0.2
	
	self:initCrowd()
	self.dess_moment = 0
	
	self.disable = false
	self.can_kill = Game:getFlag("can_kill", false)
end

function TeevieCameras:onLoad()
	super.onLoad(self)
	
	self.cheer_audience = {}
	
	self.cheer_audience[1] = Sprite("world/events/teevie_cameras/camera_crowd", self.x, self.y)
	self.cheer_audience[1]:setColor(COLORS["gray"])
	self.cheer_audience[1]:setScale(2,2)
	self.cheer_audience[1].wrap_texture_x = true
	self.cheer_audience[1]:setLayer(0.13)
	self.cheer_audience[1]:addFX(ScissorFX(0, 0, self.width+80, 83*2))
	self.cheer_audience[1].visible = self.top_crowd
	Game.world:addChild(self.cheer_audience[1])
	
	self.cheer_audience[2] = Sprite("world/events/teevie_cameras/camera_crowd", self.x, self.y)
	self.cheer_audience[2]:setScale(2,2)
	self.cheer_audience[2].wrap_texture_x = true
	self.cheer_audience[2]:setLayer(0.14)
	self.cheer_audience[2]:addFX(ScissorFX(0, 0, self.width+40, 83*2))
	self.cheer_audience[1].visible = self.top_crowd
	Game.world:addChild(self.cheer_audience[2])
	
	self.cheer_crowd = TeevieCheerCrowd(self.x, self.y, self.width, 400)
	self.cheer_crowd:setLayer(self.layer+10)
	self.cheer_crowd:addFX(ScissorFX(-100, -100, self.width+100, 500))
	self.cheer_crowd.visible = self.bottom_crowd
	Game.world:addChild(self.cheer_crowd)
	
	self.base_y_pos = y
end

function TeevieCameras:showCrowd()
	self.target_y_pos = self.top_pos
	self.glitz_active = true
	self.cheer_crowd.glitz_active = true
	self.target_volume = 1
	self.lerp_speed = 0.4
	self.siner_speed = 0.4
end

function TeevieCameras:hideCrowd()
	self.target_y_pos = self.bottom_pos
	self.glitz_active = false
	self.cheer_crowd.glitz_active = false
	self.target_volume = 0
	self.lerp_speed = 0.2
end

function TeevieCameras:hideCrowdDess()
	self.target_y_pos = self.bottom_pos
	self.glitz_active = false
	self.dess_moment = 2
	self.cheer_crowd.dess_moment = 2
	self.lerp_speed = 0.05
end

function TeevieCameras:initCrowd()
	self.top_pos = self.y - 60
	self.bottom_pos = self.y + 20
	self.target_y_pos = self.bottom_pos
	self.current_y_pos = self.target_y_pos
	self.glitz_active = false
	self.lerp_speed = 0.2
end

function TeevieCameras:update()
	super.update(self)
	
	if not Game.world or not Game.world.player then
		return
	end
	
	local true_siner_speed = self.siner_speed
	if Game.world:hasCutscene() or Game.world.encountering_enemy or Game.world.state == "MENU" or Game.state ~= "OVERWORLD" or self.dess_moment ~= 0 then
		true_siner_speed = 0
	end
	self.siner = self.siner + true_siner_speed * DTMULT
	self.timer = self.timer + DTMULT
	self.ooaatimer = self.ooaatimer + DTMULT
	self.current_y_pos = Utils.lerp(self.current_y_pos, self.target_y_pos, self.lerp_speed*DTMULT)
	if self.top_crowd then
		self.cheer_audience[1].x = Utils.round(self.x + (math.cos(self.siner / 4) * 8) - 80)
		self.cheer_audience[1].y = self.current_y_pos - math.abs(math.sin(self.siner / 4) * 4)
		self.cheer_audience[2].x = -8 + Utils.round(self.x + math.cos(self.siner / 3) * 6)
		self.cheer_audience[2].y = 10 + self.current_y_pos - (math.sin(self.siner) * 4)
	end
	
	local in_range = false
	if Game.world.player.x >= self.threshold_left and Game.world.player.x <= self.threshold_right then
		if Game.world.player.y >= self.threshold_top and Game.world.player.y <= self.threshold_bottom then
			in_range = true
		end
	end
	if self.glitz_active and self.dess_moment == 0 then
		if in_range == false or self.disable or self.can_kill then
			self.glitz_active = false
			self:hideCrowd()
		else
			if Game.world.player.y >= self.y and Game.world.player.x >= self.threshold_left and Game.world.player.x <= self.threshold_right then
				if self.ooaatimer > self.ooaa_max then
					Assets.playSound(Utils.pick({"crowd_aah", "crowd_ooh"}), 1, Utils.random(0.75, 1.5))
					self.ooaatimer = 0
					self.ooaa_max = love.math.random(0, 140) + 30
				end
			end
			if Game.world.player.y >= self.y and self.timer > self.timer_max and self.top_crowd then
				local rand_x = self.threshold_left + love.math.random(self.threshold_right - self.threshold_left) - 80
				local rand_y = self.y - 40 + love.math.random(0, 40)
				local flash_scale = Utils.random(1.5, 2)
				local flash_scale_x = Utils.random(1.75, 2.5)
				local flash = Sprite("world/events/teevie_cameras/flash", rand_x, rand_y)
				flash:setLayer(101)
				flash:setScale(flash_scale_x,flash_scale)
				flash.lifetime = self.timer_max + 16
				flash.timer = 0
				flash.faded = false
				flash:play(1.5/30, false)
				table.insert(self.flashes, flash)
				Game.world:addChild(flash)
				self.timer_max = love.math.random(0, 3) + 10
				self.timer = 0
			end
			local min_x_pos = -1
			local max_x_pos = -1
			local min_y_pos = -1
			local max_y_pos = -1
			local audio_pos = 0
			if Game.world.player.y >= self.y - 40 then
				if Game.world.player.x < self.threshold_left then
					min_x_pos = self.threshold_left
					max_x_pos = min_x_pos - 280
					audio_pos = Utils.clamp(((Game.world.player.x - min_x_pos) * 100) / (max_x_pos - min_x_pos), 0, 100)/100
				elseif Game.world.player.x >= self.threshold_right then
					min_x_pos = self.threshold_right
					max_x_pos = min_x_pos + 280
					audio_pos = Utils.clamp(((Game.world.player.x - min_x_pos) * 100) / (max_x_pos - min_x_pos), 0, 100)/100
				end
				self.target_volume = 1 - audio_pos
			else
				min_y_pos = self.y - 40
				max_y_pos = self.y - 180
				audio_pos = Utils.clamp(((Game.world.player.y - min_y_pos) * 100) / (max_y_pos - min_y_pos), 0, 100)/100
				self.target_volume = 1 - audio_pos
			end
		end
		self.sound_volume = Utils.lerp(self.sound_volume, self.target_volume, 0.6*DTMULT)
	else
		if in_range == true and self.dess_moment == 0 and not self.disable and not self.can_kill  then
			if Game.world.player.y >= self.y then
				self.glitz_active = true
				self:showCrowd()
			end
		end
		self.siner_speed = Utils.lerp(self.siner_speed, 0, 0.01*DTMULT)
		self.sound_volume = Utils.lerp(self.sound_volume, 0, 0.6*DTMULT)
	end
	for i,flash in ipairs(self.flashes) do
		flash.timer = flash.timer + DTMULT
		if flash.timer >= 6 and not flash.faded then
			flash:fadeToSpeed(0, 8/30)
			flash.faded = true
		end
		if flash.timer >= flash.lifetime then
			flash:remove()
			table.remove(self.flashes, i)
		end
	end
	self.audience_sfx:setVolume(self.sound_volume)
end

return TeevieCameras