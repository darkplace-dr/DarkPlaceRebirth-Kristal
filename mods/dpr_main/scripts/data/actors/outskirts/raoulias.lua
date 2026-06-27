local actor, super = Class(Actor, "raoulias")

function actor:onSpriteInit(sprite)

self.wave = love.graphics.newShader([[
    extern number wave_sine;
    extern number wave_mag;
    extern number wave_height;
    extern vec2 texsize;
    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
    {
        number i = texture_coords.y * texsize.y;
        vec2 coords = vec2(max(0.0, min(1.0, texture_coords.x + (sin((i / wave_height) + (wave_sine / 30.0)) * wave_mag) / texsize.x)), max(0.0, min(1.0, texture_coords.y + 0.0)));
        return Texel(texture, coords) * color;
    }
]])

end

function actor:onSpriteDraw(sprite)

    if not sprite.smoke then
        sprite.time = 0

        sprite.alpha = 0

        sprite.legs = Sprite(self.path.. "/legs", 13.5, 18)
        sprite:addChild(sprite.legs)
        sprite.legs:setOrigin(0.5, 1)

        sprite.smoke = Sprite(self.path.. "/smoke")
        sprite:addChild(sprite.smoke)
        sprite.smoke:setOrigin(0, 0.5)

-- Kristal.getTime()~
        sprite.smoke:addFX(ShaderFX(self.wave, {
            ["wave_sine"] = function () return 50 * sprite.smoke.scale_x end,
            ["wave_mag"] = 4,
            ["wave_height"] = 10,
            ["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
        }), "funky_mode")

        sprite.flower = Sprite(self.path.. "/flower")
        sprite:addChild(sprite.flower)
        sprite.flower:setOrigin(0.5, 0.5)

        --sprite:addFX(OutlineFX({1, 1, 1}))
    else
        sprite.time = sprite.time + DT
        local spx = math.sin(sprite.time)
        local tim = math.sin(sprite.time * 1.33)
        local lox = math.sin(sprite.time * 1.15) 

        if spx < 0 then spx = spx*-1 end
        if lox < 0 then lox = lox*-1 end


        sprite.smoke.scale_y = 1 - ((spx*1.2)/6)

        sprite.smoke.y = 3 + (-lox * 6)

        sprite.flower.x = (spx*5) - 5
        sprite.flower.rotation = tim/1.5
        sprite.flower.y = 1 + spx*4 + (-lox * 6.5)

        sprite.legs.scale_y = (lox/2) + 0.5

        sprite.smoke.scale_x = ((spx*1.5)/6) + 1
    end
end

function actor:init()
    super.init(self)
    self.name = "raoulias"

    self.width = 27
    self.height = 18

    self.hitbox = {0, 25, 19, 14}

    self.soul_offset = {10, 24}

    self.path = "battle/enemies/raoulias"

    self.default = "legs"

    self.portrait_path = nil
    self.portrait_offset = nil
    self.can_blush = false

    self.animations = {
    }
    self.mirror_sprites = {
    }

    self.offsets = {
    }
end

return actor