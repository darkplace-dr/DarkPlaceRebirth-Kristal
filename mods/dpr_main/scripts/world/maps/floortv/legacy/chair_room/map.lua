---@class Map.dark_place : Map
local map, super = Class(Map, "floortv/legacy/chair_room")

function map:init(world, data)
    super.init(self, world, data)
	
	self.room_x_x = 0
end

function map:onEnter()
	for _, event in ipairs(Game.world.map.events) do
		if event.layer == self.layers["objects_distort"] then
			event:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, 0.4))
			event.collider.collidable = false
			event.visible = false
			event:addFX(DarkBlurFX(0, 0.3), "blur")
		elseif event.layer == self.layers["objects_nondistort"] then
			event.collider.collidable = true
			event.visible = true
			event.layer = Game.world.map.layers["objects_party"]
		end
	end
    for _, party in ipairs(Game.party) do
		for _, char in ipairs(Game.stage:getObjects(Character)) do
			if char.actor and char.actor.id == party:getActor(false).id then
				char:setActor(party:getActor(true))
			end
		end
	end
	Game.world.map:getImageLayer("bg_dark").visible = false
	Game.world.map:getImageLayer("bg_dark"):setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, 0.4))
	Game.world.map:getImageLayer("bg_dark"):addFX(DarkBlurFX(2, 0.3, true), "blur")
	Game:setFlag("chair_room_darker", false)
    love.window.setTitle("But what if it could...")
end

function map:onExit()
	Kristal.setDesiredWindowTitleAndIcon()
end

return map