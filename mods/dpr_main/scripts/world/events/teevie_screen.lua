local TeevieScreen, super = Class(Event)

function TeevieScreen:init(data)
    super.init(self, data)
	
    self:setSprite("world/events/teevie_screen/screen")
	self.sprite:setScale(1,1)
	self.face = Sprite("world/events/teevie_screen/face", 40, 48)
	self.face.scale_y = 0
	self.face:setOriginExact(22, 9)
	self.face:setLayer(self.layer + 0.01)
	self:addChild(self.face)
	self.frame = Sprite("world/events/teevie_screen/frame", 0, 0)
	self.frame:setLayer(self.layer + 0.02)
	self:addChild(self.frame)

    self.turned_on = false
end

function TeevieScreen:turnOn()
	if not self.turned_on then
		Assets.playSound("dtrans_square", 0.5, 3)
		Game.world.timer:tween(24/30, self.face, {scale_y = 1}, "out-elastic")
		self.turned_on = true
	end
end

function TeevieScreen:update()
    if not self.turned_on and Game.world and Game.world.player then
        local player = Game.world.player

		if player.x > self.x - 10 and player.x < self.x + 50 and player.y >= self.y + 20 then
			self:turnOn()
		end
    end

    super.update(self)
end

return TeevieScreen