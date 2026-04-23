local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
	Game.world.timer:after(1/30, function()
		Mod:disableMicAccess()
	end)
end

return map
