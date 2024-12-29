local Loading = {}

function Loading:init()
    self.logo = love.graphics.newImage("assets/sprites/kristal/title_logo_shadow.png")
    self.logo_big_star = love.graphics.newImage("assets/sprites/kristal/title/big_star.png")
    self.logo_text = love.graphics.newImage("assets/sprites/kristal/title/text.png")
    self.logo_tagline = love.graphics.newImage("assets/sprites/kristal/title/tagline.png")
end

function Loading:enter(from, dir)
    Mod = nil
    MOD_PATH = nil

    self.loading = false
    self.load_complete = false

    self.animation_done = false

    self.w = self.logo:getWidth()
    self.h = self.logo:getHeight()

    if not Kristal.Config["skipIntro"] then
        self.noise = love.audio.newSource("assets/music/darkplace_intro.ogg", "static")
        self.noise:play()
    else
        self:beginLoad()
    end

    self.siner = 0
    self.factor = 1
    self.factor2 = 0
    self.x = (320 / 2) - (self.w / 2)
    self.y = (240 / 2) - (self.h / 2) - 10
    self.animation_phase = 0
    self.animation_phase_timer = 0
    self.animation_phase_plus = 0
    self.logo_alpha = 1
    self.logo_alpha_2 = 1
    self.skipped = false
    self.skiptimer = 0
    self.key_check = not Kristal.Args["wait"]

    self.star_timer = 0
    self.star_scale = 0
    self.star_rot = -math.rad(90)
    self.star_rotspeed = 2

    self.letter_offsets = {}
    self.letter_w = 52
    for i = 1, 10 do
        self.letter_offsets[i] = {
            quad = love.graphics.newQuad((i - 1) * self.letter_w, 0,
                self.letter_w, self.logo_text:getHeight(),
                self.logo_text:getWidth(), self.logo_text:getHeight()),
            x = -20, y = 0, alpha = 0
        }
    end
    self.text_timer = 0
    self.tagline_alpha = 0

    self.fader_alpha = 0
end

function Loading:beginLoad()
    Kristal.clearAssets(true)

    self.loading = true
    self.load_complete = false

    Kristal.loadAssets("", "all", "")
    Kristal.loadAssets("", "plugins", "")
    Kristal.loadAssets("", "mods", "", function ()
        self.loading = false
        self.load_complete = true

        Assets.saveData()

        Kristal.setDesiredWindowTitleAndIcon()
    end)
end

function Loading:update()
    if self.load_complete and self.key_check and (self.animation_done or Kristal.Config["skipIntro"]) then
        -- create a console
        Kristal.Console = Console()
        Kristal.Stage:addChild(Kristal.Console)
        -- create the debug system
        Kristal.DebugSystem = DebugSystem()
        Kristal.Stage:addChild(Kristal.DebugSystem)
        REGISTRY_LOADED = true
        if Kristal.Args["test"] then
            Gamestate.switch(Kristal.States["Testing"])
        else
            Gamestate.switch(Kristal.States["MainMenu"])
        end
    end
end

function Loading:drawScissor(image, left, top, width, height, x, y, alpha)
    love.graphics.push()

    local scissor_x = ((math.floor(x) >= 0) and math.floor(x) or 0)
    local scissor_y = ((math.floor(y) >= 0) and math.floor(y) or 0)
    love.graphics.setScissor(scissor_x, scissor_y, width, height)

    Draw.setColor(1, 1, 1, alpha)
    Draw.draw(image, math.floor(x) - left, math.floor(y) - top)
    Draw.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.pop()
end

function Loading:drawSprite(image, x, y, alpha)
    love.graphics.push()
    love.graphics.setScissor()

    Draw.setColor(1, 1, 1, alpha)
    Draw.draw(image, math.floor(x), math.floor(y), 0, 1, 1, image:getWidth() / 2, image:getHeight() / 2)
    Draw.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

function Loading:lerpSnap(a, b, m, snap_delta)
    if snap_delta == nil then snap_delta = 0.001 end
    local result = Utils.lerp(a, b, m)
    if b - result <= snap_delta then
        return b
    end
    return result
end

function Loading:draw()
    if Kristal.Config["skipIntro"] then
        love.graphics.push()
        love.graphics.translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
        love.graphics.scale(1, 1)
        self:drawSprite(self.logo, 0, 0, 1)
        love.graphics.pop()
        return
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.logo_big_star, SCREEN_WIDTH/2, SCREEN_HEIGHT/2,
        self.star_rot, self.star_scale, self.star_scale,
        self.logo_big_star:getWidth()/2, self.logo_big_star:getHeight()/2)

    self.animation_phase_timer = self.animation_phase_timer + 1 * DTMULT
    if (self.animation_phase >= 0) then
        self.star_timer = self.star_timer + 0.1 * DTMULT

        local idle_rot = math.sin((self.star_timer - 2) * self.star_rotspeed / 10) / 4
        self.star_rot = self:lerpSnap(self.star_rot, idle_rot, 0.1 * DTMULT)

		local idle_scale = 1 + math.sin((self.star_timer - 2) * 0.4) * 0.1
        self.star_scale = self:lerpSnap(self.star_scale, idle_scale, 0.1 * DTMULT)
        if (self.animation_phase_timer >= 60) and self.animation_phase == 0 then
            self.animation_phase_timer = 0
            self.animation_phase = 1
            if not self.loading and not self.load_complete then
               self:beginLoad()
            end
        end
    end
    if (self.animation_phase >= 1) then
        self.text_timer = self.text_timer + DTMULT

        for i = 1, 10 do
            local off = self.letter_offsets[i]
            off.y = math.sin((self.text_timer + i * 10) / 20) * 20 - 5

            if i <= math.min(10, math.floor((self.text_timer + 4) / 4)) then
                off.x = Utils.ease(-10, 10, off.alpha, "out-cubic")
                off.alpha = Utils.approach(off.alpha, 1, 0.05 * DTMULT)
            end
        end
        for i = 1, 10 do
            local off = self.letter_offsets[i]
            love.graphics.setColor(1, 1, 1, off.alpha)
            love.graphics.draw(self.logo_text, off.quad, 66 + (i - 1) * self.letter_w + off.x, 220 + off.y)
        end
        --[[if (self.animation_phase_plus == 0) then
            self.siner = self.siner + 0.5 * dt_mult
        end
        if (self.siner >= 20) then
            self.animation_phase_plus = 1
        end
        if (self.animation_phase_plus == 1) then
            self.siner = self.siner + 0.5 * dt_mult
            self.logo_alpha = self.logo_alpha - 0.02 * dt_mult
            self.logo_alpha_2 = self.logo_alpha_2 - 0.08 * dt_mult
        end

        self:drawSprite(self.logo, self.x + (self.w / 2), self.y + (self.h / 2), self.logo_alpha_2)
        self.mina = (self.siner / 30)
        if (self.mina >= 0.14) then
            self.mina = 0.14
        end
        self.factor2 = self.factor2 + 0.05 * dt_mult
        for i = 0, 9 do
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) - (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) - (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) + (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) - (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) - (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) + (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
            self:drawSprite(self.logo,
                            ((self.x + (self.w / 2)) + (math.sin(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            ((self.y + (self.h / 2)) + (math.cos(((self.siner / 8) + (i / 2))) * (i * self.factor2))),
                            (self.mina * self.logo_alpha))
        end
        self:drawSprite(self.logo_heart, self.x + (self.w / 2), self.y + (self.h / 2), self.logo_alpha)]]
        if (self.animation_phase_timer >= 120 and self.animation_phase == 1) then
            self.animation_phase_timer = 0
            self.animation_phase = 2
        end
    end
    if (self.animation_phase >= 2) then
        self.tagline_alpha = Utils.approach(self.tagline_alpha, 1, 0.01 * DTMULT)
        if (self.animation_phase_timer >= 160) and not self.skipped and self.animation_phase == 2 then
            self.skipped = true
            self.animation_phase = 3
        end
        love.graphics.setColor(1, 1, 1, self.tagline_alpha)
        love.graphics.draw(self.logo_tagline,
            SCREEN_WIDTH/2, SCREEN_HEIGHT/2+120,
            0, 1, 1,
            self.logo_tagline:getWidth()/2, self.logo_tagline:getHeight()/2)
    end
    if self.skipped then
        -- Draw the screen fade
        Draw.setColor(0, 0, 0, self.fader_alpha)
        love.graphics.rectangle("fill", 0, 0, 640, 480)

        if self.fader_alpha > 1 then
            self.animation_done = true
            self.noise:stop()
        end

        -- Change the fade opacity for the next frame
        self.fader_alpha = math.max(0, self.fader_alpha + (0.02 * DTMULT))
        self.noise:setVolume(math.max(0, 1 - self.fader_alpha))
    end

    -- Reset the draw color
    Draw.setColor(1, 1, 1, 1)
end

function Loading:onKeyPressed(key)
    self.key_check = true
    self.skipped = true
    if not self.loading and not self.load_complete then
        self:beginLoad()
    end
end

return Loading
