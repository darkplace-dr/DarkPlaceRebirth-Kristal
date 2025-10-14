local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Lanino"

    self.width = 38
    self.height = 64

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/lanino"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["transition"] = {"idle", 1, true},
        ["hurt"] = {"hurt", 1, true},
    }

    self.offsets = {}

    self.parts = {
        ["legs"] = {"legs"},
        ["chest"] = {"chest"},
        ["leftarm"] = {"leftarm"},
        ["lefthand"] = {"lefthand"},
        ["shoulderflames"] = {"shoulderflames"},
        ["head"] = {"head_serious"},
    }
end

function actor:createSprite()
    return LaninoActorSprite(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end

    if anim == "hurt" or anim == "idle" then
        sprite:setPartVisible(false)
    end
end

return actor