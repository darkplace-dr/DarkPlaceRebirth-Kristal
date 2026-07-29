local actor, super = Class(Actor, "room3_friend")

function actor:init()
    super.init(self)

    self.name = "Friend"

    self.width = 246
    self.height = 159

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "battle/enemies/room3_friend"
    self.default = "idle"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["chaser"] = {"chaser", 1/4, true},
        ["idle"] = {"idle", 1/3, true},
        ["hurt"] = {"hurt", 0, false},
    }

    self.offsets = {
        ["chaser"] = {2, 0},
        ["idle"] = {-10, 50},
        ["hurt"] = {-10, 50},
    }
end
    function actor:onSpriteInit(sprite)
    sprite:shiftOriginExact(-10, 80)
end

return actor