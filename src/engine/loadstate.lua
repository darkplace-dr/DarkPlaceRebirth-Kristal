local Loading = {}

function Loading:init()
    self.logo = love.graphics.newImage("assets/sprites/kristal/title_logo_shadow.png")
    self.logo_big_star = love.graphics.newImage("assets/sprites/kristal/title/big_star.png")
    self.logo_text = love.graphics.newImage("assets/sprites/kristal/title/text.png")
    self.logo_tagline = love.graphics.newImage("assets/sprites/kristal/title/tagline.png")

    local date = os.date("*t")
    if date.month == 4 and date.day == 1 then
        self.fools = true
        self.shader_invert = love.graphics.newShader[[ vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) { vec4 col = texture2D( texture, texture_coords ); return vec4(1-col.r, 1-col.g, 1-col.b, col.a); } ]]
        self.logo_text = love.graphics.newImage("assets/sprites/kristal/title/fool.png")
    end
end

---@enum Loading.States
Loading.States = {
    WAITING = 0,
    LOADING = 1,
    DONE = 2,
}

function Loading:enter(from, dir)
    Mod = nil
    MOD_PATH = nil

    self.loading_state = Loading.States.WAITING

    self.animation_done = false

    self.w = self.logo:getWidth()
    self.h = self.logo:getHeight()

    if not Kristal.Config["skipIntro"] then
        self.noise = love.audio.newSource("assets/music/darkplace_intro.ogg", "static")
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

    self.done_loading = false
    self:beginLoad()
end

function Loading:beginLoad()
    Kristal.clearAssets(true)

    self.loading_state = Loading.States.LOADING

    Kristal.loadAssets("", "all", "")

    for _, name in ipairs(love.filesystem.getDirectoryItems("sharedlibs")) do
        local lib_full_path = "sharedlibs/"..name
        if love.filesystem.getInfo(lib_full_path .. "/lib.json") then
            local data = JSON.decode(love.filesystem.read(lib_full_path.."/lib.json"))
            if data.preload_assets then
                Kristal.loadAssets(lib_full_path, "all", "")
            end
        end
    end

    Kristal.loadAssets("", "plugins", "")

    Kristal.loadAssets("", "mods", "", function()
        self.loading_state = Loading.States.DONE

        Assets.saveData()

        Kristal.setDesiredWindowTitleAndIcon()

        -- Create the debug console
        Kristal.Console = Kristal.Stage:addChild(Console())
        -- Create the debug system
        Kristal.DebugSystem = Kristal.Stage:addChild(DebugSystem())

        REGISTRY_LOADED = true
    end)
end

function Loading:update()
    if self.done_loading then
        return
    end

    if (self.loading_state == Loading.States.DONE) and self.key_check and (self.animation_done or Kristal.Config["skipIntro"]) then
        -- We're done loading! This should only happen once.
        self.done_loading = true

        if Kristal.Args["test"] then
            Kristal.setState("Testing")
        elseif AUTO_MOD_START and TARGET_MOD then
            if not Kristal.loadMod(TARGET_MOD) then
                error("Failed to load mod: " .. TARGET_MOD)
            end
        else
            Kristal.setState("MainMenu")
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
    if self.loading_state == Loading.States.DONE then
        if self.fools then
            love.graphics.setShader(self.shader_invert)
        end


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
        if (self.animation_phase == 0) then
            self.noise:play()
        end
        if (self.animation_phase >= 0) then
            self.star_timer = self.star_timer + 0.1 * DTMULT

            local idle_rot = math.sin((self.star_timer - 2) * self.star_rotspeed / 10) / 4
            self.star_rot = self:lerpSnap(self.star_rot, idle_rot, 0.1 * DTMULT)

	    	local idle_scale = 1 + math.sin((self.star_timer - 2) * 0.4) * 0.1
            self.star_scale = self:lerpSnap(self.star_scale, idle_scale, 0.1 * DTMULT)
            if (self.animation_phase_timer >= 60) and self.animation_phase == 0 then
                self.animation_phase_timer = 0
                self.animation_phase = 1
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
                SCREEN_WIDTH/2, SCREEN_HEIGHT/2+60,
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

        --Reset Shaders
        love.graphics.setShader()
    end
end

function Loading:onKeyPressed(key)
    self.key_check = true
    self.skipped = true
end

return Loading
