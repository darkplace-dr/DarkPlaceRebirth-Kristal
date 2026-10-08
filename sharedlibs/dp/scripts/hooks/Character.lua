---@class Character : Character
local Character, super = HookSystem.hookScript(Character)

function Character:init(actor, x, y)
    super.init(self, actor, x, y)

    self.dancing = false
end

function Character:getDebugOptions(context)
    if (self.party or self.actor.id) == "noel" then
        context = Noel:getDebugOptions(context, self)
        return context
    end
    return super.getDebugOptions(self, context)
end

function Character:alert(duration, options)
    options = options or {}
    if self.actor:hasAnimatedAlertIcon() and not options["sprite"] then
        options["sprite"] = "effects/alert_yellow"
        local icon = super.alert(self, duration, options)
        icon:play(1 / 15, false)
        return icon
    else
        return super.alert(self, duration, options)
    end
end

function Character:getName()
    return self.actor:getName()
end

function Character:getFont()
    return self.actor:getFont()
end

function Character:update()
    if self:isDancing() and self:isMoving() then
        self:setDancing(false)
    end

    super.update(self)
end

-- Dancing stuff

function Character:isMoving()
    return self.x ~= self.last_x or self.y ~= self.last_y
end

function Character:isDancing()
    return self.dancing
end

function Character:setDancing(bool)
    self.dancing = bool
    if self.dancing then
        self:setAnimation("dance")
    else
        self:resetSprite()
    end
end

return Character