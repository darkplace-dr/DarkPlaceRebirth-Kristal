local actor, super = Class(Actor, "dessimation")

function actor:init()
    super.init(self)

    self.name = "Dess"

    self.width = 23
    self.height = 46

    self.hitbox = {2, 33, 18, 14}

    self.color = {1, 0, 0}

    self.path = "party/dess/dessimation"
    self.default = "idle"

    self.voice = "dess"
    self.portrait_path = "face/dess"
    self.portrait_offset = {-12, -10}

    self.can_blush = false

    self.animations = {
        ["idle"]          = {"idle", 0.2, true},
        ["hurt"]          = {"hurt", 1/15, false},
        ["attack"]        = {"attack", 1/23, false},
        ["spell"]         = {"spell", 1/10, false, next="spellsuper"},
        ["spellsuper"]    = {"spellsuper", 2/30, false, next="spellsuperend"},
		["spellsuperend"] = {"spellsuperend", 2/30, true},
    }

    self.offsets = {
        ["idle"] = {-3, 0},
        ["hurt"] = {-3, 0},
        ["hurt_defeat"] = {-3, 0},
        ["defeat"] = {-3, 0},
        ["defeat_smirk"] = {-3, 0},
        ["attack"] = {-14, 0},
        ["attackready"] = {-14, 0},
        ["spell"] = {-3, 0},
        ["spellsuper"] = {0, 0},
        ["spellsuperend"] = {0, 0},
        ["point"] = {-3, 0},
    }
end

return actor