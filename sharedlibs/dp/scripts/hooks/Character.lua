---@class Character : Character
local Character, super = Utils.hookScript(Character)

function Character:getDebugOptions(context)
    if (self.party or self.actor.id) == "noel" then
        context = Noel:getDebugOptions(context, self)
        return context
    end
    return super.getDebugOptions(self, context)
end

function Character:getName()
    return self.actor:getName()
end

function Character:getFont()
    return self.actor:getFont()
end

return Character