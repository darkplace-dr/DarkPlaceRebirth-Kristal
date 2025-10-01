local Electrodasher, super = Class(Actor, "electrodasher")

function Electrodasher:init()
    super.init(self)

    self.name = "Electrodasher"

    self.width = 48
    self.height = 42

    self.color = {1, 0, 0}

    self.flip = "right"

    self.path = "battle/enemies/electrodasher"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["overworld"] = {"overworld"},
        ["hurt"]      = {"hurt"},
    }

    self.offsets = {
        ["overworld"] = {0, 0},
        ["hurt"]      = {4, -6},
	}

    self.parts = {
        ["body"] = {"body"},
        ["legs"] = {"legs"}
    }

    self.disallow_replacement_texture = true
end

function Electrodasher:createSprite()
    return ElectrodasherActor(self)
end

function Electrodasher:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end
	
    if anim == "overworld" or anim == "hurt" then
        sprite:setPartVisible(false)
    end
end

return Electrodasher