local Room1, super = Class(Map)

function Room1:load()
    super.load(self)
	Game:setFlag("pointsDisplay", true)
end

function Room1:onExit()
    super.onExit(self)
end

return Room1