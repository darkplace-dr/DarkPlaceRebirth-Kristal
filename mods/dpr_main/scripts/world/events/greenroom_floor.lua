---@class GreenRoomFloor : Object
---@GreenRoomFloor fun(...) : Object
local GreenRoomFloor, super = Class(Event)

function GreenRoomFloor:init(data)
    super.init(self, data)
	
	self.parallax_x = 0.5
	self.parallax_y = 0.5
end

function GreenRoomFloor:draw()
    super.draw(self)
	local base_x = 0
	local base_y = 72
	love.graphics.setColor(244/255, 182/255, 136/255, 1)
	Draw.rectangle("fill", -self.x, -self.y, Game.world.map.width * self.world.map.tile_width, Game.world.map.height * self.world.map.tile_height)
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
	love.graphics.setColor(1,1,1,1)
end

return GreenRoomFloor