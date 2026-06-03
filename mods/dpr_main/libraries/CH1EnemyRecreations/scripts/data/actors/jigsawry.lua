local actor, super = Class(Actor, "jigsawry")

function actor:init()
    super.init(self)

    self.name = "Jigsawry"

    self.width = 38
    self.height = 36

	local offset = self.height * .75
	local xoffset = self.width * .25
    self.hitbox = {xoffset, offset, self.width - (xoffset * 2), self.height - offset}

    self.flip = "right"

    self.path = "battle/enemies/jigsawry"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"idle", 1/6, true},
        ["spared"] = {"spared", 1/6, true},
        ["hurt"] = {"hurt", 0, false},
    }
	
    self.talk_sprites = {
        [""] = 0.15
    }

    self.offsets = {}
end

return actor