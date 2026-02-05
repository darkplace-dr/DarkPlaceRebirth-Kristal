local actor, super = Class(Actor, "clover")

function actor:init()
    super.init(self)

    self.name = "Clover"

    self.width = 95
    self.height = 74

    self.hitbox = {20, 45, 50, 26}

    self.flip = nil
    self.miniface_offset = {0, -8}

    self.path = "world/npcs/clover"
    self.default = ""

    self.talk_sprites = {
        [""] = 0.2
    }
end

return actor