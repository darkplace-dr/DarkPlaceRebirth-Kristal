---@class GreenRoomFloor : Object
---@GreenRoomFloor fun(...) : Object
local GreenRoomFloor, super = Class(Event)

function GreenRoomFloor:init(data)
    super.init(self, data)
	
	self.parallax_x = 0.5
	self.parallax_y = 0.5
	self.color = {}  
	properties = data.properties or {}
	table.insert(self.color, TiledUtils.parseColorProperty(properties["color1"]) or ColorUtils.hexToRGB("#F4B688FF"))
	table.insert(self.color, TiledUtils.parseColorProperty(properties["color2"]) or ColorUtils.hexToRGB("#EBCE9E7F"))
	table.insert(self.color, TiledUtils.parseColorProperty(properties["color3"]) or ColorUtils.hexToRGB("#DBFCC7FF"))
	table.insert(self.color, TiledUtils.parseColorProperty(properties["color4"]) or ColorUtils.hexToRGB("#BBEBA47F"))
	table.insert(self.color, TiledUtils.parseColorProperty(properties["color5"]) or ColorUtils.hexToRGB("#A1DB86FF"))
end

function GreenRoomFloor:draw()
    super.draw(self)
	local base_x = 0
	local base_y = 72
	Draw.setColor(self.color[1])
	Draw.rectangle("fill", -self.x, -self.y, Game.world.map.width * self.world.map.tile_width, Game.world.map.height * self.world.map.tile_height)
	Draw.setColor(self.color[3])
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 60 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 220, 50)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 660 - 110 - 80, base_y + 480 + 20 + 80, math.rad(-45), 180, 50)
	Draw.setColor(self.color[5])
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 164 - 110 - 80, base_y + 450 + 20 + 80, math.rad(-45), 200, 14)
	Draw.setColor(self.color[2])
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 55 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 172, 2)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 287 - 110 - 80, base_y + 490 + 20 + 80, math.rad(-45), 212, 2)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 654 - 110 - 80, base_y + 480 + 20 + 80, math.rad(-45), 185, 2)
	Draw.setColor(self.color[4])
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 171 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 150, 1)
	Draw.draw(Assets.getTexture("world/maps/tvland/floor_pixel"), base_x + 251 - 110 - 80, base_y + 440 + 20 + 80, math.rad(-45), 150, 1)
	Draw.setColor(1,1,1,1)
end

return GreenRoomFloor