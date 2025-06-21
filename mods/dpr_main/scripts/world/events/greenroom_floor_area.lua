---@class GreenRoomFloorArea : Object
---@GreenRoomFloor fun(...) : Object
local GreenRoomFloorArea, super = Class(Event)

function GreenRoomFloorArea:init(data)
    super.init(self, data)
	
	local properties = data.properties or {}
	
	self.par_x = properties["parax"] or 0
	self.par_y = properties["paray"] or 0
end

function GreenRoomFloorArea:draw()
    Draw.pushScissor()
    Draw.scissor(0, 0, self.width, self.height)
    super.draw(self)
	local base_x = (self.par_x-self.x)+Game.world.camera.x/2
	local base_y = (self.par_y-self.y)+72+Game.world.camera.y/2
	love.graphics.setColor(244/255, 182/255, 136/255, 1)
	Draw.rectangle("fill", 0, 0, self.width, self.height)
	love.graphics.setColor(219/255, 252/255, 199/255, 1)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 60 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 220, 50)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 660 - 110 - 80, base_y + 480 + 20 + 80, math.rad(-45), 180, 50)
	love.graphics.setColor(161/255, 219/255, 134/255, 1)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 164 - 110 - 80, base_y + 450 + 20 + 80, math.rad(-45), 200, 14)
	love.graphics.setColor(235/255, 206/255, 158/255, 0.5)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 55 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 172, 2)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 287 - 110 - 80, base_y + 490 + 20 + 80, math.rad(-45), 212, 2)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 654 - 110 - 80, base_y + 480 + 20 + 80, math.rad(-45), 185, 2)
	love.graphics.setColor(187/255, 235/255, 164/255, 0.5)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 171 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 150, 1)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 251 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 150, 1)
    Draw.popScissor()
	love.graphics.setColor(1,1,1,1)
end

return GreenRoomFloorArea