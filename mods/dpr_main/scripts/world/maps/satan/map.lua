local Room1, super = Class(Map)

function Room1:init(world, data)
	super.init(self, world, data)
end

function Room1:onEnter()
    super.onEnter(self)
    
for i, follower in ipairs(Game.world.followers) do
    follower.visible = false
end
end

function Room1:onExit()
    super.onExit(self)
end

return Room1