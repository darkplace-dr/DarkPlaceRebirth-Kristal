local actor, super = Class(Actor, "floradinn")

function actor:init()
    super.init(self)

    self.name = "Floradinn"

    self.width = 34
    self.height = 35

    self.hitbox = {4, 16, 26, 19}

    self.flip = "right"

    self.path = "battle/enemies/floradinn"
    self.default = "idle"

    self.animations = {
        ["idle"] = { "hidden", 0.2, true },
        ["mane"] = { "hidden", 0.2, true },

        ["hurt"] = { "hurt", 0.2, true },
        ["hurt_flat"] = { "hurt_postflattened", 0.2, true },
        ["hurt_pink"] = { "hurt_pink", 0.2, true },
        ["hurt_pink_flat"] = { "hurt_postflattened_pink", 0.2, true },

        ["spared"] = { "spared", 0.2, true },
        ["spared_flat"] = { "postflattened_pink", 0.2, true },
    }

    self.parts = {
        ["head"] = { "head" },
        ["body"] = { "body" },
        ["spikes"] = { "spikes" },
        ["spikes_return"] = { "spikes_return" }
    }

    self.offsets = {
        ["hurt"] = { -3, -7 },
        ["hurt_pink"] = { -3, -7 },
        ["hurt_postflattened"] = { -10, -7 },
        ["hurt_postflattened_pink"] = { -10, -7 },

        ["postflattened"] = { -10, 0 },
        ["postflattened_disappointed"] = { -10, -1 },
        ["postflattened_flipped"] = { -10, 0 },
        ["postflattened_flipped_pink"] = { -10, 0 },
        ["postflattened_pink"] = { -10, 0 },

        ["disappointed_flattened_pink"] = { -10, -1 },

        ["swordraise"] = { -3, -8 },
        ["swordraise_flattened"] = { -10, -8 },
        ["swordraise_pink"] = { -3, -8 },
        ["swordraise_pink_flattened"] = { -10, -8 },
    }

    self.pink = false
    self.flattened = false
end

function actor:createSprite()
    return FloradinnActor(self)
end

function actor:getAnimation(anim)
    if anim == "hurt" then
        if not self.flattened then
            if not self.pink then
                return self.animations[anim]
            else
                return self.animations["hurt_pink"]
            end
        else
            if not self.pink then
                return self.animations["hurt_flat"]
            else
                return self.animations["hurt_pink_flat"]
            end
        end
    elseif anim == "spared" then
        if not self.flattened then
            return self.animations[anim]
        else
            return self.animations["spared_flat"]
        end
    end

    return super.getAnimation(self, anim)
end

return actor