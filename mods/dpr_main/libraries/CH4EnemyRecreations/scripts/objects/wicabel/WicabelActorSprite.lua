---@diagnostic disable: undefined-field
local WicabelActorSprite, super = Class(ActorSprite)

function WicabelActorSprite:init(actor)
    super.init(self, actor)

    self.leftarm = Sprite(self:getTexturePath("leftarm"))
    self.leftarm.visible = false
    self.leftarm.debug_select = false
    self:addChild(self.leftarm)

    self.rightarm = Sprite(self:getTexturePath("rightarm"))
    self.rightarm.visible = false
    self.rightarm.debug_select = false
    self:addChild(self.rightarm)

    self.leg = Sprite(self:getTexturePath("leg"))
    self.leg.visible = false
    self.leg.debug_select = false
    self:addChild(self.leg)

    self.chest = Sprite(self:getTexturePath("chest"))
    self.chest.visible = false
    self.chest.debug_select = false
    self:addChild(self.chest)

    self.skirt = Sprite(self:getTexturePath("skirt"))
    self.skirt.visible = false
    self.skirt.debug_select = false
    self:addChild(self.skirt)

    self.head = Sprite(self:getTexturePath("head"))
    self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
end

function WicabelActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

function WicabelActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function WicabelActorSprite:setAnimation(anim, callback, ignore_actor_callback)
    if anim == "idle" then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function WicabelActorSprite:update()
    super.update(self)

    self.animsiner = self.animsiner + DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.leg.x = (self.x - (math.sin(self.animsiner / 3)) * 2)
        self.skirt.x = (self.x - (math.sin(self.animsiner / 6)) * 2)
        self.rightarm.y = (self.y + (math.sin(self.animsiner / 6)) * 2)
        self.leftarm.y = (self.y - (math.sin(self.animsiner / 6)) * 2)
        self.head.x = (self.x + (math.sin(self.animsiner / 6)) * 2)
    end
end

return WicabelActorSprite