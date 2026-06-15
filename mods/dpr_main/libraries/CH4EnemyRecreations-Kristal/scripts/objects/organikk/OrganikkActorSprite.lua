---@diagnostic disable: undefined-field
local OrganikkActorSprite, super = Class(ActorSprite)

function OrganikkActorSprite:init(actor)
    super.init(self, actor)

    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head.debug_select = false
    self:addChild(self.head)

    self.siner_2 = 0
    self.siner = 0
end

function OrganikkActorSprite:update()
    super.update(self)

    self.siner_2 = self.siner_2 + 1/6 * DTMULT
    self.siner = self.siner + MathUtils.clamp(0.25 + (math.sin(self.siner_2 / 6) * 0.3), 0, 0.5) * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.head:setFrame(math.floor(self.siner))
    end
end

function OrganikkActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function OrganikkActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function OrganikkActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

return OrganikkActorSprite