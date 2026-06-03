local actor, super = Class(Actor, "chara")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Chara"

    --Meant to be C-r-trash or crt trash but I suck at making names lol

    -- Width and height for this actor, used to determine its center
    self.width = 21
    self.height = 39

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {5, 29, 16, 7}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/npcs/chara"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "idle"

    -- Sound to play when this actor speaks (optional)
    self.voice = "chara"
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = nil

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
    }

    -- Table of sprite animations
    self.animations = {
        ["shrug"] = {"shrug", 0.5, false},
        ["bored"] = {"bored", 0, false},
        ["sit"] = {"sit", 0, false},
        ["smile"] = {"smile", 0, false},
        ["smilebad"] = {"smilebad", 0, false},
        ["wall"] = {"wall", 0, false},
}

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
    }
end

return actor