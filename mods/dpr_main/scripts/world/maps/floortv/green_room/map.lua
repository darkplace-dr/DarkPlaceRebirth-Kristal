local Room1, super = Class(Map)

function Room1:load()
    super.load(self)

	self.vines_1 = Sprite("world/maps/tvland/green_room_vines", 120, 40)
	self.vines_1:setScale(2,2)
	self.vines_1.wrap_texture_x = true
	self.vines_1:setLayer(Game.world:parseLayer("objects_below") + 0.36)
	if Game:getFlag("in_rambs_room") then
		self.vines_1:setLayer(Game.world:parseLayer("objects_barabove") + 0.36)
	end
	self.vines_1:addFX(ScissorFX(0, 0, 576-122, 32))
	Game.world:addChild(self.vines_1)
	self.vines_2 = Sprite("world/maps/tvland/green_room_vines", 930, 40)
	self.vines_2:setScale(2,2)
	self.vines_2.wrap_texture_x = true
	self.vines_2:setLayer(Game.world:parseLayer("objects_below") + 0.36)
	if Game:getFlag("in_rambs_room") then
		self.vines_2:setLayer(Game.world:parseLayer("objects_barabove") + 0.36)
	end
	self.vines_2:addFX(ScissorFX(0, 0, 1120-930, 32))
	Game.world:addChild(self.vines_2)
	self.vines_3 = Sprite("world/maps/tvland/green_room_vines", 1212, 40)
	self.vines_3:setScale(2,2)
	self.vines_3.wrap_texture_x = true
	self.vines_3:setLayer(Game.world:parseLayer("objects_below") + 0.36)
	if Game:getFlag("in_rambs_room") then
		self.vines_3:setLayer(Game.world:parseLayer("objects_barabove") + 0.36)
	end
	self.vines_3:addFX(ScissorFX(0, 0, 1320-1212, 32))
	Game.world:addChild(self.vines_3)
		
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
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
			if Game:getFlag("in_rambs_room") then
				shine:setLayer(Game.world:parseLayer("objects_barabove") + 0.37)
			end
			Game.world:addChild(shine)
		end
	end
	if Game:getFlag("in_rambs_room") then
		local door_rect = Rectangle(694, 54, 92, 60)
		door_rect:setColor(COLORS.black)
		door_rect:setLayer(Game.world:parseLayer("objects_below_2") + 0.01)
		Game.world:addChild(door_rect)
		for _, event in ipairs(Game.world.map.events) do
			if event.layer == self.layers["objects_base"] then
				event.collider.collidable = false
			end
		end
	else
		for _, event in ipairs(Game.world.map.events) do
			if event.layer == self.layers["objects_barabove"] then
				event.visible = false
			end
		end
	end
	if Game:getFlag("can_kill") then -- note: maybe make this more specific, like killing all the tv world enemies?
		self:getEvent(90).collider.collidable = false
		for _, event in ipairs(Game.world.map.events) do
			if event.layer == self.layers["objects_dessim_door_a"] or event.layer == self.layers["objects_dessim_door_b"] then
				event.visible = false
				if event.layer == self.layers["objects_dessim_door_a"] and not Game:getFlag("locked_tenna_door_opened") then
					event.visible = true
				elseif event.layer == self.layers["objects_dessim_door_b"] and Game:getFlag("locked_tenna_door_opened") then
					event.visible = true
				end
			end
		end
		if not Game:getFlag("locked_tenna_door_opened") then
			self:getEvent(117).collider.collidable = false
			self:getEvent(113).collider.collidable = true
		else
			self:getEvent(117).collider.collidable = true
			self:getEvent(113).collider.collidable = false
		end
	else
		self:getEvent(117).collider.collidable = false
		for _, event in ipairs(Game.world.map.events) do
			if event.layer == self.layers["objects_dessim_door_a"] or event.layer == self.layers["objects_dessim_door_b"] then
				event.visible = false
				event.collider.collidable = false
			end
		end
	end
end

function Room1:onExit()
    super.onExit(self)
end

function Room1:loadLayer(layer, depth)
    if layer.type == "objectgroup" then
        if StringUtils.startsWith(layer.name:lower(), "base_collision") and not Game:getFlag("in_rambs_room") then
            self:loadCollision(layer)
        elseif StringUtils.startsWith(layer.name:lower(), "ramb_collision") and Game:getFlag("in_rambs_room") then
            self:loadCollision(layer)
        end
        self:loadShapes(layer)
    end
    super.loadLayer(self, layer, depth)
end

return Room1