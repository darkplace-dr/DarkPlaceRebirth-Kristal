local actor, super = Class(Actor, "shinobeetle")

function actor:init()
    super.init(self)

    self.name = "Shinobeetle"

    self.width = 45
    self.height = 64

    self.hitbox = {4, 16, 26, 19}

    self.flip = "right"

    self.path = "battle/enemies/shinobeetle"
    self.default = "base"

    self.animations = {
        ["hurt"] = {"hurt", 2 / 30, true}, -- probably correct speed?
        ["spared"] = {"spare", 1 / 6, true},
        ["transition"] = {"base", 1, true}
    }

    self.parts = {
        ["wings_l"] = {"parts/wings_l"},
        ["wings_r"] = {"parts/wings_r"},
        ["body"] = {"parts/body"},
        ["feet"] = {"parts/feet"},
        ["arms"] = {"parts/arms"},
    }
end

function actor:createSprite()
    return ShinobeetleActor(self)
end

return actor