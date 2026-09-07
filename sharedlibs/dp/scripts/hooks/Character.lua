---@class Character : Character
local Character, super = HookSystem.hookScript(Character)

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

return Character