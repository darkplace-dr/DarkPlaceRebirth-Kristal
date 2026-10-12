local TerakotaActor, super = Class(ActorSprite)

function TerakotaActor:init(actor)
    super.init(self, actor)

    self.backpouldron = Sprite(self:getTexturePath("backpouldron"))
	self.backpouldron.visible = false
    self.backpouldron.debug_select = false
    self:addChild(self.backpouldron)

    self.feet = Sprite(self:getTexturePath("feet"))
	self.feet.visible = false
    self.feet.debug_select = false
    self:addChild(self.feet)

    self.body = Sprite(self:getTexturePath("body"))
	self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)

	self.hands = Sprite(self:getTexturePath("hands"))
	self.hands:setOriginExact(45, 47)
	self.hands.visible = false
    self.hands.debug_select = false
    self:addChild(self.hands)

	self.head_bloomed = Sprite(self:getTexturePath("head_bloomed"))
	self.head_bloomed.visible = false
    self.head_bloomed.debug_select = false
    self:addChild(self.head_bloomed)

	self.head = Sprite(self:getTexturePath("head"))
	self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

	self.head_plant = Sprite(self:getTexturePath("head_plant"))
	self.head_plant.visible = false
    self.head_plant.debug_select = false
    self:addChild(self.head_plant)

	self.front_shoulder = Sprite(self:getTexturePath("front_shoulder"))
	self.front_shoulder:setOriginExact(0, 0)
	self.front_shoulder.visible = false
    self.front_shoulder.debug_select = false
    self:addChild(self.front_shoulder)

	self.siner = 0

	self.headballooncon = 0
	self.headballoontimer = 0
end

function TerakotaActor:setAnimation(anim, callback, ignore_actor_callback)
    if anim == "idle" then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
		self.head_bloomed.visible = false
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function TerakotaActor:update()
    super.update(self)

	if self.visible then
        self.backpouldron.alpha = self.alpha
        self.feet.alpha = self.alpha
		self.body.alpha = self.alpha
		self.hands.alpha = self.alpha
		self.head_bloomed.alpha = self.alpha
		self.head.alpha = self.alpha
		self.head_plant.alpha = self.alpha
		self.front_shoulder.alpha = self.alpha

        self.siner = self.siner + 0.16666666666666666 * DTMULT

        local anim = self.anim or "idle"
        if anim == "idle" then
            self.backpouldron.x = self.x
			self.backpouldron.y = self.y - (math.sin(self.siner) * 2) / 2

			self.feet.x = self.x
			self.feet.y = self.y

			self.body.x = self.x
			self.body.y = self.y - (math.sin(self.siner) * 2) / 2

			self.hands.x = self.x + (90 - math.sin(self.siner) * 1) / 2
			self.hands.y = self.y - (math.sin(self.siner) * 1) / 2 + (94 / 2) - (math.sin(self.siner) * 2) / 2
			self.hands.rotation = self.rotation - -math.rad(math.sin(self.siner) * 4)

			if self.headballooncon == 1 then
				self.head.visible = false
				self.head_plant.visible = false
				self.head_bloomed.visible = true

				self.head_bloomed.x = self.x
				self.head_bloomed.y = self.y - (math.sin(self.siner) * 1) / 2
			else
				self.head.visible = true
				self.head_plant.visible = true
				self.head_bloomed.visible = false

				self.head.x = self.x
				self.head.y = self.y - (math.sin(self.siner) * 1) / 2

				self.head_plant.x = self.x
				self.head_plant.y = self.y - (math.sin(self.siner) * 1) / 2
			end

			self.front_shoulder.x = self.x
			self.front_shoulder.y = self.y - (math.sin(self.siner) * 2) / 2
        end
    end
end

function TerakotaActor:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function TerakotaActor:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

return TerakotaActor