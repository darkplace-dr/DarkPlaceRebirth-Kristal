local Guei, super = Class(Actor, "guei")

function Guei:init()
    super.init(self)

    self.name = "Guei"

    self.width = 71
    self.height = 64

    self.hitbox = {6, 46, self.width - 12, 18}

    self.flip = "right"

    self.path = "battle/enemies/guei"
    self.default = "idle_nowisp_1"

    self.animations = {
	    ["idle_nowisp"] = {"idle_nowisp", 0.2, true},
	    ["overworld"]   = {"overworld", 0.2, true},
        ["hurt"]        = {"hurt", 1, false},
        ["spared_overlay"]  = {"overworld_1", 1, false},
        ["transition"]  = {"idle_nowisp_1", 1, false}
    }

    self.parts = {
        ["arm_back"]    = {"arm_back"},
        ["body"]        = {"body"},
        ["head"]        = {"head"},
        ["arm_front"]   = {"arm_front"},
        ["wisp1"]       = {"wisp1"},
        ["wisp2"]       = {"wisp2"},
        ["chase"]       = {"chase"},
        ["idle_nowisp"] = {"idle_nowisp"}
    }
end

function Guei:createSprite()
    return GueiActorSprite(self)
end

return Guei