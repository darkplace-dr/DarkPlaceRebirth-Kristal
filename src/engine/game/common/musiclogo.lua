local MusicLogo, super = Class(Object)

function MusicLogo:init(logo, x, y, is_sprite, color, time)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
    self.present = true

    self.timer = 0

    self.parallax_x = 0
    self.parallax_y = 0

	self.xx = x or 180
	if is_sprite then
		self.logo = Sprite("objects/musiclogos/" .. logo or "objects/musiclogos/field", self.xx, y or 120)
	else
		self.logo = Text("[font:musiclogo][spacing:1]♪~" .. logo, self.xx, y or 120)
		self.logo:addFX(OutlineFX((color and color or {17/255, 31/255, 151/255}), {
			thickness = 1,
			amount = 1
		}))
	end

    self.logo:setScale(2)
    self.logo.alpha = 0
    self:addChild(self.logo)
	self.max_time = time or 120
	self.end_timer = 120
	self.offx = 0
end

function MusicLogo:update()
	self.timer = self.timer + DTMULT
	if self.timer <= 30 then
		self.offx = self.offx + (2*DTMULT - (self.timer / 15))
		if self.logo.alpha < 1 then
			self.logo.alpha = self.logo.alpha + 0.05 * DTMULT
		end
	end
	if self.timer >= self.max_time then
		self.end_timer = self.end_timer + DTMULT
		self.offx = self.offx + (-8*DTMULT + (self.end_timer / 15))
		self.logo.alpha = self.logo.alpha - (1/30)*DTMULT
		if self.logo.alpha <= 0 then
			self:remove()
		end
	end
	self.logo.x = self.xx - self.offx
end

return MusicLogo