---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "elevator")
	self.col = {1,1,1}
end

function MyBorder:draw()
	if Game.world and Game.world.map and Game.world.map:getEvent("elevator") then
		self.col = Game.world.map:getEvent("elevator").cur_bg_c
	end
    Draw.setColor(self.col, BORDER_ALPHA)
    super.draw(self)
end

return MyBorder