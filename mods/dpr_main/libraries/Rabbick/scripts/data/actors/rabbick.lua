local actor, super = Class(Actor, "rabbick")

function actor:init()
    super.init(self)

    self.name = "Rabbick"

    self.width = 37
    self.height = 41

    self.hitbox = {3, 24, 24, 16}

    self.flip = "right"

    self.path = "enemies/rabbick"
    self.default = "idle"

    self.animations = {
        ["idle"] = {"idle", 4/30, true},
        ["spared"] = {"spared", 4/30, true},
        ["hurt"] = {"hurt_1", 0, false},
        ["hurt_2"] = {"hurt_2", 0, false},
        ["overworld"] = {"overworld", 4/30, true}
    }

    self.offsets = {
        ["idle"] = {0, 0},
        ["spared"] = {0, 0},
        ["hurt"] = {0, 0},
        ["hurt_2"] = {0, 0},
        ["overworld"] = {0, 0},
    }
end

function actor:onSpriteInit(sprite)
	sprite.fake_scale_x = 1
	sprite.half_scale = false
end

function actor:onSetSprite(sprite, texture, keep_anim)
	sprite.half_scale = false
    if texture == "hurt" then
		if sprite.fake_scale_x <= 0.75 then
			sprite.half_scale = true
			sprite:setSprite("hurt_2", keep_anim)
		end
	end
end

function actor:onSpriteUpdate(sprite)
	if sprite.scale_x and sprite.fake_scale_x then
		sprite.scale_x = sprite.fake_scale_x
		if sprite.half_scale then
			sprite.scale_x = sprite.fake_scale_x + 0.25
		end
	end
end

function actor:onResetSprite(sprite)
	sprite.half_scale = false
end

return actor