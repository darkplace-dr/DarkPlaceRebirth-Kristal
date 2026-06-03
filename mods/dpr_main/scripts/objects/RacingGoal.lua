local RacingGoal, super = Class(Object)

function RacingGoal:init(x, y, width, height)
    super.init(self, x, y, width, height)

    self.layer = WORLD_LAYERS["top"]

    if width and height then
        self:setHitbox(0, 0, width, height)
    end

	self.color = {0, 1, 0, 1}
end

function RacingGoal:draw()
    if DEBUG_RENDER and self.collider then
        self.collider:drawFill(self:getColor())
    end

    super.draw(self)
end

return RacingGoal