---@class Actor.kris : Actor
local actor, super = Class("hero_lw", true)

function actor:init()
    super.init(self)
	
	self.evening_shadow_sprites = {
        ["walk/down"] = "walk_shadow/down",
        ["walk/up"] = "walk_shadow/up",
        ["walk/left"] = "walk_shadow/left",
        ["walk/right"] = "walk_shadow/right",
    }
	
    self.evening_shadow_floor_sprites = {
        ["walk/down"] = "walk_shadow_floor/down",
        ["walk/up"] = "walk_shadow_floor/up",
        ["walk/left"] = "walk_shadow_floor/left",
        ["walk/right"] = "walk_shadow_floor/right",
    }
	
    TableUtils.merge(self.offsets, {
        ["walk_shadow/down"] = {-27, 0},
        ["walk_shadow/up"] = {-27, 0},
        ["walk_shadow/left"] = {-29, 0},
        ["walk_shadow/right"] = {-29, 0},
        ["walk_shadow_floor/down"] = {-27, 0},
        ["walk_shadow_floor/up"] = {-27, 0},
        ["walk_shadow_floor/left"] = {-29, 0},
        ["walk_shadow_floor/right"] = {-29, 0},
    })
end

return actor