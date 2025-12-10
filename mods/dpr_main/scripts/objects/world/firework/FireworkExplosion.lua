---@class FireworkExplosion : Object
---@overload fun(...) : FireworkExplosion
local FireworkExplosion, super = Class(Object, "FireworkExplosion") -- made by nyako. thank you! -sam

function FireworkExplosion:init(x, y, width, height, data, coltype, hue)
    super.init(self, x, y)
	
	self.width = width
	self.height = height

	self.pixel_data = data
	self.firework_data = {}
	self.color_type = coltype or TableUtils.pick({0, 2, 1})
	self.angle_z = 0
	self.perspective_z = 0.5
	self.scale = 6
	self.maintain_shape = true
	self.max_yspd = 2
	self.def_grav = 0.2
	self.scale_bonus = 0
	self.time = 0
	self.hue = hue
    self.ptc_2_tex = Assets.getTexture("world/firework/ptc_2")
    self.shine_tex = Assets.getFrames("world/firework/shine")
end

function FireworkExplosion:onAdd()
    super.onAdd(self)
	for _,data in ipairs(self.pixel_data) do
		local pixel_x = (data.x - (self.width/2)) * self.scale
		local pixel_y = (data.y - (self.height/2)) * self.scale
		pixel_x = pixel_x * (1 - math.cos(math.rad(90 - self.angle_z))*((self.perspective_z * 0.5)+(pixel_y / self.height)))
		pixel_y = pixel_y * (1 - self.angle_z / 90)
		local pixel_col = data.col
		if self.color_type == 2 then
			local perc = (pixel_y + (0.5 * self.height)) / (2 * self.height)
			pixel_col = {ColorUtils.HSVToRGB(MathUtils.clamp(perc, 0, 1), 100/255, 1)}
		elseif self.color_type == 1 then
			pixel_col = {ColorUtils.HSVToRGB(self.hue, 100/255, 1)}
		end
		table.insert(self.firework_data, {count = data.count, col = pixel_col, x = pixel_x, y = pixel_y,
		expand_prog = 0, expand_v = 0, expand_h = 0, yspd = -0.8, grav_offset = MathUtils.random(0.02),
		yspd_max_offset = 1 + MathUtils.random(1), scale = 1, sprite_timer = 20 + MathUtils.random(20),
		alpha = MathUtils.random(0.5, 1), expand_spd = MathUtils.random(0.04, 0.06)})
	end
end

function FireworkExplosion:update()
    super.update(self)
	
	self.time = self.time + DTMULT
	if self.time >= 8 and self.maintain_shape then
		self.maintain_shape = false
	end
	if self.time >= 120 then
		self:remove()
	end
	for _,data in ipairs(self.firework_data) do
		data.y = data.y + data.yspd * DTMULT
		if self.maintain_shape then
			data.yspd = data.yspd + self.def_grav * DTMULT
			
			if data.yspd > self.max_yspd * DTMULT then
				data.yspd = self.max_yspd * DTMULT
			end
		else
			data.yspd = data.yspd + data.grav_offset * DTMULT
			
			if data.yspd > (self.max_yspd + data.yspd_max_offset) * DTMULT then
				data.yspd = (self.max_yspd + data.yspd_max_offset) * DTMULT
			end
		end
		
		if data.expand_prog < 1 then
			data.expand_prog = data.expand_prog + data.expand_spd * DTMULT
			
			if data.expand_prog >= 1 then
				data.expand_prog = 1
			end
			
			local expand = math.sin(1.5707963267948966 * data.expand_prog)
			data.expand_h = expand
			data.expand_v = math.sin(1.0995574287564276 * expand)
		else
			data.expand_h = data.expand_h + (0.01 + (data.expand_spd * 0.01)) * DTMULT
			data.expand_v = data.expand_v + (0.01 + (data.expand_spd * 0.01)) * DTMULT
			
			if data.yspd >= 1 then
				data.scale = data.scale - 0.02 * DTMULT
				
				if data.scale <= 0 then
					data.scale = 0
				end
			end
		end
		
		if not self.maintain_shape then
			data.alpha = data.alpha - 0.01 * DTMULT
		end
		
		if data.sprite_timer > 0 then
			data.sprite_timer = data.sprite_timer - 1 * DTMULT
		end
	end
end

function FireworkExplosion:draw()
    super.draw(self)
	love.graphics.setBlendMode("add")
	for _,data in ipairs(self.firework_data) do
		local xx = MathUtils.lerp(0, data.x, data.expand_h)
		local yy = MathUtils.lerp(0, data.y, data.expand_v)
		local color = ColorUtils.mergeColor(COLORS.white, data.col, math.min(self.time / 30, 1))
		Draw.setColor(color, data.alpha)
		if data.sprite_timer >= 0 then
			Draw.draw(self.ptc_2_tex, xx, yy, 0, data.scale, data.scale, 0.5, 0.5)
		else
			Draw.draw(self.shine_tex[(math.floor(data.count + (0.3 * self.time))%4)+1], xx, yy, 0, data.scale+1, data.scale+1, 0.5, 0.5)
		end
	end
	love.graphics.setBlendMode("alpha")
end

return FireworkExplosion