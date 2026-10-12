local actor, super = Class(Actor, "shi_farmer")

function actor:init()
    super.init(self)

    self.name = "Shi"

    self.width = 65
    self.height = 60

    self.hitbox = {18, 18, 57, 37}

    self.flip = "right"

    self.path = "battle/enemies/shi/farmer"
    self.default = "idle"

    self.animations = {
        ["idle"]   = {"idle",  1/5,  true},
        ["hurt"]   = {"hurt",  1,    true},
        ["spared"] = {"spare", 1/5,  true},

        ["sad"]    = {"sad",   1/5,  true},
        ["smear"]  = {"smear", 1/15, true},
    }

    self.offsets = {
        ["idle"]  = { 0, 0 },
        ["hurt"]  = { 0, 0 },
        ["spare"] = { 0, 0 },

        ["sad"]   = { 6, 8 },
        ["smear"] = { -2, 1 },
        ["taunt"] = { 8, 8 },
    }
end

return actor