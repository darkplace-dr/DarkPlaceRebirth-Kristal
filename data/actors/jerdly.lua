---@class Actor.jerdly : Actor
local actor, super = Class("berdly", "jerdly")

function actor:init()
    super.init(self)
    
end
local function h(hex)
    return {tonumber(string.sub(hex, 2, 3), 16)/255, tonumber(string.sub(hex, 4, 5), 16)/255, tonumber(string.sub(hex, 6, 7), 16)/255, value or 1}
end
function actor:onSpriteInit(sprite)
    sprite:addFX(PaletteFX({
        h '#46b3fb',
        h '#31b081',
        h '#79ff95',
    }, {
        h '#549d58',
        h '#319cb0',
        h '#79fcff',
    }))
end

return actor