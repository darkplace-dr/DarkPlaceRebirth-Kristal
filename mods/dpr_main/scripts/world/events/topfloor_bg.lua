local TopFloorBG, super = Class(Event)

function TopFloorBG:init(data)
    super.init(self, data)
	self.x = 0
	self.y = 0
	self:setParallax(0, 0)
	self.debug_select = false
    self.bg = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS")
    self.bg_brighter = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS_BRIGHTER")
    self.bg_faded = Assets.getTexture("backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS")
	self.bg_x = 0
	self.bg_y = 0
	self.bg_brightness = 0
	self.siner = 0
	Game.world.map.topfloorbg = self
end

function TopFloorBG:draw()
	super.draw(self)
	self.siner = self.siner + DTMULT
	self.bg_x = (self.siner / 2)
	self.bg_y = (self.siner / 3)
	self.bg_brightness = (math.sin((Kristal.getTime() * 30) / 48))
	Draw.setColor(1,1,1,1)
	Draw.drawWrapped(self.bg, true, true, self.bg_x, self.bg_y, 0, 2, 2)
	Draw.setColor(1,1,1,self.bg_brightness)
	Draw.drawWrapped(self.bg_brighter, true, true, self.bg_x, self.bg_y, 0, 2, 2)
	Draw.setColor(1,1,1,0.2)
	Draw.drawWrapped(self.bg_faded, true, true, -(self.bg_x * 2), -(self.bg_y * 2), 0, 2, 2)
	Draw.setColor(1,1,1,1)
end

return TopFloorBG