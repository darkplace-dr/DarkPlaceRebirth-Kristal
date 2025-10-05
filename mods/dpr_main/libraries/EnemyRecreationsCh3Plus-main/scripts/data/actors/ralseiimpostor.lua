local RalseiImpostor, super = Class(Actor)

function RalseiImpostor:init(style)
    super.init(self)

    self.name = "Ralsei"

    self.width = 23
    self.height = 43

    self.path = "npcs/ralsei_impostor"
    -- self.default = "walk"

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right"
    }

    self.offsets = {
        ["walk/down"] = {0, 0},
        ["walk/left"] = {0, 0},
        ["walk/right"] = {0, 0},
        ["walk/up"] = {0, 0}
    }
end

return RalseiImpostor