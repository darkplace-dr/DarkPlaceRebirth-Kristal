local JackensteinActorSprite, super = Class(ActorSprite)

function JackensteinActorSprite:init(actor)
    super.init(self, actor)

    self.animsiner = 0

    self.eyes = Sprite(self:getTexturePath("eyes"), 0, 0)
    self.eyes.debug_select = false
    self:addChild(self.eyes)
end

function JackensteinActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function JackensteinActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function JackensteinActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function JackensteinActorSprite:update()
    super.update(self)

    if self.anim == "idle" or self.anim == "spared" then
        self.animsiner = self.animsiner + (0.16666666666666666 * DTMULT)
		
        self.eyes.y = (math.sin(self.animsiner / 1.35) * 8)/2

        self.eyes:setFrame(math.floor(self.animsiner))
		local jack = Game.battle.encounter.jackenstein
		self.eyes.alpha = jack.alpha
		if jack.alpha >= 1 then
			if Game.battle.encounter.jackenstein.mercy <= 20 then
				local afterimage = AfterImage(self, 1, 0.15)
				afterimage.y = self.y + (math.sin(self.animsiner / 1.35) * 8)/2
				Game.battle:addChild(afterimage)
			end
			if Game.battle.encounter.jackenstein.mercy >= 20 and Game.battle.encounter.jackenstein.mercy <= 50 then
				local afterimage = AfterImage(self, 1, 0.07)
				afterimage.y = self.y + (math.sin(self.animsiner / 1.35) * 8)/2
				Game.battle:addChild(afterimage)
			end
			if Game.battle.encounter.jackenstein.mercy >= 50 then
				local afterimage = AfterImage(Game.battle.encounter.jackenstein, 1, 0.04)
				afterimage.y = self.y + (math.sin(self.animsiner / 1.35) * 8)/2
				Game.battle:addChild(afterimage)
			end
		end
    end
end

return JackensteinActorSprite