local ManTree, super = Class(Event)

function ManTree:init(data)
    super.init(self, data)
	
    self:setSprite("world/events/mantree/bark")
    self.leaves_1_sprite = Sprite("world/events/mantree/leaves_1")
    self.leaves_1_sprite:setScale(2)
	self.leaves_1_sprite.layer = self.layer + 1
    self:addChild(self.leaves_1_sprite)
    self.leaves_2_sprite = Sprite("world/events/mantree/leaves_2")
    self.leaves_2_sprite:setScale(2)
	self.leaves_2_sprite.layer = self.layer + 2
    self:addChild(self.leaves_2_sprite)
	
	self:setOrigin(0.5, 1)
	self.siner = 0
	self.blocktimer = 0
	self.blockcon = 0
	self.block_sprite = nil
end

function ManTree:update()
    super.update(self)

	self.siner = self.siner + DTMULT
	self.blocktimer = self.blocktimer + DTMULT
	if self.blocktimer >= 20 then
		if self.blockcon == 0 then
			local x = self.x - 105 + 210/4 + Utils.random(210/2)
			local y = self.y - 182 + 182/4 + Utils.random(182/4)
			self.block_sprite = Sprite("world/events/mantree/block", x, y)
			self.block_sprite.physics.speed_x = 0.4 + Utils.random(1)
			self.block_sprite.physics.speed_y = 0.7 + Utils.random(1.5)
			self.block_sprite.physics.gravity = 0.1
			self.block_sprite.physics.friction = -0.1
			self.block_sprite.alpha = 0
			self.block_sprite.layer = self.layer + 3
			self.block_sprite:setScale(2)
			Game.world:addChild(self.block_sprite)
			self.blockcon = 1
		end
		if self.blocktimer <= 30 then
			if self.block_sprite and self.block_sprite.alpha < 1 then
				self.block_sprite.alpha = self.block_sprite.alpha + 0.2 * DTMULT
			end
		end
	end
	if self.blocktimer >= 38 then
		if self.block_sprite then
			self.block_sprite.alpha = self.block_sprite.alpha - 0.1 * DTMULT
		end
	end
	if self.blocktimer >= 48 then
		if self.block_sprite then
			self.block_sprite:remove()
			self.block_sprite = nil
		end
		self.blocktimer = 0
		self.blockcon = 0
	end

	self.leaves_1_sprite.x = math.sin(self.siner / 12) * 2
	self.leaves_1_sprite.y = math.cos(self.siner / 20) * 2
	self.leaves_2_sprite.x = math.sin(self.siner / 14) * 1
	self.leaves_2_sprite.y = math.cos(self.siner / 24) * 1
end

return ManTree