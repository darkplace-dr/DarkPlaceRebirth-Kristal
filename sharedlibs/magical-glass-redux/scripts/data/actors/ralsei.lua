local actor, super = Class("ralsei", true)

function actor:init()
    super.init(self)

    -- Table of sprite animations
    TableUtils.merge(self.animations, {
        -- Battle animations
        ["battle/flee"]         = {"battle/hurt", 1/15},
    }, false)
end

return actor