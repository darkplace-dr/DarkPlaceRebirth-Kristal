local SchoolSunset, super = Class(Event)

function SchoolSunset:onLoad()
    super.onLoad(self)
	if Game:getFlag("hometown_time", "day") ~= "sunset" then
		Game.world.map.image_layers["sunset"]:remove()
	end
end

return SchoolSunset