local BiblioxActorSprite, super = Class(ActorSprite)

function BiblioxActorSprite:init(actor)
    super.init(self, actor)

    self.body = Sprite(self:getTexturePath("base"))
    self.body.visible = false
    self.body.debug_select = false
    self:addChild(self.body)

    self.head = Sprite(self:getTexturePath("head"), 1, 0)
    self.head.visible = false
    self.head.debug_select = false
    self:addChild(self.head)

    self.animsiner = 0
    self.beardtimer = 0
end

function BiblioxActorSprite:getTexturePath(sprite_name)
    return self.actor:getSpritePath() .. "/" .. self.actor.parts[sprite_name][1]
end

function BiblioxActorSprite:setPartVisible(boolean)
    for _, child in ipairs(self.children) do
        child.visible = boolean
    end
end

function BiblioxActorSprite:setAnimation(anim, callback, ignore_actor_callback)
    if anim == "idle" or anim == "beard_stroke" then
        self:setSprite() -- no sprite
        self:setPartVisible(true)
        if anim == "idle" then
            self.head:setSprite(self:getTexturePath("head"))
        end
        if anim == "beard_stroke" then
            self.head:setPosition(1, 0)
            self.head:setSprite(self:getTexturePath("head_beard_stroke"))
        else
            self.beardtimer = 0
        end
    else
        self:setPartVisible(false)
    end
    return super.setAnimation(self, anim, callback, ignore_actor_callback)
end

function BiblioxActorSprite:update()
    super.update(self)

    if self.visible then
        self.head.alpha = self.alpha
        self.body.alpha = self.alpha

        self.animsiner = self.animsiner + DTMULT

        local anim = self.anim or "idle"
        if anim == "idle" then
            self.head.x = self.x + 1 + (math.sin(self.animsiner / 10)) * 2
            self.head:setFrame(1 + math.floor(self.animsiner / 5))
        elseif anim == "beard_stroke" then
            if self.beardtimer < 32 then
                self.beardtimer = self.beardtimer + DTMULT
            end
            self.head:setFrame(1 + math.floor(self.beardtimer / 3))
        end
    end
end

return BiblioxActorSprite