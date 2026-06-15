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

    self.vines_1 = Sprite("world/maps/tvland/green_room_vines", -48, 120)
    self.vines_1:setScale(2,2)
    self.vines_1.wrap_texture_x = true
    self.vines_1:setLayer(Game.world:parseLayer("objects_below") + 0.1)
    self.vines_1:addFX(ScissorFX(0, 0, 640+48, 32))
    Game.world:addChild(self.vines_1)
    self.vines_2 = Sprite("world/maps/tvland/green_room_vines", 640, 80)
    self.vines_2:setScale(2,2)
    self.vines_2.wrap_texture_x = true
    self.vines_2:setLayer(Game.world:parseLayer("objects_below") + 0.36)
    self.vines_2:addFX(ScissorFX(0, 0, 80, 32))
    Game.world:addChild(self.vines_2)
    self.vines_3 = Sprite("world/maps/tvland/green_room_vines", 720, 120)
    self.vines_3:setScale(2,2)
    self.vines_3.wrap_texture_x = true
    self.vines_3:setLayer(Game.world:parseLayer("objects_below") + 0.36)
    self.vines_3:addFX(ScissorFX(0, 0, 80, 32))
    Game.world:addChild(self.vines_3)
    self.vines_4 = Sprite("world/maps/tvland/green_room_vines", 800, 80)
    self.vines_4:setScale(2,2)
    self.vines_4.wrap_texture_x = true
    self.vines_4:setLayer(Game.world:parseLayer("objects_below") + 0.36)
    self.vines_4:addFX(ScissorFX(0, 0, 160, 32))
    Game.world:addChild(self.vines_4)

    local can_kill = Game:getFlag("can_kill", false)    
    if can_kill == false then
        local max_amount = (self.width) / 55
        
        for i = 0, 7 do
            local y_offset = 10
            if i % 2 == 1 then
                y_offset = 4
            end
            local shine = Sprite("world/maps/tvland/shine_white", 128 + (i * 53), 40 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
            
        for i = 0, 6 do
            local y_offset = 20
            local x_offset = 8
            if i % 2 == 0 then
                y_offset = 14
                x_offset = 8
            end
            local shine = Sprite("world/maps/tvland/shine_white", 156 + (i * 60) + x_offset, 45 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
        for i = 0, 2 do
            local y_offset = 10
            if i % 2 == 1 then
                y_offset = 4
            end
            local shine = Sprite("world/maps/tvland/shine_white", 946 + (i * 53), 40 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
            
        for i = 0, 2 do
            local y_offset = 20
            local x_offset = 8
            if i % 2 == 0 then
                y_offset = 14
                x_offset = 8
            end
            local shine = Sprite("world/maps/tvland/shine_white", 962 + (i * 60) + x_offset, 45 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
        for i = 0, 1 do
            local y_offset = 10
            if i % 2 == 1 then
                y_offset = 4
            end
            local shine = Sprite("world/maps/tvland/shine_white", 1221 + (i * 53), 40 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
            
        for i = 0, 1 do
            local y_offset = 20
            local x_offset = 8
            if i % 2 == 0 then
                y_offset = 14
                x_offset = 8
            end
            local shine = Sprite("world/maps/tvland/shine_white", 1210 + (i * 60) + x_offset, 45 + y_offset)
            shine:setScale(2,2)
            shine.color = {232/255, 1, 200/255}
            shine:play(1/2.4)
            shine:setFrame(i)
            shine:setLayer(Game.world:parseLayer("objects_below") + 0.37)
            Game.world:addChild(shine)
        end
    end
end

return RankRoom