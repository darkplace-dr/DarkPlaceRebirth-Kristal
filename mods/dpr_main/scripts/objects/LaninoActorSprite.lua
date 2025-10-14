local LaninoActorSprite, super = Class(ActorSprite)

function LaninoActorSprite:init(actor)
    super.init(self, actor)

    self.legs = Sprite(self:getTexturePath("legs"), 21, 61)
    self.legs:setOriginExact(7, 22)
    self.legs.debug_select = false
    self:addChild(self.legs)

    self.leftarm = Sprite(self:getTexturePath("leftarm"), 17, 29)
    self.leftarm:setOriginExact(12, 4)
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.chest = Sprite(self:getTexturePath("chest"), 20, 38)
    self.chest:setOriginExact(7, 15)
    self.chest.debug_select = false
    self:addChild(self.chest)

    self.lefthand = Sprite(self:getTexturePath("lefthand"), self.leftarm.x - 12, self.leftarm.y + 6) -- Toby what is this
    self.lefthand:setOriginExact(5, 27)
    self.lefthand.debug_select = false
    self:addChild(self.lefthand)

    self.shoulderflames = Sprite(self:getTexturePath("shoulderflames"), 20, 28)
    self.shoulderflames:setOriginExact(12, 5)
    self.shoulderflames.debug_select = false
    self.shoulderflames:play(1/8)
    self:addChild(self.shoulderflames)

    self.head = Sprite(self:getTexturePath("head"), 24, 25)
    self.head:setOriginExact(15, 25)
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
end

function LaninoActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function LaninoActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function LaninoActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function LaninoActorSprite:update()
    super.update(self)

    self.animsiner = self.animsiner + 1 * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        local boby = (math.abs((math.sin(self.animsiner / 6)) * -2)) * -1
        self.chest.y = self.y + (boby * 1.5) + 38
        self.shoulderflames.y = self.y + (boby * 1.5) + 28
        self.leftarm.y = self.y + (boby * 4) + 29
        self.lefthand.y = self.leftarm.y + 6
        self.head.y = self.y + (boby * 0.5) + 25
    end
end

return LaninoActorSprite