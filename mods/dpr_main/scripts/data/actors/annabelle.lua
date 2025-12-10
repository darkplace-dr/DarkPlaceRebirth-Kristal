local actor, super = Class(Actor, "annabelle")

function actor:init()
    super.init(self)

    self.name = "Annabelle"

    self.width = 32
    self.height = 45

    self.hitbox = {0, 0, 0, 0}

    --self.flip = "right"

    self.path = "battle/enemies/annabelle"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"idle", 0, true},
        ["hurt"] = {"hurt", 0, true},
        ["attack"] = {"attack", 0.05, false},
    }

    self.offsets = {
        ["idle"] = {0, 0},
        ["hurt"] = {0, 0},
        ["attack"] = {0, 0},
    }
end

return actor