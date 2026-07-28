local actor, super = Class(Actor, "chloropurr")

function actor:init()
    super.init(self)

    self.name = "Chloropurr"

    self.width = 65
    self.height = 50

    self.hitbox = {0, 25, 19, 14}

    self.color = {1, 0, 0}

    self.flip = "right"

    self.path = "battle/enemies/chloropurr"
    self.default = "idle"

    self.voice = nil
    self.portrait_path = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"idle", 0.1, true},
        ["walk"] = {"walk", 0.13, true},
        ["creepwalk"] = {"creepywalk", 0.5, true},
        ["angry"] = {"cat_angry", 0.1, true},
        ["spared"] = {"spare", 1/4, true},
        ["hit"] = {"hit", 1/12, true},
        ["hitslow"] = {"hit", 1/6, true},
        ["hitslower"] = {"hitslow", 1/6, true},
        ["hurt"] = {"hurt", 0, false},
    }

    self.offsets = {
        ["idle"] = {0, 0},
        ["hurt"] = {0, -17},
        ["hit"] = {-18, 0},
        ["hitslow"] = {-18, 0},
        ["hitslower"] = {-18, 0},
    }
end

return actor