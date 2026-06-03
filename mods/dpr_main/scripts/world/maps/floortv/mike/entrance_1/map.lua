local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
	Game.world.timer:after(1/30, function()
		Mod:enableMicAccess(Game:getFlag("microphone_id", 1))
	end)
end

return map
