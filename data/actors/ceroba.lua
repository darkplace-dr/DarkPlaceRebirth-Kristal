local actor, super = Class(Actor, "ceroba")

function actor:init()
    super.init(self)

    self.name = "Ceroba"

    self.width = 25
    self.height = 52

    self.hitbox = {3, 40, 19, 14}

    self.soul_offset = {12.5, 28}

    self.color = {237/255, 140/255, 36/255}

    self.path = "party/ceroba/light"
    self.default = "walk"

    self.voice = "ceroba"
    self.portrait_path = "face/ceroba"
    self.portrait_offset = {-19, -9}

    self.can_blush = false

    self.talk_sprites = {
        ["talk/down"] = 0.2,
        ["talk/right"] = 0.2,
        ["talk/left"] = 0.2,
        ["talk/up"] = 0.2
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
        ["fall"] = {0, 0},
        ["guard"] = {-17, -11},
        ["picture"] = {-17, -9},
        ["right_down"] = {-1, -2},
        ["right_down_more"] = {1, -2},
        ["staff"] = {-19, -1},
        ["the_roba"] = {0, 0},
        ["unguard"] = {-17, -11},
    }

    self.taunt_sprites = {"cool", "the_roba"}

    self.shiny_id = "ceroba"
end

function actor:onWorldDraw(chara)
    if Kristal.Config["runAnimations"] then
        local player = Game.world.player

        local moving = false
        local c, b = chara.x, chara.y
        if c ~= self.l or b ~= self.ll then
            moving = true
        end

        if Game.world.cutscene and not self.cut then
            self.default = "walk"
            chara:resetSprite()
            self.cut = true
        elseif not Game.world.cutscene then
            if self.cut then self.cut = nil end
            if player.run_timer > 0 and self.default == "walk" and not Game.world.cutscene and moving then
                self.default = "run"
                chara:resetSprite()
            elseif self.default == "run" and (player.run_timer == 0 or moving == false) then
                self.default = "walk"
                chara:resetSprite()
            end
        end
        self.l = chara.x
        self.ll = chara.y
    end
end

return actor