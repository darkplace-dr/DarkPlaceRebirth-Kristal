local ShinobeetleActor, super = Class(ActorSprite)

function ShinobeetleActor:init(actor)
    super.init(self, actor)

    self.wings_l = Sprite(self:getTexturePath("wings_l"))
	self.wings_l:setOriginExact(12, 37)
	self.wings_l.visible = false
    self.wings_l.debug_select = false
    self:addChild(self.wings_l)

    self.wings_r = Sprite(self:getTexturePath("wings_r"))
	self.wings_r:setOriginExact(29, 35)
	self.wings_r.visible = false
    self.wings_r.debug_select = false
    self:addChild(self.wings_r)

    self.body = Sprite(self:getTexturePath("body"))
	self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)

	self.feet = Sprite(self:getTexturePath("feet"))
	self.feet.visible = false
    self.feet.debug_select = false
    self:addChild(self.feet)

	self.arms = Sprite(self:getTexturePath("arms"))
	self.arms.visible = false
    self.arms.debug_select = false
    self:addChild(self.arms)

	self.siner = 0

	self.leftwingangle = 0
	self.rightwingangle = 0

	self.wingcon = 0
	self.wingtimer = 0
	self.wingtimermax = 60 + MathUtils.randomInt(91)
	self.wingsiner = 0
end

function ShinobeetleActor:setAnimation(anim, callback, ignore_actor_callback)
    if anim == "idle" then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function ShinobeetleActor:update()
    super.update(self)

	if self.visible then
        self.wings_l.alpha = self.alpha
        self.wings_r.alpha = self.alpha
		self.body.alpha = self.alpha
		self.feet.alpha = self.alpha
		self.arms.alpha = self.alpha

        self.siner = self.siner + 0.16666666666666666 * DTMULT

		local a = 6.5

        local anim = self.anim or "idle"
        if anim == "idle" then
            self.wings_l.x = self.x + 24 / 2
			self.wings_l.y = self.y + (74 + math.sin(self.siner) * 2) / 2
			self.wings_l.rotation = -math.rad(self.rightwingangle + (math.sin(self.wingsiner + a)) * 30)

			self.wings_r.x = self.x + 58 / 2
			self.wings_r.y = self.y + (60 + math.sin(self.siner) * 2) / 2
			self.wings_r.rotation = -math.rad(self.leftwingangle - (math.sin(self.wingsiner + a)) * 30)

			self.body.x = self.x
			self.body.y = self.y + (math.sin(self.siner) * 1.5) / 2

			self.feet.x = self.x
			self.feet.y = self.y

			self.arms.x = self.x
			self.arms.y = self.y + (math.sin(self.siner) * 3) / 2
        end
    end

	if self.wingcon == 0 then
		local old_wingt = self.wingtimer
		self.wingtimer = self.wingtimer + DTMULT

		if old_wingt < self.wingtimermax and self.wingtimer >= self.wingtimermax then
			self.wingcon = 1
			self.wingtimer = 0
			self.wingtimermax = 60 + MathUtils.randomInt(91)
		end
	elseif self.wingcon == 1 then
		local old_wingt = self.wingtimer
		self.wingtimer = self.wingtimer + DTMULT
		self.wingsiner = self.wingsiner + DTMULT

		if old_wingt < 20 and self.wingtimer >= 20 then
			self.wingcon = 0
			self.wingtimer = 0
			self.wingsiner = 0
		end
	end
end

function ShinobeetleActor:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function ShinobeetleActor:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

return ShinobeetleActor