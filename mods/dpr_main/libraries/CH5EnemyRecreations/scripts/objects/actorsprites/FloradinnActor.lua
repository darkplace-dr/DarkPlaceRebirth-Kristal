local FloradinnActor, super = Class(ActorSprite)

function FloradinnActor:init(actor)
    super.init(self, actor)
    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)
	
    self.spikes = Sprite(self:getTexturePath("spikes"), 0, 0)
    self.spikes.visible = false
    self.spikes.debug_select = false
    self:addChild(self.spikes)
	
    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

	self.maneanimcon = 0
	self.maneanimtimer = 0
	self.headx = 0
	self.heady = 0
	self.headdir = 0
	self.headlen = 0
	self.spikegrowtimer = 0
	self.last_anim = self.anim
	self.hidespikes = false
	self.spikes_returning = false
    self.body_tex = Assets.getFrames(self:getTexturePath("body"))
    self.head_tex = Assets.getFrames(self:getTexturePath("head"))
    self.spikes_tex = Assets.getFrames(self:getTexturePath("spikes"))
    self.spikes_return_tex = Assets.getFrames(self:getTexturePath("spikes_return"))
end

function FloradinnActor:update()
    super.update(self)
	if self.maneanimcon == 1 then
		self.maneanimtimer = self.maneanimtimer + DTMULT
		self.headlen = 20
		if #Game.battle:getActiveEnemies() == 1 then
			self.headdir = MathUtils.lerp(self.headdir, -180, 1 - (1 - (self.maneanimtimer / 20)) ^ DTMULT)
			self.headx = MathUtils.lengthDirX(self.headlen, math.rad(self.headdir))
			self.heady = MathUtils.lengthDirY(self.headlen, math.rad(self.headdir))
			if self.maneanimtimer >= 9 then
				self.hidespikes = true
			end
			if self.maneanimtimer >= 20 then
				self.maneanimtimer = 0
				self.maneanimcon = 2
			end
		else
			self.headdir = MathUtils.lerp(self.headdir, -180, 1 - (1 - (self.maneanimtimer / 30)) ^ DTMULT)
			self.headx = MathUtils.lengthDirX(self.headlen, math.rad(self.headdir))
			self.heady = MathUtils.lengthDirY(self.headlen, math.rad(self.headdir))
			if self.maneanimtimer >= 10 then
				self.hidespikes = true
			end
			if self.maneanimtimer >= 30 then
				self.maneanimtimer = 0
				self.maneanimcon = 2
			end
		end
	end
	if self.maneanimcon == 2 then
		self.maneanimtimer = self.maneanimtimer + DTMULT
		if self.maneanimtimer >= 1 then
			self.last_anim = self.anim
			self.spikes:setSprite(self:getTexturePath("spikes_return"))
			self.spikes:setFrame(1)
			self:setAnimation("mane")
			self.maneanimtimer = 0
			self.maneanimcon = 0
			self.heady = 0
			self.headdir = 0
			self.headlen = 0
			self.spikes_returning = true
		end
	end
	if self.spikes_returning then
		self.spikegrowtimer = self.spikegrowtimer + 1 * DTMULT
		if self.spikegrowtimer < 3 then
			self.headx = MathUtils.lerp(self.headx, 0, 1 - (1 - (self.spikegrowtimer / 2)) ^ DTMULT)
		end
		if self.spikegrowtimer >= 3 then
			self.headx = 0
		end
		if self.spikegrowtimer >= 16 then
			self.spikes_returning = false
			self.spikegrowtimer = 0
			self.hidespikes = false
			self:setAnimation(self.last_anim)
			self.spikes:setSprite(self:getTexturePath("spikes"))
		end
	end
	self.head.x = self.headx
	self.head.y = self.heady
	self.spikes.x = self.headx
	self.spikes.y = self.heady
	self.body:setFrame(self.frame)
	self.head:setFrame(self.frame)
	if self.spikes_returning then
		self.spikes:setFrame(math.floor(self.spikegrowtimer / 4) + 1)
	else
		self.spikes:setFrame(self.frame)
	end
	if self.anim == "idle" or self.anim == "mane" or self.spikes_returning then
		self.body.visible = true
		self.head.visible = true
		self.spikes.visible = (self.hidespikes ~= true or self.spikes_returning) and true or false
	else
		self.body.visible = false
		self.head.visible = false
		self.spikes.visible = false
	end
end

function FloradinnActor:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

return FloradinnActor