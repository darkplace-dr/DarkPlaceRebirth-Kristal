local ChurchLightFollowing, super = Class(Event)

function ChurchLightFollowing:init(data)
    super.init(self, data)
	self:setOrigin(0.5)
    local properties = data and data.properties or {}
	self.draw_dimmer_light = properties["dimmerlight"] or false
	self.size = properties["size"] or 80
	self.siner = 0
	self.lightalpha = 1
	self.light_source = true
	self.light_active = true
    self.xoff = properties["xoff"] or 0
    self.yoff = properties["yoff"] or 0
    self.followtype = properties["followtype"] or 1
    self.lerpstrength = properties["lerpstrength"] or 0.2
    self.target_objs = properties["target"] or nil
end

function ChurchLightFollowing:getDebugRectangle()
    return {-5, -5, 10, 10}
end

function ChurchLightFollowing:update()
    super.update(self)
	self.siner = self.siner + DTMULT
	if self.target then
		if self.followtype == 1 then
			local x, y = self.target:getRelativePos(0, 0)
			self:setPosition(x + self.xoff, y + self.yoff)
		end
		if self.followtype == 2 then
			local x, y = self.target:getRelativePos(0, 0)
			self.x = MathUtils.lerp(self.x, x + self.xoff, self.lerpstrength * DTMULT)
			self.y = MathUtils.lerp(self.y, y + self.yoff, self.lerpstrength * DTMULT)			
		end
	end
end

function ChurchLightFollowing:drawLightA()
    local x, y = self:getScreenPos()
	Draw.setColor(1, 1, 1, self.lightalpha)
	love.graphics.circle("fill", x, y, (self.size * 0.89) + (math.sin(self.siner / 30) * 2))
	Draw.setColor(1, 1, 1, 1)
end

function ChurchLightFollowing:drawLightB()
	if self.draw_dimmer_light then
		local x, y = self:getScreenPos()
		Draw.setColor(1, 1, 1, self.lightalpha)
		love.graphics.circle("fill", x, y, self.size + (math.sin(self.siner / 30) * 4) + 4)
		Draw.setColor(1, 1, 1, 1)
	end
end

return ChurchLightFollowing