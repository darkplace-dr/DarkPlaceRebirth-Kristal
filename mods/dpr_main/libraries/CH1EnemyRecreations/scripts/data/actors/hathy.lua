local actor, super = Class(Actor, "hathy")

function actor:init()
    super.init(self)

    self.name = "Hathy"

    self.width = 53
    self.height = 48

	local offset = self.height * .75
	local xoffset = self.width * .25
    self.hitbox = {xoffset, offset, self.width - (xoffset * 2), self.height - offset}

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "battle/enemies/hathy"
    self.default = "idle"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"idle", 1/6, true},
        ["hurt"] = {"hurt", 0, false},
        ["spared"] = {"spared", 0, false},
    }

    self.offsets = {
        ["hurt"] = {-1, -24}
    }
end

return actor