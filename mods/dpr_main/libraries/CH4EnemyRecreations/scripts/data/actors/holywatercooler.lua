local actor, super = Class(Actor, "holywatercooler")

function actor:init()
    super.init(self)

    self.name = "HolywaterCooler"

    self.width = 27
    self.height = 43

    self.hitbox = { 7, 23, 24, 20 }

    self.color = { 1, 0, 0 }

    self.flip = nil

    self.path = "battle/enemies/holywatercooler"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = { "idle", 1, true },
        ["spared"] = { "spared", 1, true }
    }
end

return actor