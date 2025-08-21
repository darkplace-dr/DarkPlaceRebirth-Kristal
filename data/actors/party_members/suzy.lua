local actor, super = Class(Actor, "suzy")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Suzy"

    self.width = 33
    self.height = 42

    self.hitbox = {5, 24, 19, 14}

    self.soul_offset = {15, 25}

    self.color = {1, 1, 1}

    self.path = "party/suzy/dark"

    self.default = "walk"

    self.voice = "suzy"

    self.portrait_path = "face/suzy"

    self.portrait_offset = nil

    self.can_blush = false

    self.animations = {

    }

    self.mirror_sprites = {
        ["walk/down"] = "walk/up",
        ["walk/up"] = "walk/down",
        ["walk/left"] = "walk/left",
        ["walk/right"] = "walk/right",
    }

    self.offsets = {
    }
end

function actor:onTextSound(node)
    if self.snd then
        self.snd:stop()
        self.snd = nil
    end
    local meth, w = math.random(1, 3), 1
    if meth > 2 then meth = 2 end 
    self.snd = Assets.playSound("voice/suzy_".. meth, 1, w)
    return true
end

return actor