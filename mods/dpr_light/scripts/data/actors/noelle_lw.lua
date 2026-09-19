---@class Actor.noelle : Actor
local actor, super = HookSystem.hookScript("noelle_lw")

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
        ["walk_shadow/down"] = {-34, 0},
        ["walk_shadow/up"] = {-34, 0},
        ["walk_shadow/left"] = {-40, 0},
        ["walk_shadow/right"] = {-35, 0},
        ["walk_shadow_floor/down"] = {-34, 0},
        ["walk_shadow_floor/up"] = {-34, 0},
        ["walk_shadow_floor/left"] = {-42, 0},
        ["walk_shadow_floor/right"] = {-36, 0},
    })
end

return actor