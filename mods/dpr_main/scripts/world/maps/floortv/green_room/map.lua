local Room1, super = Class(Map)

function Room1:load()
    super.load(self)

	self.vines_1 = Sprite("world/maps/tvland/green_room_vines", 120, 40)
	self.vines_1:setScale(2,2)
	self.vines_1.wrap_texture_x = true
	self.vines_1:setLayer(Game.world:parseLayer("objects_below") + 0.36)
	self.vines_1:addFX(ScissorFX(0, 0, 576-122, 32))
	Game.world:addChild(self.vines_1)
	self.vines_2 = Sprite("world/maps/tvland/green_room_vines", 930, 40)
	self.vines_2:setScale(2,2)
	self.vines_2.wrap_texture_x = true
	self.vines_2:setLayer(Game.world:parseLayer("objects_below") + 0.36)
	self.vines_2:addFX(ScissorFX(0, 0, 1120-930, 32))
	Game.world:addChild(self.vines_2)
	self.vines_3 = Sprite("world/maps/tvland/green_room_vines", 1212, 40)
	self.vines_3:setScale(2,2)
	self.vines_3.wrap_texture_x = true
	self.vines_3:setLayer(Game.world:parseLayer("objects_below") + 0.36)
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

function Room1:onExit()
    super.onExit(self)
end

return Room1