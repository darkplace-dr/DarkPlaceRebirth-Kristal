local actor, super = Class(Actor, "netskie")

function actor:init()
    super.init(self)

    self.name = "Netskie"

    self.width = 41
    self.height = 47

    self.hitbox = {3, 11, 41, 40}

    self.flip = "right"

    self.path = "battle/enemies/netskie"
    self.default = "idle"

    self.animations = {
        ["idle"] = { "idle", 2 / 30, true },
        ["hurt"] = { "hurt_w_tail", 1, true },
        ["spared"] = { "laugh", 4 / 30, true },
    }
end

return actor