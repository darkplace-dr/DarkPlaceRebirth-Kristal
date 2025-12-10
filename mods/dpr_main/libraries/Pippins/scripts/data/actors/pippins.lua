local id = "pippins"
local actor, super = Class(Actor, id)

function actor:init()
    super.init(self)
    self.name = "Pippins"

    self.width = 39
    self.height = 45

	local offset = self.height * .75
	local xoffset = self.width * .25

    self.hitbox = {xoffset, offset, self.width - (xoffset * 2), self.height - offset}

    self.flip = nil

    self.path = "npcs/" .. id
    self.default = "idle"

    self.talk_sprites = {
        ["talk"] = 0.15,
    }

    self.animations = {
        ["idle"] = {"idle", 0.15, true},
        ["hurt"] = {"hurt", 0.05, true},
        ["spared"] = {"spare", 0.1, true},
        ["tired"] = {"tired", 0.25, true},
        ["prepare"] = {"prepare", 0.05, false, next="spin"},
        ["spin"] = {"spin", 0.05, true},
	}

    self.offsets = {
		["hurt"] = {8, 9},
	}
end

--function actor:createSprite()
    --return PippinsActor(self)
--end

return actor