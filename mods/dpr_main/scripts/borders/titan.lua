---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "titan")
	self.eyes_texture = Assets.getTexture("borders/titan_eyes")
	self.eyes_siner = 0
	self.eyes_alpha = 0
end

function MyBorder:draw()
    super.draw(self)
	self.eyes_siner = self.eyes_siner + DTMULT
	self.eyes_alpha = 0.4 + (math.sin(self.eyes_siner / 30) * 0.2)
    love.graphics.setColor(1, 1, 1, self.eyes_alpha * BORDER_ALPHA)
	Draw.draw(self.eyes_texture, 0, 0, 0, BORDER_SCALE)
end

return MyBorder