local RankRoom, super = Class(Map)

function RankRoom:load()
    super.load(self)

    local door_data = {
        A = {x=140, y=240, shape={92, 40}, bars="aluminum"},
        B = {x=280, y=240, shape={88, 40}, bars="barium"},
        C = {x=420, y=240, shape={80, 40}, bars="carbon-fiber"}
    }

    for rank,data in pairs(door_data) do
        local dest_map = "floortv/rankroom_"..rank:lower()
        local map_exists = Registry.getMap(dest_map)
        local door_open = DP:getRankedDoorStatus(rank)

        if not map_exists or not door_open then
            if door_open and not map_exists then
                Kristal.Console:warn("The "..rank.."-rank door is unlocked but the map \""..dest_map.."\" doesn't exist. Defaulting to locking the door.")
            end
            local door = Game.world:getEvent("door_"..rank)
            if door then
                -- One weird change to the tileset and this code is done for
                if --[[door.tile + 1 <= door.tileset.tile_count+2 the code was done for]] true then -- don't ask me why tile_count is off by 2
                    door.tile = door.tile + 1
                else
                    Kristal.Console:warn("Something is wrong with the rank doors. The "..door.tileset.id.." tileset might have changed.")
                end
            else
                Kristal.Console:warn("The event "..("door_"..rank).." doesn't exist.")
            end

            local interact = Interactable(data.x, data.y, data.shape, {
                text1 = "* (The "..rank.."-rank room...[wait:5] it's shut tightly with "..data.bars.." bars.)",
                text2 = "* (You hear nothing on the other side.[wait:5] Tenna might not be done with those rooms yet.)"
            })
            interact.layer = WORLD_LAYERS["above_events"] - 10 -- too lazy to check the actual number
            Game.world:addChild(interact)
        else
            local transition = Transition(data.x, data.y, data.shape, {
                map = dest_map,
                marker = "entry_d"
            })
            Game.world:addChild(transition)
        end
    end
	local interstitial_doors = Game.world:getEvent("teevie_interstitial_doors")
	if interstitial_doors and Kristal.Mods.data["dlc_mantle"] ~= nil then 
		interstitial_doors:turnOn()
	end
	self.ranking_sign = RankingHubSign(1120, 46, Game:getFlag("tvfloor_board_number", nil), Game:getFlag("tvfloor_ranking", nil))
	self.ranking_sign:setLayer(WORLD_LAYERS["above_events"])
	Game.world:addChild(self.ranking_sign)
end

return RankRoom