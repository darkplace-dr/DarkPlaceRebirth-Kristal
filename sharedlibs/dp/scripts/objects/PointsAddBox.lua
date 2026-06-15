---@class PointsAddBox : Object
---@overload fun(...) : PointsAddBox
local PointsAddBox, super = Class(Object)

function PointsAddBox:init(points, x, y)
    super.init(self, x or 242, y or 212)

    self:setParallax(0, 0)

    self.box = UIBox(0, 0, 157, 17)
    self.box.layer = -1
    self:addChild(self.box)

    self.font = Assets.getFont("main")
	self.amount_display = Game:getFlag("points", 0) - points
	self.increase_points = false
end

function PointsAddBox:update()
    super.draw(self)

	if self.increase_points then
		if Game.world:isTextboxOpen() then
			if Input.down("menu") then
				self.amount_display = Game:getFlag("points", 0)
			end
		end
		if self.amount_display < Game:getFlag("points", 0) then
			self.amount_display = math.ceil(MathUtils.lerp(self.amount_display, Game:getFlag("points", 0), 0.2*DTMULT))
		else
			self.increase_points = false
		end
	end
end

function PointsAddBox:draw()
    super.draw(self)

    love.graphics.setFont(self.font)
    Draw.setColor(PALETTE["world_text"])
    love.graphics.print(self.amount_display, 64 - 36 - self.font:getWidth(self.amount_display)/2, 312 - 220 - 100)
    love.graphics.print(" POINTs", 64 + 30 - 36, 312 - 220 - 100)
end

return PointsAddBox