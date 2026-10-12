local actor, super = Class(Actor, "terakota")

function actor:init()
    super.init(self)

    self.name = "Terakota"

    self.width = 78
    self.height = 76

    self.hitbox = {4, 16, 26, 19}

    self.flip = "right"

    self.path = "battle/enemies/terakota"
    self.default = "attack"

    self.animations = {
        ["hurt"] = {"hurt", 1, true},
        ["spared"] = {"bloomed_full", 1, true},
        ["transition"] = {"attack", 1, true}
    }

    self.parts = {
        ["backpouldron"] = {"parts/backpouldron"},
        ["feet"] = {"parts/feet"},
        ["body"] = {"parts/body"},
        ["hands"] = {"parts/hands_shovel_centered"},
        ["head_bloomed"] = {"parts/head_bloomed"},
        ["head"] = {"parts/head_no_plant"},
        ["head_plant"] = {"parts/head_plant"},
        ["front_shoulder"] = {"parts/hands_front_shoulder"},
    }
end

function actor:createSprite()
    return TerakotaActor(self)
end

return actor