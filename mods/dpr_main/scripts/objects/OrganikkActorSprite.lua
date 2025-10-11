local OrganikkActorSprite, super = Class(ActorSprite)

function OrganikkActorSprite:init(actor)
    super.init(self, actor)

    self.body = Sprite(self:getTexturePath("body"), 0, 0)
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"), 0, 0)
    self.head.debug_select = false
    --self.head:play(1/6) -- uhh idk
    self:addChild(self.head)
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