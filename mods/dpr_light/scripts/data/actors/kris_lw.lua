---@class Actor.kris : Actor
local actor, super = Class("kris_lw", true)

function actor:init()
    super.init(self)
	
	self.evening_shadow_sprites = {
        ["walk/down"] = "walk/down",
        ["walk/up"] = "walk/up",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }
	
    self.evening_shadow_floor_sprites = {
        ["walk/down"] = "walk/down",
        ["walk/up"] = "walk/up",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }
	
    TableUtils.merge(self.offsets, {
        ["walk_shadow/down"] = {0, 0},
        ["walk_shadow/up"] = {0, 0},
        ["walk_shadow/left"] = {0, 0},
        ["walk_shadow/right"] = {0, 0},
        ["walk_shadow_floor/down"] = {0, 0},
        ["walk_shadow_floor/up"] = {0, 0},
        ["walk_shadow_floor/left"] = {0, 0},
        ["walk_shadow_floor/right"] = {0, 0},
    })
end

return actor