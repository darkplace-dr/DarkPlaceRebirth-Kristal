local actor, super = Class(Actor, "zapper_b")

function actor:init()
    super.init(self)

    self.name = "Zapper"

    self.width = 49
    self.height = 98

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/zapper"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle"]         = {"jump", 1/6, true},
        ["hurt"]         = {"hurt", 1/5, true},
        ["spared"]       = {"spare", 1/5, true},

        ["cannon_ready"] = {"cannon", 1/15, false, nil, frames={1,2,3,4,5}},
        ["cannon_fire"]  = {"cannon", 1/15, false, nil, frames={6,7,8,9,10,11,12}},
        ["cannon_stop"]  = {"cannon", 1/15, false, next="idle", frames={5,4,3,2,1}},
    }

    self.offsets = {
        ["jump"]   = {0, 0},
        ["hurt"]   = {0, 33},
        ["spare"]  = {-5, 20},
        ["cannon"] = {-9, 16},
	}
end

return actor