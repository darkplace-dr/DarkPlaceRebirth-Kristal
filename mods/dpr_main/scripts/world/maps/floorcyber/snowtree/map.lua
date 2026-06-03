local Room1, super = Class(Map)

function Room1:onEnter()
    super.onEnter(self)
	for _, follower in ipairs(Game.world.followers) do
		follower.visible = false
	end
end

return Room1