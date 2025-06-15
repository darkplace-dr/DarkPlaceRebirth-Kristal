function Mod:postInit(newfile)
    print("Loaded "..self.info.name.."!")
	Game:rollShiny("brenda")
end

function Mod:onMapMusic(map, music)
	if music == "hometown" then
		return "deltarune/town_day"
	end
end