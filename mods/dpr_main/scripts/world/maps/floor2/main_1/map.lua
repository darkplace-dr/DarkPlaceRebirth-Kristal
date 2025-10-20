local FloorTwo, super = Class(Map)

function FloorTwo:onEnter()
	super.onEnter(self)

	Game:rollShiny("jamm")
end

return FloorTwo