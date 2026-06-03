local GueiActorSprite, super = Class(ActorSprite)

function GueiActorSprite:init(actor)
    super.init(self, actor)

    self.arm_back = Sprite(self:getTexturePath("arm_back"), 0, 0)
    self.arm_back.debug_select = false
    self:addChild(self.arm_back)

    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head.debug_select = false
    self:addChild(self.head)

    self.arm_front = Sprite(self:getTexturePath("arm_front"), 0, 0)
    self.arm_front.debug_select = false
    self:addChild(self.arm_front)

    self.wisp1 = Sprite(self:getTexturePath("wisp1"), 0, 0)
    self.wisp1.debug_select = false
    self:addChild(self.wisp1)

    self.wisp2 = Sprite(self:getTexturePath("wisp2"), 0, 0)
    self.wisp2.debug_select = false
    self:addChild(self.wisp2)

    self.chase1 = Sprite(self:getTexturePath("chase"), 20, 34)
    self.chase1.debug_select = false
    self:addChild(self.chase1)

    self.chase2 = Sprite(self:getTexturePath("chase"), 20, 34)
    self.chase2.debug_select = false
    self:addChild(self.chase2)

    self.encounter = Sprite(self:getTexturePath("idle_nowisp"), 0, 0)
    self.encounter.debug_select = false
    self:addChild(self.encounter)

	self.animsiner = -14
	self.timer = 0
end

function GueiActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function GueiActorSprite:set(anim, ...)
	self.timer = 0
    self.actor:onSetAnimation(self, anim, ...)
end

function GueiActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function GueiActorSprite:update()
    super.update(self)

    if self.anim == "idle" or self.anim == "spared" then
        self.animsiner = self.animsiner + (1 * DTMULT)

        self.arm_back:setFrame(math.floor((self.animsiner + 2) / 6))
        self.body:setFrame(math.floor(self.animsiner / 6))
        self.head:setFrame(math.floor(self.animsiner / 6))
        self.arm_front:setFrame(math.floor((self.animsiner + 4) / 6))
		
        self.wisp1:setFrame(math.floor(self.animsiner / 6))
        self.wisp1.alpha = math.sin(self.animsiner / 14) * 0.5
        self.wisp1.x = 0 + (math.sin(self.animsiner / 6) * 2)
        self.wisp1.y = 0 + (math.cos(self.animsiner / 6) * 2)

        self.wisp2:setFrame(math.floor(self.animsiner / 6))
        self.wisp2.alpha = math.sin((self.animsiner + 7) / 14) * 0.5
        self.wisp2.x = 0 - (math.sin(self.animsiner / 6) * 2)
        self.wisp2.y = 0 - (math.cos(self.animsiner / 6) * 2)
		
		self.chase1.alpha = 0
		self.chase2.alpha = 0
		self.encounter.alpha = 0
    elseif self.anim == "chase" then
        self.animsiner = self.animsiner + (1 * DTMULT)
		
		self.arm_back.alpha = 0
		self.body.alpha = 0
		self.head.alpha = 0
		self.arm_front.alpha = 0
		self.wisp1.alpha = 0
		self.wisp2.alpha = 0
		self.encounter.alpha = 0
		
        self.chase1:setFrame(math.floor(self.animsiner / 6))
		self.chase1.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase1.alpha = 1
        self.chase2:setFrame(math.floor((self.animsiner + 1) / 6))
		self.chase2.x = 20 + (math.sin(self.animsiner / 2) * 2)/2
		self.chase2.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase2.alpha = 0.5
    elseif self.anim == "encounter" then
        self.animsiner = self.animsiner + (1 * DTMULT)
		self.timer = self.timer + (1 * DTMULT)
		local prog = MathUtils.clamp(self.timer / 20, 0, 1)
		
		self.arm_back.alpha = 0
		self.body.alpha = 0
		self.head.alpha = 0
		self.arm_front.alpha = 0
		
        self.chase1:setFrame(math.floor(self.animsiner / 6))
		self.chase1.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase1.alpha = 1 - (prog * 2)
        self.chase2:setFrame(math.floor((self.animsiner + 1) / 6))
		self.chase2.x = 20 + (math.sin(self.animsiner / 2) * 2)/2
		self.chase2.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase2.alpha = 0.5 - (prog * 2)
		
		self.encounter:setFrame(math.floor(self.animsiner / 4))
		--self.encounter.x = 0 - (60 * (1 - prog))
		--self.encounter.y = 0 - (80 * (1 - prog))
		self.encounter.alpha = prog * 4
    end
end

return GueiActorSprite