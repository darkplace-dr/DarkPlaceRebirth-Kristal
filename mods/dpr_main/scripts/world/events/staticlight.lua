local ChurchStaticLight, super = Class(Event)

function ChurchStaticLight:init(data)
    super.init(self, data)
	self:setOrigin(0.5)
    local properties = data and data.properties or {}
	self.draw_dimmer_light = properties["dimmerlight"] or false
	self.size = properties["size"] or 80
	self.siner = 0
	self.lightalpha = 1
	self.light_source = true
	self.light_active = true
end

function ChurchStaticLight:getDebugRectangle()
    return {-5, -5, 10, 10}
end

function ChurchStaticLight:update()
    super.update(self)
	self.siner = self.siner + DTMULT
end

function ChurchStaticLight:drawLightA()
    local x, y = self:getScreenPos()
	Draw.setColor(1, 1, 1, self.lightalpha)
	love.graphics.circle("fill", x, y, (self.size * 1.125) + (math.sin(self.siner / 30) * 2))
	Draw.setColor(1, 1, 1, 1)
end

function ChurchStaticLight:drawLightB()
	if self.draw_dimmer_light then
		local x, y = self:getScreenPos()
		Draw.setColor(1, 1, 1, self.lightalpha)
		love.graphics.circle("fill", x, y, self.size + (math.sin(self.siner / 30) * 2))
		Draw.setColor(1, 1, 1, 1)
	end
end

return ChurchStaticLight