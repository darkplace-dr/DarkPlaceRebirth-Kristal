local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Organikk"

    self.width = 57
    self.height = 73

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/organikk"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["hurt"]   = {"hurt", 1, true},
        ["spared"] = {"spare", 1, true},
    }

    self.offsets = {}

    self.parts = {
        ["body"] = {"body"},
        ["head"] = {"head"}
    }
end

function actor:createSprite()
    return OrganikkActorSprite(self)
end

return actor