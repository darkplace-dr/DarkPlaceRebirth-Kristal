local actor, super = Class(Actor, "ceroba_lw")

function actor:init()
    super.init(self)

    self.name = "Ceroba"

    self.width = 25
    self.height = 52

    self.hitbox = {3, 40, 18, 14}

    self.soul_offset = {12.5, 28}

    self.color = {237/255, 140/255, 36/255}

    self.path = "party/ceroba/light"
    self.default = "walk"

    self.voice = "ceroba"
    self.portrait_path = "face/ceroba"
    self.portrait_offset = {-19, -9}

    self.can_blush = false

    self.talk_sprites = {
        ["talk/down"] = 1/6,
        ["talk/right"] = 1/6,
        ["talk/left"] = 1/6,
        ["talk/up"] = 1/6
    }

    self.animations = {
        ["deflect"] = {"deflect", 1/15, false},
        ["guard"] = {"guard", 1/10, false},
        ["picture"] = {"picture", 1/10, false},
        ["picture_reverse"] = {"picture", 1/10, false, nil, frames={10,9,8,7,6,5,4,3,2,1}},
        ["staff"] = {"staff", 1/10, false},
        ["unguard"] = {"unguard", 1/10, false},
    }

    self.offsets = {
        -- Movement offsets
        ["talk/down"] = {0, 0},
        ["talk/right"] = {-2, -1},
        ["talk/left"] = {2, -1},
        ["talk/up"] = {0, 0},

        ["walk/down"] = {0, 0},
        ["walk/right"] = {-2, -2},
        ["walk/left"] = {1, -2},
        ["walk/up"] = {-1, -1},

        ["run/down"] = {-1, 2},
        ["run/right"] = {-14, -7},
        ["run/left"] = {-9, -7},
        ["run/up"] = {-1, 2},

        -- Cutscene offsets
        ["deflect"] = {-9, -7},
        ["fall"] = {-10, 1},
        ["fall_alt"] = {-10, 1},
        ["guard"] = {-17, -11},
        ["picture"] = {-17, -9},
        ["right_down"] = {-1, -2},
        ["right_down_more"] = {1, -2},
        ["shock"] = {-10, 1},
        ["shock_angry"] = {-10, 1},
        ["shock_closed"] = {-10, 1},
        ["staff"] = {-19, -1},
        ["the_roba"] = {0, 0},
        ["unguard"] = {-17, -11},
    }

    self.taunt_sprites = {"cool", "the_roba"}

    self.shiny_id = "ceroba"

    self.running_sprites = true

    self.directional_talking = true
end

function actor:onTextSound()
    Assets.stopAndPlaySound("voice/ceroba")
    return true
end

return actor