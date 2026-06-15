local QueenTrafficLight, super = Class(Event)

function QueenTrafficLight:init(data)
    super.init(self, data)

    self:setSprite("world/events/floor2/traffic_light")
	self.sprite:setFrame(Game.world.map.car_pause and 2 or 1)
    self.solid = true
end

function QueenTrafficLight:onInteract()
	Assets.playSound("noise")
    Game.world.map.car_pause = not Game.world.map.car_pause
	self.sprite:setFrame(Game.world.map.car_pause and 2 or 1)
	return true
end

return QueenTrafficLight