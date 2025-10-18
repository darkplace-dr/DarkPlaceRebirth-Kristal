local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Guei"

    self.width = 71
    self.height = 64

    self.hitbox = {6, 46, 59, 18}

    self.flip = nil

    self.path = "battle/enemies/guei"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle_nowisp"] = {"idle_nowisp", 0.2, true},
	    ["overworld"]   = {"overworld", 0.2, true},
        ["hurt"]   = {"hurt", 1, true}
    }

    self.offsets = {}

    self.parts = {
        ["arm_back"] = {"arm_back"},
        ["body"] = {"body"},
        ["head"] = {"head"},
        ["arm_front"] = {"arm_front"},
        ["wisp1"] = {"wisp1"},
        ["wisp2"] = {"wisp2"},
        ["chase"] = {"chase"},
        ["idle_nowisp"] = {"idle_nowisp"}
    }
end

function actor:createSprite()
    return GueiActorSprite(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end

    if anim == "idle_nowisp" or anim == "overworld" or anim == "hurt" then
        sprite:setPartVisible(false)
    end
end

return actor