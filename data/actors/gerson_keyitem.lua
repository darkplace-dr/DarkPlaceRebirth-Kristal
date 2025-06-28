local actor, super = Class(Actor, "gerson_keyitem")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Old Man"

    -- Width and height for this actor, used to determine its center
    self.width = 37
    self.height = 40

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {7, 20, 22, 15}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}
	
    -- Path to this actor's sprites (defaults to "")
    self.path = "kristal/gerson"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "left_1"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Table of sprite animations
    self.animations = {
        -- Animations
        ["walk_left"] = {"left", 0.2, true},
        ["walk_right"] = {"right", 0.2, true},
		
        ["laugh_left"] = {"laugh_left", 0.2, true},
        ["laugh_right"] = {"laugh_right", 0.2, true},
		
        ["point_left"] = {"point_left", 0.2, true},
        ["point_right"] = {"point_right", 0.2, true},
		
        ["beard_thinking"] = {"beard_thinking", 0.2, true},
        ["shifty"] = {"shifty", 0.2, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        -- Movement offsets
        ["left"] = {0, 0},
        ["right"] = {0, 0},

        ["laugh_left"] = {0, -3},
        ["laugh_right"] = {0, -3},	
		
        ["point_left"] = {13, -1},
        ["point_right"] = {13, -1},
		
        ["look_up_right"] = {0, -1},
		
        ["beard_thinking"] = {0, 0},
        ["shifty"] = {0, 0},
    }
end

return actor
