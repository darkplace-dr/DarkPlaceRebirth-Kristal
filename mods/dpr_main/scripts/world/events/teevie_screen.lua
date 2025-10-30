local TeevieScreen, super = Class(Event)

function TeevieScreen:init(properties)
    super.init(self, properties)
	
    properties = properties or {}
	
    self:setSprite("world/events/teevie_screen/screen")
	self.sprite:setScale(1,1)
	self.face_tex = Assets.getTexture("world/events/teevie_screen/face")
	self.frame = Sprite("world/events/teevie_screen/frame", 0, 0)
	self.frame:setLayer(self.layer + 0.01)
	self:addChild(self.frame)

    self.turned_on = false
	self.can_turn_on = true
	self.face_scale_y = 0
	local can_kill = Game:getFlag("can_kill", false)
	if can_kill then
		self.can_turn_on = false
	end

    self.trigger_height = properties["trigger_height"] or 210
end

function TeevieScreen:turnOn()
	if not self.turned_on and self.can_turn_on then
		Assets.playSound("dtrans_square", 0.5, 3)
		Game.world.timer:lerpVar(self, "face_scale_y", 0, 1, 24, -2, "out")
		self.turned_on = true
	end
end

function TeevieScreen:update()
    if not self.turned_on and Game.world and Game.world.player and self.can_turn_on then
        local player = Game.world.player

		local px = player.x-player.width
		local py = player.y-player.height*2
		if px > self.x - 10 and px < self.x + 50 and py > self.y + 20  and py < self.y + self.trigger_height then
			self:turnOn()
		end
    end

    super.update(self)
end

function TeevieScreen:draw()
	super.draw(self)
	Draw.draw(self.face_tex, 40, 48, 0, 1, self.face_scale_y, 21, 9)
end

return TeevieScreen