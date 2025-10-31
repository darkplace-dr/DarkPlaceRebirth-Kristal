local LightJackenstein, super = Class(Object)

function LightJackenstein:init(x, y, radius, radius_2, color)
    super.init(self, x, y)
	self.radius = radius or 160
	self.radius_2 = radius_2 or 40
    self.radius_big = 0
    self.radius_small = 0
    self.color = color or {1,1,1}
    self.alpha = 1
    self.inherit_color = false
	self.siner = 0
    -- don't allow debug selecting
    self.debug_select = false
end

function LightJackenstein:update()
	super.update(self)
	self.siner = self.siner + DTMULT
	self.radius_small = math.sin((self.siner / 30) * 10) + self.radius
	self.radius_big = math.sin(((self.siner - 10) / 30) * 10) + self.radius + self.radius_2
end

function LightJackenstein:getRadius()
    return self.radius_big/2, self.radius_small/2
end

return LightJackenstein