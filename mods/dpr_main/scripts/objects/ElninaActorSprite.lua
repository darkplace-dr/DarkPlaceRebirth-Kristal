local ElninaActorSprite, super = Class(ActorSprite)

function ElninaActorSprite:init(actor)
    super.init(self, actor)

    self.waist = Sprite(self:getTexturePath("waist"))
    self.waist:setOriginExact(7, 29)
    self.waist.debug_select = false
    self:addChild(self.waist)

    self.hair = Sprite(self:getTexturePath("hair"))
    self.hair:setOriginExact(17, 4)
    self.hair.debug_select = false
    self:addChild(self.hair)

    self.leftarm = Sprite(self:getTexturePath("leftarm"))
    self.leftarm:setOriginExact(14, 3)
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.rightarm = Sprite(self:getTexturePath("rightarm"))
    self.rightarm:setOriginExact(0, 0)
    self.rightarm.debug_select = false
    self:addChild(self.rightarm)

    self.skirt = Sprite(self:getTexturePath("skirt"))
    self.skirt:setOriginExact(11, 3)
    self.skirt.debug_select = false
    self:addChild(self.skirt)

    self.lefthand = Sprite(self:getTexturePath("lefthand"))
    self.lefthand:setOriginExact(6, 27)
    self.lefthand.debug_select = false
    self:addChild(self.lefthand)

    self.head = Sprite(self:getTexturePath("head"))
    self.head:setOriginExact(16, 31)
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
    self.pose = 0
    self.laughtimer = 0
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

    self.hair.x = 42
    self.hair.y = 50
    self.waist.x = 42/2
    self.waist.y = 112/2
    self.rightarm.x = 46/2
    self.rightarm.y = 58/2
    self.head.x = 44/2
    self.head.y = 62/2
    self.leftarm.x = 36/2
    self.leftarm.y = 60
    self.skirt.x = 42/2
    self.skirt.y = 70/2
	
    self.animsiner = self.animsiner + (1 * DTMULT)
    self.laughtimer = self.laughtimer - (1 * DTMULT)

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.hair.x = (self.hair.x + (math.sin(self.animsiner / 12) * 2)) / 2

        local boby = math.abs(math.sin(self.animsiner / 6) * -2) * -1

        self.hair.y = (self.hair.y + (boby * 1.5)) / 2
        self.head.y = (self.head.y + boby)
        self.leftarm.y = (self.leftarm.y + (boby * 4)) / 2

        if self.pose == 3 then
            self.rightarm.y = self.rightarm.y + boby
        else
            self.rightarm.y = self.rightarm.y + (boby * 1.5)
        end

        self.skirt.y = (self.skirt.y + boby)
    end

    self.lefthand.x = self.leftarm.x - (24/2)
    self.lefthand.y = self.leftarm.y + (4/2)
end

return ElninaActorSprite