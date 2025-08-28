local actor, super = Class(Actor, "darkclone/jamm")

function actor:init()
    super.init(self)

    self.name = "Jamm?"

    self.width = 25
    self.height = 50

    self.hitbox = {3, 38, 19, 14}

    self.color = {0, 1, 1}

    self.path = "battle/enemies/darkclone/jamm"
    self.default = "walk"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"battle/idle", 0.2, true}
    }

    self.offsets = {
        ["battle/idle"] = {-5, -1},
    }
end

return actor
