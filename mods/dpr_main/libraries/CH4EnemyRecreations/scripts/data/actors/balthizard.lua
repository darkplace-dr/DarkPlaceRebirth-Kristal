local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Balthizard"

    self.width = 67
    self.height = 44

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/balthizard"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["hurt"]   = {"hurt", 1, true},
        ["spared_overlay"] = {"spared", 1, true},
        ["transition"]   = {nil, 1, false},
        ["transition_end"]   = {nil, 1, false},
    }

    self.offsets = {}

    self.parts = {
        ["tail"] = {"tail"},
        ["leg1"] = {"leg1"},
        ["leg1_transition"] = {"leg1_transition"},
        ["body"] = {"body"},
        ["body_transition"] = {"body_transition"},
        ["leg2"] = {"leg2"},
        ["leg2_transition"] = {"leg2_transition"},
        ["leg3"] = {"leg3"},
        ["leg3_transition"] = {"leg3_transition"},
        ["neckpiece"] = {"neckpiece"},
        ["head"] = {"head"},
        ["head_spared"] = {"head_spared"},
        ["head_fire"] = {"head_fire"}
    }
end

function actor:createSprite()
    return BalthizardActorSprite(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == "table" then anim = anim[1] end

    if anim == "hurt" or anim == "spared" then
        sprite:setPartVisible(false)
    end
end

return actor