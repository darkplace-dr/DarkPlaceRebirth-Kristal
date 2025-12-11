local actor, super = Class(Actor, "ceroba_dw")

function actor:init()
    super.init(self)

    self.name = "Ceroba"

    self.width = 25
    self.height = 52

    self.hitbox = {3, 40, 19, 14}

    self.soul_offset = {12.5, 28}

    self.color = {253/255, 0, 85/255}

    self.path = "party/ceroba/dark"
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
        ["slide"]               = {"slide", 4/30, true},

        ["battle/idle"]         = {"battle/idle", 0.2, true},

        ["battle/attack"]       = {"battle/attack", 1/15, false},
        ["battle/act"]          = {"battle/act", 1/15, false},
        ["battle/spell"]        = {"battle/spell", 1/15, false, next="battle/idle"},
        ["battle/item"]         = {"battle/item", 1/12, false, next="battle/idle"},
        ["battle/spare"]        = {"battle/act", 1/15, false, next="battle/idle"},

        ["battle/attack_ready"] = {"battle/attackready", 1/8, false},
        ["battle/act_ready"]    = {"battle/actready", 1/15, false},
        ["battle/spell_ready"]  = {"battle/spellready", 0.2, true},
        ["battle/item_ready"]   = {"battle/itemready", 0.2, true},
        ["battle/spare_ready"]  = {"battle/actready", 1/15, false},
        ["battle/defend_ready"] = {"battle/defend", 1/15, false},

        ["battle/attack_end"]   = {"battle/attackend", 1/15, false, next="battle/idle"},
        ["battle/act_end"]      = {"battle/actend", 1/15, false, next="battle/idle"},

        ["battle/hurt"]         = {"battle/hurt", 1/15, false, temp=true, duration=0.5},
        ["battle/defeat"]       = {"battle/defeat", 1/15, false},
        ["battle/swooned"]      = {"battle/defeat", 1/15, false},

        ["battle/transition"]   = {"battle/intro", 1/15, false},
        ["battle/victory"]      = {"battle/victory", 1/10, false},

        ["guard"]               = {"guard", 1/10, false},

        ["dance"]               = {"dance", 1/10, true},
    }

    self.offsets = {
        -- Movement offsets
        ["talk/down"] = {-1, -1},
        ["talk/right"] = {-2, -3},
        ["talk/left"] = {2, -3},
        ["talk/up"] = {-1, -1},

        ["walk/down"] = {-1, -1},
        ["walk/right"] = {-2, -3},
        ["walk/left"] = {2, -3},
        ["walk/up"] = {-1, -1},

        ["run/down"] = {-1, 2},
        ["run/right"] = {-14, -7},
        ["run/left"] = {-9, -7},
        ["run/up"] = {-1, 2},

        ["slide"] = {-1, 1},

        -- Battle offsets
        ["battle/idle"] = {-8, 0},

        ["battle/attack"] = {-6, -4},
        ["battle/attackready"] = {-6, -7},
        ["battle/attackend"] = {-6, -2},
        ["battle/act"] = {-3, -4},
        ["battle/actend"] = {-9, -1},
        ["battle/actready"] = {-3, -4},
        ["battle/spell"] = {-3, -7},
        ["battle/spellready"] = {-3, -7},
        ["battle/item"] = {-14, 0},
        ["battle/itemready"] = {-14, 0},
        ["battle/defend"] = {2, 4},

        ["battle/defeat"] = {-4, 6},
        ["battle/hurt"] = {-8, 0},

        ["battle/intro"] = {-10, 0},
        ["battle/victory"] = {-8, 0},

        -- Cutscene offsets
        ["ball"] = {-3, 0},
        ["dance"] = {-5, -1},
        ["fall"] = {0, 0},
        ["guard"] = {-17, -11},
        ["right_down"] = {-1, -2},
        ["right_down_more"] = {1, -2},
        ["the_roba"] = {0, 0},
    }

    self.taunt_sprites = {"cool", "the_roba"}

    self.shiny_id = "ceroba"

    self.menu_anim = "cool"
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