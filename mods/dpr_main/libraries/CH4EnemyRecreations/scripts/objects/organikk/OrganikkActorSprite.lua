---@diagnostic disable: undefined-field
local OrganikkActorSprite, super = Class(ActorSprite)

function OrganikkActorSprite:init(actor)
    super.init(self, actor)

    self.body = Sprite(self:getTexturePath("body"))
    self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"))
    self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

    self.siner2 = 0
    self.siner = 0
end

function OrganikkActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

function OrganikkActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function OrganikkActorSprite:setAnimation(anim, callback, ignore_actor_callback)
    if anim == "idle" then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function OrganikkActorSprite:update()
    super.update(self)

    self.siner2 = self.siner2 + 1 / 6 * DTMULT
    self.siner = self.siner + MathUtils.clamp(0.25 + (math.sin(self.siner2 / 6) * 0.3), 0, 0.5) * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.head:setFrame(1 + math.floor(self.siner))
    end
end

return OrganikkActorSprite