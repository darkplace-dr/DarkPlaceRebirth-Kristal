local SchoolSunset, super = Class(Event)

function SchoolSunset:onLoad()
    super.onLoad(self)
	if Game:getFlag("hometown_time", "day") == "day" then
		Game.world.map.image_layers["sunset"]:remove()
		Game.world.map.image_layers["sunset_overcast"]:remove()
	else
		local overcast_alpha = 0
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					overcast_alpha = (w.weathertimer / 120)
				end
			end
		end
		if Game.world.map.image_layers["sunset_overcast"] then
			Game.world.map.image_layers["sunset_overcast"].alpha = overcast_alpha
		end
	end
end

function SchoolSunset:update()
	if Game:getFlag("hometown_time", "day") ~= "day" then
		local overcast_alpha = 0
		if Game.stage.weather then
			for i, w in ipairs(Game.stage.weather) do
				if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
					overcast_alpha = (w.weathertimer / 120)
				end
			end
		end
		if Game.world.map.image_layers["sunset_overcast"] then
			Game.world.map.image_layers["sunset_overcast"].alpha = overcast_alpha
		end
	end
end

return SchoolSunset