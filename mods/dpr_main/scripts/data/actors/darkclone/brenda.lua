local actor, super = Class(Actor, "darkclone/brenda")

function actor:init()
    super.init(self)

    self.name = "Brenda?"

    self.width = 25
    self.height = 50

    self.hitbox = {3, 38, 19, 14}

    self.color = {0, 1, 1}

    self.path = "battle/enemies/darkclone/brenda"
    self.default = "walk"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"battle/idle", 0.2, true},
        ["aim"] = {"battle/aim", 0.08, false},
        ["point"] = {"battle/point", 1/15, false}
    }

    self.offsets = {
        ["battle/idle"] = {-5, -1},
        ["battle/aim"] = {-25, -1},
        ["battle/point"] = {-24, -1}
    }
end

return actor