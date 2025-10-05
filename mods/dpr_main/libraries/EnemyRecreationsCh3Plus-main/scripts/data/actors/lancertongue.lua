local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.width = 36
    self.height = 35
	
    -- Path to this actor's sprites (defaults to "")
    self.path = "npcs/lancer_tongue"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "walk"

    -- Table of sprite animations
    self.animations = {
        -- Animations
        ["wave"] = {"wave", 0.05, false},
        ["up_flip"] = {"up_flip", 0.1, true},
        ["spin"] = {"spin", 0.1, true},
        ["tongue"] = {"tongue"},
        ["jump_prepare"] = {"jump_prepare"}
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["walk/down"] = {0, 0},
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0},
		
        ["wave"] = {-2, -3},
        ["tongue"] = {0, -3}
    }
end

return actor
