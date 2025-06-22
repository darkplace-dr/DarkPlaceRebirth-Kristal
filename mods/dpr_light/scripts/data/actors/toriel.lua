local actor, super = Class(Actor, "toriel")

function actor:init()
    super.init(self)

    self.name = "Toriel"

    self.width = 25
    self.height = 53

    self.flip = nil

    self.path = "world/npcs/toriel"
    self.default = "talk"

    self.voice = "toriel"
    self.portrait_path = "face/toriel"
    self.portrait_offset = {-9, 2}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
		    ["laugh"] = {"laugh", 0.2, true},
    }

    self.offsets = {
        ["laugh"] = {0, 0},
    }
end

return actor