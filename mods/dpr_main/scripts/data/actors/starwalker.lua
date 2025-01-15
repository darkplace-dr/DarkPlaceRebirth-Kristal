local actor, super = Class(Actor, "starwalker")

function actor:init()
    super.init(self)

    self.name = "Starwalker"

    self.width = 37
    self.height = 36

    self.hitbox = {2, 26, 27, 10}

    self.color = {1, 1, 0}

    self.flip = nil

    self.path = "battle/enemies/starwalker"
    self.default = "starwalker"

    self.animations = {
        ["wings"] = {"starwalker_wings", 0.25, true},
        ["hurt"] = {"starwalker_shoot_1", 0.5, true},
        ["shoot"] = {"starwalker_wings", 0.25, true, next="wings", frames={5,4,3,2}},
        ["reaching"] = {"starwalker_reaching", 0.25, true},
        ["acting"] = {"starwalker_acting", 2/30, false},
        ["pointing"] = {"starwalker_pointing", 0.25, false},
        ["pointing_up"] = {"starwalker_pointing_up", 1/30, false},
        ["pointing_down"] = {"starwalker_pointing_up", 1/30, false, next="wings", frames={5,4,3,2,1}}
    }

    self.offsets = {
        ["starwalker"] = {0, 0},
        ["starwalker_wings"] = {-5, -4},
        ["starwalker_shoot_1"] = {0, 0},
        ["starwalker_shoot_2"] = {-5, 0},
        ["starwalker_reaching"] = {-8, -1},
        ["starwalker_acting"] = {-24, -1},
        ["starwalker_pointing"] = {-8, -1},
        ["starwalker_pointing_up"] = {-6, -11}
    }
end

return actor
