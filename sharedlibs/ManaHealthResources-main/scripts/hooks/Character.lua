--- All types of character in the overworld inherit from the `Character` class. \
--- This class is not to be confused with the psuedo-event [`NPC`](lua://NPC.init) that is used for characters placed in the overworld.
---@class Character : Object
local Character, super = HookSystem.hookScript(Character)

function Character:statusMessageMana(...)    --Offset for cleanliness
    local message = self:statusMessage(...)
    message.y = message.y - 24
    return message
end

return Character
