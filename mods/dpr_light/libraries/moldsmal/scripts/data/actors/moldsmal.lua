local actor, super = Class(Actor, "moldsmal")

function actor:init()
    super.init(self)

    -- Display name (optional)
    self.name = "Moldsmal"

    -- Width and height for this actor, used to determine its center
    self.light_battle_width = 46
    self.light_battle_height = 36

    self.hitbox = {0, 0, 16, 16}

    self.path = "enemies/moldsmal"
    self.default = "idle"

    self.animations = {
        ["lightbattle_hurt"] = {"idle", 1, true},
        ["defeat"] = {"idle", 1, true}
    }
    
    self:addLightBattlerPart("body", {
        ["create_sprite"] = function()
            local sprite = Sprite(self.path.."/idle", 0, 36)
            sprite.origin_y = 1
            return sprite
        end,
        ["init"] = function(part)
            part.scale_direction = 0.01
        end,
        ["update"] = function(part)
            if part.sprite.scale_y < 0.9 then
                part.scale_direction = 0.01
            end
            if part.sprite.scale_y > 1.1 then
                part.scale_direction = -0.01
            end
            part.sprite.scale_y = part.sprite.scale_y + (part.scale_direction * DTMULT)
        end
    })
end

return actor