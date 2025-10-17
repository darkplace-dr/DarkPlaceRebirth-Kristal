local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Elnina"

    self.width = 47
    self.height = 62

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/elnina"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["transition"] = {"idle", 1, true},
        ["hurt"] = {"hurt", 1, true},
    }

    self.offsets = {
        ["hurt"] = {0, -3.5},
    }

    self.parts = {
        ["waist"] = {"torso"},
        ["head"] = {"head_smiling"},
        ["hair"] = {"hairtufts"},
        ["rightarm"] = {"rightarm"},
        ["leftarm"] = {"leftarm"},
        ["skirt"] = {"skirt"},
        ["lefthand"] = {"lefthand"},
    }
end

function actor:createSprite()
    return ElninaActorSprite(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end

    if anim == "hurt" or anim == "idle" then
        sprite:setPartVisible(false)
    end
end

return actor