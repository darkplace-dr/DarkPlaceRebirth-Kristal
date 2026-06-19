---@class Actor.kris : Actor
local actor, super = Class("pippins", true)

function actor:init()
    super.init(self)
    TableUtils.merge(self.animations, {
        ["angry"] = {"angry", 0, true},
    })
    TableUtils.merge(self.offsets, {
        ["angry"] = {0, 0},
    })
end

return actor