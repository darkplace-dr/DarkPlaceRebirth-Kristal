local BiblioxActorSprite, super = Class(ActorSprite)

function BiblioxActorSprite:init(actor)
    super.init(self, actor)

    self.body = Sprite(self:getTexturePath("base"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"), 2, 0)
    self.head.debug_select = false
    self.head:play(1/6)
    self:addChild(self.head)

    self.animsiner = 0
end

function BiblioxActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. '/' .. self.actor.parts[sprite_name][1]
end

function BiblioxActorSprite:set(anim, ...)
    self.actor:onSetAnimation(self, anim, ...)
end

function BiblioxActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function BiblioxActorSprite:update()
    super.update(self)

    self.animsiner = self.animsiner + 1 * DTMULT

    local anim = self.anim or "idle"
    if anim == "idle" then
        self.head.x = self.x + (math.sin(self.animsiner / 10)) * 2
    elseif anim == "beard_stroke" then -- yeah I tried
        self.head:setPosition(2, 0)
        self.head:setSprite(self:getTexturePath("head_beard_stroke"))
        --self.head:play(1/6, false)
    end
end

return BiblioxActorSprite