local LaninoActorSprite, super = Class(ActorSprite)

function LaninoActorSprite:init(actor)
    super.init(self, actor)

    self:setScale(1)

    self.legs = Sprite(self:getTexturePath("legs"))
    self.legs:setOriginExact(7, 22)
    self.legs.debug_select = false
    self:addChild(self.legs)

    self.leftarm = Sprite(self:getTexturePath("leftarm"))
    self.leftarm:setOriginExact(12, 4)
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.chest = Sprite(self:getTexturePath("chest"))
    self.chest:setOriginExact(7, 15)
    self.chest.debug_select = false
    self:addChild(self.chest)

    self.lefthand = Sprite(self:getTexturePath("lefthand"))
    self.lefthand:setOriginExact(5, 27)
    self.lefthand.debug_select = false
    self:addChild(self.lefthand)

    self.shoulders = Sprite(self:getTexturePath("shoulderflames"))
    self.shoulders:setOriginExact(12, 5)
    self.shoulders.debug_select = false
    self:addChild(self.shoulders)

    self.head = Sprite(self:getTexturePath("head"))
    self.head:setOriginExact(15, 25)
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
    self.pose = 0
    self.laughtimer = 0
    self.shoulderflameindex = 1
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

    self.shoulders.x = 40/2
    self.shoulders.y = 56
    self.legs.x = 42/2
    self.legs.y = 122/2
    self.chest.x = 40/2
    self.chest.y = 76
    self.head.x = 48/2
    self.head.y = 50
    self.leftarm.x = 34/2
    self.leftarm.y = 58/2
    self.shoulderflameindex = self.shoulderflameindex + 0.125 * DTMULT
    self.shoulders:setFrame(math.floor(self.shoulderflameindex))

    self.animsiner = self.animsiner + (1 * DTMULT)
    self.laughtimer = self.laughtimer - (1 * DTMULT)

    local anim = self.anim or "idle"
    if anim == "idle" then
        local boby = math.abs(math.sin(self.animsiner / 6) * -2) * -1

        if self.pose == 3 then
            self.chest.y = (self.chest.y + (boby * 0.5)) / 2
            self.shoulders.y = (self.shoulders.y + (boby * 0.5)) / 2
        else
            self.chest.y = (self.chest.y + (boby * 1.5)) / 2
            self.shoulders.y = (self.shoulders.y + (boby * 1.5)) / 2
        end

        self.leftarm.y = self.leftarm.y + ((-7 + (boby * 4)) / 2)
        self.head.y = (self.head.y + (boby * 0.5)) / 2
    end

    self.lefthand.x = self.leftarm.x - (24/2)
    self.lefthand.y = self.leftarm.y + (12/2)
end

return LaninoActorSprite