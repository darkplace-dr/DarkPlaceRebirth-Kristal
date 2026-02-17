---@class TitanSpawnPurifySoul : Object
---@overload fun(...) : TitanSpawnPurifySoul
local TitanSpawnPurifySoul, super = Class(Object)

function TitanSpawnPurifySoul:init(x, y)
    self.texture = Assets.getTexture("player/heart_centered") -- spr_heart_centered is the sprite used for the original object in DR.
    super.init(self, x, y, self.texture:getWidth(), self.texture:getHeight())

    self:setOrigin(0.5, 0.5)

    self.siner = 0
    self.t = 395
    self.con = 0

    self.rs = 0
    self.ds2 = 1
    self.ds3 = 0

    self.faster = false
    self.purify_init = false
    self.timer = 0

    self.start_x, self.start_y = self.x, self.y
    self.image_alpha = 1

    --custom con variables so the object works properly when self.faster is enabled
    self.soundcon = 1
    self.enemymovecon = 1
    self.enemysparecon = 1
end

function TitanSpawnPurifySoul:draw()
    super.draw(self)

    --play "great_shine" sound
    if not self.purify_init then
        self.purify_init = true

        if self.faster then
            Assets.playSound("great_shine", 1, 1.2)
        else
            Assets.playSound("great_shine", 1, 1.2)
        end
    end

    --increase timer variables
    self.siner = self.siner + 1.5 * DTMULT
    self.t = self.t + DTMULT
    if self.t >= 400 and self.faster then
        self.t = self.t + DTMULT
    end
    if self.faster then
        self.siner = self.siner + 1.5 * DTMULT
    end
	
    --play "revival" sound
    if self.t >= 400 then
        if self.soundcon == 1 then
            Assets.playSound("revival", 1, 1)
            self.soundcon = 2
        end
    end

    --shine effect
    if self.t >= 400 and self.t < 450 then
        self.rs = self.rs + 0.5 * DTMULT
        if self.faster then
            self.rs = self.rs + 0.5 * DTMULT
        end

        love.graphics.push("all")
        love.graphics.origin()
        love.graphics.translate(0, 0)
        for i = 1, 20-1 do
            local x = self.start_x - (i * i) - (self.rs * i)
            local y = 0
            local w = self.start_x + (i * i) + (self.rs * i)
            local h = 500

            Draw.setColor(1, 1, 1, (self.rs / 16) - (i / 20))
            Draw.rectangle("fill", x, y, w - x + 1, h - y + 1)
        end
        love.graphics.pop()

        Draw.setColor(1, 1, 1, 1)
    end

    --white fade rectangle & move titan spawn enemies offscreen
    if self.t >= 450 then
        if self.enemymovecon == 1 then
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.id == "titan_spawn" then
                    enemy.x = enemy.x + 300
                end
            end
            self.enemymovecon = 2
        end

        self.ds2 = self.ds2 - 0.01 * DTMULT
        if self.faster then
            self.ds2 = self.ds2 - 0.01 * DTMULT
        end

        love.graphics.push("all")
        love.graphics.origin()
        love.graphics.translate(0, 0)

        local x = -10
        local y = -10
        local w = 999
        local h = 999

        Draw.setColor(1, 1, 1, self.ds2)
        Draw.rectangle("fill", x, y, w - x + 1, h - y + 1)

        love.graphics.pop()

        Draw.setColor(1, 1, 1, 1)
    end

    --purify titan spawn enemies
    if self.t >= 500 then
        if self.enemysparecon == 1 then
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.id == "titan_spawn" then
                    enemy:spare()
                end
            end
            self.enemysparecon = 2
        end
    end

    --decrease alpha of white rectangle
    if self.t >= 540 then
        self.image_alpha = self.image_alpha - 0.1 * DTMULT
    end

    --remove object
    if self.t >= 550 or (self.faster and self.t >= 550) then
        self:remove()
    end

    --draw the soul
    local r, g, b, a = self:getDrawColor()
    local function draw_sprite_ext(x_scale, y_scale, alpha)
        Draw.setColor(r, g, b, a * alpha)
        Draw.draw(self.texture, self.width / 2, self.height / 2, nil, self.scale_x * x_scale, self.scale_y * y_scale, self.width * self.origin_x, self.width * self.origin_y)
    end

    if self.t >= 540 then
        draw_sprite_ext(1, 1, self.image_alpha)
    else
        draw_sprite_ext(1, 1, self.siner / 8)
        draw_sprite_ext(self.siner / 4, self.siner / 4, 1.6 - (self.siner / 16))
        draw_sprite_ext(self.siner / 8, self.siner / 8, 1.6 - (self.siner / 24))

        if self.t >= 430 then
            if self.t >= 430 and self.t <= 440 then
                if not self.faster then
                    self.timer = self.timer + 10 * DTMULT
                else
                    self.timer = self.timer + 20 * DTMULT
                end
            end
        
            if self.t >= 450 then
                if not self.faster then
                    self.timer = self.timer - DTMULT
                else
                    self.timer = self.timer - 2 * DTMULT
                end
            end

            draw_sprite_ext(1, 1, self.timer / 100)
        end
    end

    Draw.setColor(1, 1, 1, 1)
end

return TitanSpawnPurifySoul