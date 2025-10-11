local actor, super = Class(Actor, "tenna_wm")

function actor:init()
    super.init(self)

    self.name = "WM!Tenna"

    self.width = 66
    self.height = 77

    self.hitbox = {0, 55, 66, 22}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "world/npcs/tenna_wm"
    self.default = "pose"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.animations = {
        ["pose"]    = {"pose", 0.2, true},
    }

    self.offsets = {
        ["pose"]    = {0, 3},
    }
end

return actor