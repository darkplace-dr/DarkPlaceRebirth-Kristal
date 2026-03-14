local Voidspawn, super = Class(Actor, "voidspawn")

function Voidspawn:init()
    super.init(self)

    self.name = "Voidspawn"

    self.width = 62
    self.height = 62

    self.color = {1, 0, 0}

    self.flip = nil

    self.path = "battle/enemies/voidspawn"
    self.default = "idle"

    self.talk_sprites = {}

    self.animations = {
        ["idle"]   = {"body"},
        ["squash"] = {"squash"},
    }

    self.offsets = {
        ["idle"]   = {0, 0},
        ["squash"] = {0, 0},
	}

    self.parts = {
        ["body"] = {"body"},
        ["eye"] = {"eye"},
        ["iris"] = {"iris"}
    }

    self.disallow_replacement_texture = true
end

function Voidspawn:createSprite()
    return VoidspawnActor(self)
end

function Voidspawn:onSetAnimation(sprite, anim, ...)
    local args = {...}
    if type(anim) == 'table' then anim = anim[1] end
	
    if anim == "overworld" or anim == "hurt" then
        sprite:setPartVisible(false)
    end
end

return Voidspawn