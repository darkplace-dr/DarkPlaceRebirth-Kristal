---@diagnostic disable: undefined-field
local WicabelActorSprite, super = Class(ActorSprite)

function WicabelActorSprite:init(actor)
    super.init(self, actor)

    self.leftarm = Sprite(self:getTexturePath("leftarm"), 0, 0)
    self.leftarm:setOriginExact(0, 4)
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.rightarm = Sprite(self:getTexturePath("rightarm"), 0, 0)
    self.rightarm:setOriginExact(0, 4)
    self.rightarm.debug_select = false
    self:addChild(self.rightarm)

    self.leg = Sprite(self:getTexturePath("leg"), 0, 0)
    self.leg:setOriginExact(0, 4)
    self.leg.debug_select = false
    self:addChild(self.leg)

    self.chest = Sprite(self:getTexturePath("chest"), 0, 0)
    self.chest:setOriginExact(0, 4)
    self.chest.debug_select = false
    self:addChild(self.chest)

    self.skirt = Sprite(self:getTexturePath("skirt"), 0, 0)
    self.skirt:setOriginExact(0, 4)
    self.skirt.debug_select = false
    self:addChild(self.skirt)

    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head:setOriginExact(0, 4)
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
end

function WicabelActorSprite:update()
    super.update(self)

    self.animsiner = self.animsiner + 1 * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.leg.x = (self.x - (math.sin(self.animsiner / 3)) * 2)
        self.skirt.x = (self.x - (math.sin(self.animsiner / 6)) * 2)
        self.rightarm.y = (self.y + (math.sin(self.animsiner / 6)) * 2)
        self.leftarm.y = (self.y - (math.sin(self.animsiner / 6)) * 2)
        self.head.x = (self.x + (math.sin(self.animsiner / 6)) * 2)
    end
end

function WicabelActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function WicabelActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function WicabelActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

return WicabelActorSprite