local actor, super = Class(Actor, "asgore")

function actor:init()
    super.init(self)

    self.name = "Asgore"

    self.width = 47
    self.height = 63

    self.flip = nil

    self.path = "world/npcs/asgore"
    self.default = "walk"

    self.voice = "asgore"
    self.portrait_path = "face/asgore"
    self.portrait_offset = {-15, 0}

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {}

    self.offsets = {}
end

return actor