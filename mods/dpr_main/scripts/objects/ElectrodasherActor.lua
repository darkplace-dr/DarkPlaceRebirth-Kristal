local ElectrodasherActorSprite, super = Class(ActorSprite)

function ElectrodasherActorSprite:init(actor)
    super.init(self, actor)

    self.animsiner = 0

    self.legs = Sprite(self:getTexturePath("legs"), 0, 0)
    self.legs.debug_select = false
    self:addChild(self.legs)

    self.body = Sprite(self:getTexturePath("body"), 0, 11)
    self.body.debug_select = false
    self:addChild(self.body)
end

function ElectrodasherActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function ElectrodasherActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function ElectrodasherActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function ElectrodasherActorSprite:update()
    super.update(self)

    if self.anim == "idle" or self.anim == "spared" then
        self.animsiner = self.animsiner + (1 * DTMULT)
		
        local lerp_y = Utils.ease(11, 0, (self.animsiner / 15), "linear")

        self.body:setFrame(math.floor((self.animsiner / 5) * 2))
        self.body.x = 0 + (math.sin(self.animsiner / 10) * 2)
        self.body.y = lerp_y - (math.sin(self.animsiner / 5) * 2)

        self.legs:setFrame(math.floor((self.animsiner / 10) * 2))
    end
end

return ElectrodasherActorSprite