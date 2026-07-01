function Mod:init()
    self:setMusicVolumes()
end

function Mod:postInit(newfile)
    print("Loaded "..self.info.name.."!")
	Game:rollShiny("brenda")
end

function Mod:setMusicVolumes()
    MUSIC_VOLUMES["deltarune/noelle_house_wip"] = 0.9
    MUSIC_VOLUMES["deltarune/noelle_distant"] = 0.8
end

function Mod:onMapMusic(map, music)
	if music == "hometown" then
		if Game:getFlag("hometown_time", "day") == "day" then
			return "deltarune/town_day"
		elseif Game:getFlag("hometown_time", "day") == "sunset" then
			return "deltarune/town"
		elseif Game:getFlag("hometown_time", "day") == "night" then
			return "forecasted_hometown_night"
		end
	end
	if music == "church" then
		if Game:getFlag("hometown_time", "day") == "night" then
			return "deltarune/church_lw_night"
		else
			return "deltarune/church_lw"
		end
	end
	if music == "deltarune/mus_birdnoise" and Game:getFlag("hometown_time", "day") == "night" then
		return "deltarune/night_ambience"
	end
end

function Mod:onMapBorder(map, border)
	if border == "leaves" then
		if Game:getFlag("hometown_time", "day") == "night" then
			return "leaves_night"
		elseif Game:getFlag("hometown_time", "day") == "morning" then
			return "town_morning"
		elseif Game:getFlag("hometown_time", "day") == "evening" then
			return "town_evening"
		end
	end
end

function Mod:loadObject(world, name, data)
    if Game.event_registry:has(name) then
        return Game.event_registry:create(name, data)
    end
    loaded = world.map:legacyLoadObject(name, data)
    if loaded ~= nil then
        return loaded
    end
    if Game.builtin_event_registry:has(name) then
        return Game.builtin_event_registry:create(name, data)
    end
    if data.gid then
		local tobj = world.map:createTileObject(data)
		tobj.day_mode = data.properties["day"] or nil
		tobj.night_mode = data.properties["night"] or nil
		tobj.sunset_mode = data.properties["sunset"] or nil
		tobj.sunrise_mode = data.properties["sunrise"] or nil
		tobj.rain_mode = data.properties["rain"] or nil
		return tobj
    end
	return nil
end
