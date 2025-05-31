local Slider, super = Class(Map)

function Slider:onEnter()
	super.onEnter(self)

	if Game:hasPartyMember("jamm") then
		Game.world:getEvent(45):remove()
	end
end

return Slider