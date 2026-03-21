local DarkRoomBGEvent, super = Class(Event)

function DarkRoomBGEvent:init(data)
    super.init(self, data)
	self.debug_select = false
end

function DarkRoomBGEvent:onAdd(parent)
    super.onAdd(self, parent)
	Game.world:spawnObject(DarkRoomBG(), "objects_bg")
	self:remove()
end

return DarkRoomBGEvent