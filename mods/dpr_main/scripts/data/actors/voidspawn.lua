local Voidspawn, super = Class(Actor, "voidspawn")

function Voidspawn:init()
    super.init(self)

    self.name = "Voidspawn"

    self.width = 62
    self.height = 62

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "battle/enemies/voidspawn"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle"]   = {"body"},
        ["squash"] = {"squash"},
    }

    self.offsets = {
        ["idle"]   = {0, 0},
        ["squash"] = {0, 0},
	}

    self.parts = {
        ["body"] = {"body"},
        ["squash"] = {"squash"},
        ["eye"] = {"eye"},
        ["iris"] = {"iris"},
        ["fountain_ball"] = {"fountain_ball"},
        ["fountain_ball_dissolve"] = {"fountain_ball_dissolve"}
    }

    self.disallow_replacement_texture = true
end

function Voidspawn:createSprite()
    return VoidspawnActor(self)
end

return Voidspawn