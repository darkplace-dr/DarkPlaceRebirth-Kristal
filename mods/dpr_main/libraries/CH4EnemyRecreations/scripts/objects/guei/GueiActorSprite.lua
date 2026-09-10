local GueiActorSprite, super = Class(ActorSprite)

function GueiActorSprite:init(actor)
    super.init(self, actor)

    self.arm_back = Sprite(self:getTexturePath("arm_back"))
    self.arm_back.visible = false
    self.arm_back.debug_select = false
    self:addChild(self.arm_back)

    self.body = Sprite(self:getTexturePath("body"))
    self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"))
    self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

    self.arm_front = Sprite(self:getTexturePath("arm_front"))
    self.arm_front.visible = false
    self.arm_front.debug_select = false
    self:addChild(self.arm_front)

    self.wisp1 = Sprite(self:getTexturePath("wisp1"))
    self.wisp1.visible = false
    self.wisp1.debug_select = false
    self:addChild(self.wisp1)

    self.wisp2 = Sprite(self:getTexturePath("wisp2"))
    self.wisp2.visible = false
    self.wisp2.debug_select = false
    self:addChild(self.wisp2)

    self.chase1 = Sprite(self:getTexturePath("chase"), 20, 34)
    self.chase1.visible = false
    self.chase1.debug_select = false
    self:addChild(self.chase1)

    self.chase2 = Sprite(self:getTexturePath("chase"), 20, 34)
    self.chase2.visible = false
    self.chase2.debug_select = false
    self:addChild(self.chase2)

    self.encounter = Sprite(self:getTexturePath("idle_nowisp"))
    self.encounter.visible = false
    self.encounter.debug_select = false
    self:addChild(self.encounter)

	self.animsiner = -14
	self.timer = 0
end

function GueiActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

function GueiActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function GueiActorSprite:setAnimation(anim, callback, ignore_actor_callback)
    self.timer = 0
    local animations = { "idle", "spared", "chase", "encounter" }
    if TableUtils.contains(animations, anim) then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
        if anim == "idle" then
            self.wisp1.alpha = 0
            self.wisp2.alpha = 0
        end
        if anim == "idle" or anim == "spared" then
            self.chase1.visible = false
            self.chase2.visible = false
            self.encounter.visible = false
        end
        if anim == "chase" then
            self.arm_back.visible = false
            self.body.visible = false
            self.head.visible = false
            self.arm_front.visible = false
            self.wisp1.visible = false
            self.wisp2.visible = false
            self.encounter.visible = false
        end
        if anim == "encounter" then
            self.arm_back.visible = false
            self.body.visible = false
            self.head.visible = false
            self.arm_front.visible = false
            self.wisp1.visible = false
            self.wisp2.visible = false
        end
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function GueiActorSprite:update()
    super.update(self)

    if self.anim == "idle" or self.anim == "spared" then
        self.animsiner = self.animsiner + DTMULT

        self.arm_back:setFrame(1 + math.floor((self.animsiner + 2) / 6))
        self.body:setFrame(1 + math.floor(self.animsiner / 6))
        self.head:setFrame(1 + math.floor(self.animsiner / 6))
        self.arm_front:setFrame(1 + math.floor((self.animsiner + 4) / 6))

        self.wisp1:setFrame(1 + math.floor(self.animsiner / 6))
        self.wisp1.alpha = math.sin(self.animsiner / 14) * 0.5
        self.wisp1.x = 0 + (math.sin(self.animsiner / 6) * 2)
        self.wisp1.y = 0 + (math.cos(self.animsiner / 6) * 2)

        self.wisp2:setFrame(1 + math.floor(self.animsiner / 6))
        self.wisp2.alpha = math.sin((self.animsiner + 7) / 14) * 0.5
        self.wisp2.x = 0 - (math.sin(self.animsiner / 6) * 2)
        self.wisp2.y = 0 - (math.cos(self.animsiner / 6) * 2)
    elseif self.anim == "chase" then
        self.animsiner = self.animsiner + DTMULT

        self.chase1:setFrame(1 + math.floor(self.animsiner / 6))
		self.chase1.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase1.alpha = 1
        self.chase2:setFrame(1 + math.floor((self.animsiner + 1) / 6))
		self.chase2.x = 20 + (math.sin(self.animsiner / 2) * 2)/2
		self.chase2.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase2.alpha = 0.5
    elseif self.anim == "encounter" then
        self.animsiner = self.animsiner + DTMULT
		self.timer = self.timer + DTMULT
		local prog = MathUtils.clamp(self.timer / 20, 0, 1)

        self.chase1:setFrame(1 + math.floor(self.animsiner / 6))
		self.chase1.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase1.alpha = 1 - (prog * 2)
        self.chase2:setFrame(1 + math.floor((self.animsiner + 1) / 6))
		self.chase2.x = 20 + (math.sin(self.animsiner / 2) * 2)/2
		self.chase2.y = 34 + (math.cos(self.animsiner / 12) * 8)/2
		self.chase2.alpha = 0.5 - (prog * 2)

		self.encounter:setFrame(1 + math.floor(self.animsiner / 4))
		--self.encounter.x = 0 - (60 * (1 - prog))
		--self.encounter.y = 0 - (80 * (1 - prog))
		self.encounter.alpha = prog * 4
    end
end

return GueiActorSprite