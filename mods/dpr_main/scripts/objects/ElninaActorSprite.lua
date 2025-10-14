local ElninaActorSprite, super = Class(ActorSprite)

function ElninaActorSprite:init(actor)
    super.init(self, actor)

    self.waist = Sprite(self:getTexturePath("waist"), 21, 56)
    self.waist:setOriginExact(7, 29)
    self.waist.debug_select = false
    self:addChild(self.waist)

    self.hair = Sprite(self:getTexturePath("hair"), 21, 25)
    self.hair:setOriginExact(17, 4)
    self.hair.debug_select = false
    self:addChild(self.hair)

    self.leftarm = Sprite(self:getTexturePath("leftarm"), 18, 30)
    self.leftarm:setOriginExact(14, 3)
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.rightarm = Sprite(self:getTexturePath("rightarm"), 23, 29)
    self.rightarm:setOriginExact(0, 0)
    self.rightarm.debug_select = false
    self:addChild(self.rightarm)

    self.skirt = Sprite(self:getTexturePath("skirt"), 21, 35)
    self.skirt:setOriginExact(11, 3)
    self.skirt.debug_select = false
    self:addChild(self.skirt)

    self.lefthand = Sprite(self:getTexturePath("lefthand"), self.leftarm.x - 12, self.leftarm.y + 2) -- Toby what is this
    self.lefthand:setOriginExact(6, 27)
    self.lefthand.debug_select = false
    self:addChild(self.lefthand)

    self.head = Sprite(self:getTexturePath("head"), 22, 31)
    self.head:setOriginExact(16, 31)
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
end

function ElninaActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function ElninaActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function ElninaActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function ElninaActorSprite:update()
    super.update(self)

    self.animsiner = self.animsiner + 1 * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.hair.x = self.x + ((math.sin(self.animsiner / 12)) * 2) + 21
        local boby = (math.abs((math.sin(self.animsiner / 6)) * -2)) * -1
        self.hair.y = self.y + (boby * 1.5) + 25
        self.head.y = self.y + boby + 31
        self.leftarm.y = self.y + (boby * 4) + 30
        self.lefthand.y = self.leftarm.y + 2
        self.rightarm.y = self.y + (boby * 1.5) + 29
        self.skirt.y = self.y + boby + 35
    end
end

return ElninaActorSprite