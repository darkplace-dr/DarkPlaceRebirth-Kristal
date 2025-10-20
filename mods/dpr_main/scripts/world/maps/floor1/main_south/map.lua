local MainHub, super = Class(Map)

function MainHub:onEnter()
    super.onEnter(self)
	self.ina = Music("inainaina", 0)
end

function MainHub:onExit()
    super.onExit(self)
	self.ina:remove()
end

return MainHub