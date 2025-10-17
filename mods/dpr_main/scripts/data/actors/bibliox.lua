local actor, super = Class(Actor)

function actor:init()
    super.init(self)

    self.name = "Bibliox"

    self.width = 57
    self.height = 55

    self.color = {0, 0, 1}

    self.flip = nil

    self.path = "battle/enemies/bibliox"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["hurt"]   = {"hurt", 1, true},
        ["spared"] = {"spare", 1, true},
    }

    self.offsets = {
        ["spare"] = {2, 4}
    }

    self.parts = {
        ["base"] = {"base"},
        ["head"] = {"head"},
        ["head_beard_stroke"] = {"head_beard_stroke"}
    }
end

function actor:createSprite()
    return BiblioxActorSprite(self)
end

function actor:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end

    if anim == "hurt" or anim == "spare" then
        sprite:setPartVisible(false)
    end
end

return actor