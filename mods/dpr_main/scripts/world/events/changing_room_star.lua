local ChangingRoomStar, super = Class(Event)

function ChangingRoomStar:init(data)
    super.init(self, data)
	
	properties = data.properties or nil
    self.starindex = properties["starindex"] or 1
    self.sinerindex = properties["sinerindex"] or 0

	self.siner = 0
	self.x_start = self.x
	self.y_start = self.y
	
    self:setSprite("world/events/changing_room_stars")
    self.sprite:stop()
	self.sprite:setFrame(self.starindex)
	self:setOrigin(0.5)
	self:setScale(0.5)
end

function ChangingRoomStar:update()
    super.update(self)
	self.siner = self.siner + 0.02 * DTMULT
	
	self.x = self.x_start + math.sin(self.siner) + (self.sinerindex * 0.1)
	self.y = self.y_start + math.cos(self.siner) + (self.sinerindex * 0.1)
end

return ChangingRoomStar