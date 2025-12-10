---@class DogCheck : Rectangle
---@overload fun(...) : DogCheck
local DogCheck, super = Class(Rectangle, "dogcheck") -- lmao

function DogCheck:init(variant)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
	self.color = COLORS.black
    self.parallax_x = 0
    self.parallax_y = 0
	self.layer = WORLD_LAYERS["top"]
    self.debug_select = true

    ---@type ""|"IDLE"|"EXITING"
    self.state = ""

    if variant then self.variant = variant end

    self.dog = nil
    self.song = nil
    self.song_pitch = 1

    self.timer = Timer()
    self:addChild(self.timer)

    self.summer_siner = 0
    self.stretch_ex_start = 0
    self.stretch_ex_timer = 0
	
    self.color_siner = 0

    self.chicken_anim_siner = 0
	
    self.pumpkin_x = 0
    self.pumpkin_goal_x = 0
    self.pumpkin_frame = 1
    self.pumpkins_made = 0
	
    self.prophecy_siner = 0

    love.window.setTitle("Dog Place: REBIRTH")
end

function DogCheck:onAdd(parent)
    if parent:includes(World) then
        self.world = parent
    elseif parent.world then
        self.world = parent.world
    end
    if parent.music then
        self.music = parent.music
    elseif self.world and self.world.music then
        self.music = self.world.music
    elseif Game.music then
        self.music = Game.music
    end

    -- Undertale does this
    self.start_wait_handle = self.timer:after(5/30, function() self:start() end)
end

function DogCheck:start()
    if self.state ~= "" then return end
    self.state = "IDLE"

    local function createDog(sprite, anim_speed, x_off, y_off, scale)
        x_off = x_off or 0
        y_off = y_off or 0
        scale = scale or 4

        self.dog = Sprite(sprite, self.width / 2 + x_off, self.height / 2 + y_off)
        self.dog:setOrigin(0.5, 0.5)
        if scale == "fitscreen" then
            scale = math.min(self.width / self.dog.width, self.height / self.dog.height)
            scale = math.floor(scale * 100) / 100
        end
        self.dog:setScale(scale)
        self.dog:play(anim_speed, true)
        self:addChild(self.dog)
    end

    local function playSong(path, pitch_rand_min, pitch_rand_max)
        pitch_rand_min = pitch_rand_min or 1
        pitch_rand_max = pitch_rand_max or pitch_rand_min

        self.song = path
        self.song_pitch = Utils.random(pitch_rand_min, pitch_rand_max)
        if self.music then
            self.music:play(path, nil, self.song_pitch)
        end
    end

    if not self.variant then
        local month = os.date("*t").month
        local day = os.date("*t").day
        local variant_choices = {"dance", "sleep", "maracas", "piano", "banned", "banned_b", "chapter2", "chapter3", "chapter4", "montypython", "house"}
        if month >= 3 and month <= 5 then
            table.insert(variant_choices, "spring")
        elseif month >= 6 and month <= 8 then
            table.insert(variant_choices, "summer")
        elseif month >= 9 and month <= 11 then
            table.insert(variant_choices, "autumn")
        elseif month == 12 or month <= 2 then
            table.insert(variant_choices, "winter")
        end
        if month == 10 and day == 31 then
            table.insert(variant_choices, "halloween")
        end
        self.variant = Utils.pick(variant_choices)
    end

    local cust_sprites_base = "kristal/dogcheck"
    local song_path = "dogcheck/"

    if self.variant == "dance" then
        createDog(cust_sprites_base.."/dog_dance", 0.2)
        playSong(song_path.."dance_of_dog", 0.95, 1.05)
    elseif self.variant == "sleep" then
        createDog("misc/dog_sleep", 0.8)
        local song_here = Utils.pick({song_path.."dogcheck", "deltarune/tv_results_screen", song_path.."sigh_of_dog", song_path.."dogcheck_anniversary"})
        local song_is_sog = song_here == song_path.."sigh_of_dog"

        if song_here == song_path.."dogcheck" then
            playSong(song_here, (0.9 + Utils.random(0.1)))
        elseif song_here == "deltarune/tv_results_screen" then
            playSong(song_here, 2.5)
		else
            playSong(song_here, song_is_sog and 0.8 or 1, 1)
        end
    elseif self.variant == "maracas" then
        createDog(cust_sprites_base.."/dog_maracas", 0.1, 20, -20)
        playSong(song_path.."baci_perugina2")
    elseif self.variant == "piano" then
        createDog(cust_sprites_base.."/dog_piano", 0.5)
        local song_here = Utils.pick({song_path.."legend_piano", song_path.."snowdin_piano", song_path.."home_piano", song_path.."5_4_improv", song_path.."bowser_piano_victory"})
        playSong(song_here)
    elseif self.variant == "spring" then
        createDog(cust_sprites_base.."/dog_spring", 0.2, -2, -13)
        playSong(song_path.."options_fall")
    elseif self.variant == "summer" then
        createDog(cust_sprites_base.."/dog_summer", 0.8, 0, 24)
        self.dog:setOrigin(0.5, 1)
        playSong(song_path.."options_summer")
    elseif self.variant == "autumn" then
        createDog(cust_sprites_base.."/dog_autumn", 0.8, -2, -10)
        playSong(song_path.."options_fall")
    elseif self.variant == "winter" then
        createDog(cust_sprites_base.."/dog_winter", 0.8, -2, -14)
        playSong(song_path.."options_winter")
    elseif self.variant == "banned" then
        createDog(cust_sprites_base.."/banned", 1, 0, 0, 2)
        playSong("AUDIO_DEFEAT", 1.5)
    elseif self.variant == "banned_b" then
        createDog(cust_sprites_base.."/banned_b", 1, 0, 0, 1)
        playSong(song_path.."mutation")
    elseif self.variant == "chapter2" then
        createDog("misc/dog_sleep", 0.8, -960, -580)
        playSong(song_path.."alarm_titlescreen", 1, 1)
        self.timer:script(function(...) self:chapter2Script(...) end)
    elseif self.variant == "chapter3" then
        createDog(cust_sprites_base.."/dog_board", 0.2, 0, 0, 8)
        playSong(song_path.."ch3_board3")
    elseif self.variant == "chapter4" then -- WIP. sleeping dog sprite is a placeholder until we have the actual dog prophecy object ready lol
        playSong(song_path.."annoying_prophecy")
    elseif self.variant == "montypython" then
        playSong(song_path.."intermission")
    elseif self.variant == "house" then
        playSong(song_path.."house")
    elseif self.variant == "halloween" then
        playSong(song_path.."halloween")
        for i = 0, 9 do
            self:makeBGPumpkin(1, 50, i*68)
            self:makeBGPumpkin(-1, SCREEN_HEIGHT-50-44, i*68)
            self.pumpkins_made = self.pumpkins_made + 1
        end
        self.timer:script(function(...) self:pumpkinDudeScript(...) end)
    end
end

function DogCheck:update()
    super.update(self)

    -- Make sure we *do* have the menu turned off (zero WIP)
    Game.lock_movement = true

    if self.state == "" then return end

    if self.state == "IDLE" --[[and not self.world:hasCutscene() for zero WIP]] and not OVERLAY_OPEN
        and Input.pressed("confirm")
    then
        self.state = "EXITING"
        Game.fader:fadeOut(nil, { speed = 0.5 })
        if self.music then self.music:fade(0, 20/30) end
        self.timer:after(1, function ()
            self:remove()
            Game:returnToMenu()
            love.window.setTitle(mod and mod.name or Kristal.game_default_name)
        end)
    end

    if self.variant == "summer" then
        self.stretch_ex_start = self.stretch_ex_start + DTMULT
        if self.stretch_ex_start >= 240 then
            self.stretch_ex_timer = self.stretch_ex_timer + DTMULT
            if self.stretch_ex_timer >= 1100 and math.abs(math.sin(self.summer_siner / 15)) < 0.1 then
                self.stretch_ex_timer = 0
                self.stretch_ex_start = 0
            end
        end
        self.summer_siner = self.summer_siner + DTMULT
        local extra_stretch = math.sin(self.summer_siner / 15) * (0.2 + (self.stretch_ex_timer / 900))
        self.dog:setScale(4 + 1 + extra_stretch, 4 + 1 - extra_stretch)
    end
	
    if self.variant == "montypython" then
        self.color_siner = self.color_siner + 0.5 * DTMULT
    end
    if self.variant == "halloween" then
        self.pumpkin_x = Utils.ease(self.pumpkin_x, self.pumpkin_goal_x, DTMULT/10, "out-quad")
        if self.chicken_anim_siner % 34 == 0 then
            self:makeBGPumpkin(1, 50)
            self:makeBGPumpkin(-1, SCREEN_HEIGHT-50-44)
            self.pumpkins_made = self.pumpkins_made + 1
        end
    end
end

function DogCheck:getDebugInfo()
    if self.state == "" then
        return { string.format("Starting in: %gs", self.start_wait_handle.limit - self.start_wait_handle.time) }
    end

    return {
        "State: " .. self.state,
        "Variant: " .. self.variant,
        string.format("Song: %s (%gx)", self.song, self.song_pitch)
    }
end

function DogCheck:makeBGPumpkin(axis, y, x)
    local pumpkin_sprite = Sprite("kristal/dogcheck/pumpkin", 0, y)
    if not x then
        if axis > 0 then
            pumpkin_sprite.x = -68
        else
            pumpkin_sprite.x = SCREEN_WIDTH+34
        end
    else
        pumpkin_sprite.x = x
    end
    pumpkin_sprite:setScale(2)
    pumpkin_sprite.start_y = y
    pumpkin_sprite.physics.speed = axis * 2
    pumpkin_sprite.siner = self.chicken_anim_siner+self.pumpkins_made*4
    pumpkin_sprite.alpha_siner = self.chicken_anim_siner+self.pumpkins_made
    pumpkin_sprite.axis = axis
    pumpkin_sprite.id = self.pumpkins_made
    Utils.hook(pumpkin_sprite, "update", function(orig, self, ...)
        orig(self, ...)
        self.siner = self.siner + DTMULT
        self.alpha_siner = self.alpha_siner + DTMULT
        local alpha_base = self.id % 2 == 0 and math.sin((self.alpha_siner)/10) or math.cos((self.alpha_siner)/10),0,1
        self.alpha = Utils.clampMap(alpha_base, -0.9, 0.9, 0.1, 1)
        if axis > 0 then
            self.y = self.start_y + math.sin((self.siner)/5)*6
            if self.x < -70 then
                self:remove()
            end
        else
            self.y = self.start_y - math.cos((self.siner)/5)*6
            if self.x > SCREEN_WIDTH+70 then
                self:remove()
            end
        end
    end)
    self:addChild(pumpkin_sprite)
end

local function draw_sprite_tiled_ext(tex, _, x, y, sx, sy, color, alpha)
    local r,g,b,a = love.graphics.getColor()
    if color then
        Draw.setColor(color, alpha)
    end
    Draw.drawWrapped(tex, true, true, x, y, 0, sx, sy)
    love.graphics.setColor(r,g,b,a)
end

function DogCheck:draw()
    super.draw(self)

    local cust_sprites_base = "kristal/dogcheck"

    if self.state == "" then return end
    --check it out, i'm house
    if self.variant == "house" then
        self.chicken_anim_siner = self.chicken_anim_siner + DTMULT

		local chicken = Assets.getFrames(cust_sprites_base.."/chicken")
        local house   = Assets.getTexture(cust_sprites_base.."/house")

		local chicken_frame =  math.floor(self.chicken_anim_siner/24) % #chicken + 1

        Draw.draw(house, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 1, 1, 105/2 + 0.5, 86/2)
        Draw.draw(chicken[chicken_frame], 285, 241, 0, 1, 1)
    end

    if self.variant == "halloween" then
        self.chicken_anim_siner = self.chicken_anim_siner + DTMULT

		local chicken      = Assets.getFrames(cust_sprites_base.."/chicken")
		local pumpkin_dude = Assets.getFrames(cust_sprites_base.."/pumpkin_dude")
        local bg_pumpkin   = Assets.getTexture(cust_sprites_base.."/pumpkin")

		local chicken_frame = math.floor(self.chicken_anim_siner/10) % #chicken + 1

        Draw.setColor(1,1,1,1)
        Draw.draw(chicken[chicken_frame], (SCREEN_WIDTH/2)+self.pumpkin_x-15*2, SCREEN_HEIGHT/2-21*2, 0, 4, 4)
        Draw.draw(pumpkin_dude[self.pumpkin_frame], (SCREEN_WIDTH/2)+self.pumpkin_x-160-23*2, SCREEN_HEIGHT/2-35*2, 0, 4, 4)
        Draw.draw(pumpkin_dude[self.pumpkin_frame], (SCREEN_WIDTH/2)+self.pumpkin_x+160-23*2, SCREEN_HEIGHT/2-35*2, 0, 4, 4)
    end

    if self.variant == "montypython" then
        Draw.setColor({Utils.hsvToRgb(((self.color_siner) % 255)/255, 255/255, 255/255)})
        Draw.drawWrapped(Assets.getTexture(cust_sprites_base.."/intermission_bg"), true, true, 0, 0, 0, 1, 1)

        Draw.setColor({Utils.hsvToRgb(((self.color_siner) % 255)/255, (60 + (math.sin((self.color_siner / 10)) * 15))/255, 255/255)})		
        love.graphics.printf("Intermission", -320, 200, SCREEN_WIDTH, "center", 0, 2, 2, 0.5, 0.5)
    end

    -- Ported the sun out of boredom, uncomment this if you want. - Agent 7
    if self.variant == "summer" then
        Draw.setColor(1, 1, 0)
        love.graphics.circle("fill", 420 + math.cos(self.summer_siner / 18) * 6, 40 + math.sin(self.summer_siner / 18) * 6, 28 + math.sin(self.summer_siner / 6) * 4, 100)
    end
	
	if self.variant == "chapter4" then
        self.prophecy_siner = self.prophecy_siner + DTMULT
		local tilespr = Assets.getTexture(cust_sprites_base.."/prophecy/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS")
		local tiletex = Assets.getTexture(cust_sprites_base.."/prophecy/IMAGE_DEPTH_EXTEND_SEAMLESS")
		local grad20 = Assets.getTexture(cust_sprites_base.."/prophecy/gradient20")
		local w = 150
		local h = 90
		local xoff = 0
		local yoff = 0
		local xsin = 0
		local ysin = math.cos(self.prophecy_siner / 12) * 4
		local sprite_canvas = Draw.pushCanvas(320, 240)
		love.graphics.stencil(function()
			local last_shader = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			Draw.draw(Assets.getTexture(cust_sprites_base.."/uz"), 75, 80, 0, 1, 1, 11, 80)
			love.graphics.setShader(last_shader)
		end, "replace", 1)
		love.graphics.setStencilTest("greater", 0)
		draw_sprite_tiled_ext(tilespr, 0, math.ceil(self.prophecy_siner / 2), math.ceil(self.prophecy_siner / 2), 1, 1, Utils.hexToRgb("#42D0FF"))
		love.graphics.setStencilTest()

		local back_canvas = Draw.pushCanvas(w, h)
		local ogbg = Utils.hexToRgb("#A3F8FF")
		ogbg = COLORS["black"]
		local linecol = Utils.mergeColor(Utils.hexToRgb("#8BE9EF"), Utils.hexToRgb("#17EDFF"), 0.5 + (math.sin(self.prophecy_siner / 120) * 0.5))
		local gradalpha = 1
		Draw.setColor(ogbg, gradalpha*0.5)
		Draw.rectangle("fill", 0, 0, 320, 240)
		love.graphics.setBlendMode("add")
		draw_sprite_tiled_ext(tiletex, 0, math.ceil(-self.prophecy_siner / 2), math.ceil(-self.prophecy_siner / 2), 1, 1, linecol, 1)
		love.graphics.setBlendMode("alpha")
		local gradcol = COLORS["black"]
		Draw.setColor(gradcol, gradalpha)
		Draw.draw(grad20, 0, 0, 0, w/20, -3, 0, 20)
		Draw.draw(grad20, 0, h, 0, w/20, 3, 0, 20)
		Draw.draw(grad20, 0, 0, math.rad(90), h/20, 3, 0, 20)
		Draw.draw(grad20, w, 0, math.rad(90), h/20, -3, 0, 20)
		love.graphics.setBlendMode("alpha")
		love.graphics.setBlendMode("add")
		Draw.setColor(1,1,1)
		Draw.draw(sprite_canvas, offx, offy, 0, 1, 1)
		Draw.draw(sprite_canvas, offx, offy, 0, 1, 1)
		Draw.draw(sprite_canvas, offx, offy, 0, 1, 1)
		love.graphics.setBlendMode("alpha")
		Draw.popCanvas()
		Draw.popCanvas()
		for i = 1, 2 do	
			Draw.setColor(1,1,1,0.5) -- The alpha isn't accurate to DR's code but fuck it
			Draw.draw(back_canvas, SCREEN_WIDTH/2 + ysin * (2 * i), SCREEN_HEIGHT/2 + ysin * (2 * i), 0, 4, 4, w/2, h/2)
		end
		Draw.setColor(1,1,1,1)
		Draw.draw(back_canvas, SCREEN_WIDTH/2 + xsin, SCREEN_HEIGHT/2 + ysin, 0, 4, 4, w/2, h/2)
	end
end

function DogCheck:chapter2Script(wait)
    local sprite = "kristal/dogcheck/dog_car"

    local dog = Sprite(sprite, -40, 240)
    dog:setScale(2)
    dog.layer = 1
    self:addChild(dog)

    local function animateMainDog(speed, dont_reset)
        if not dont_reset then
            if speed > 0 then
                dog.x = -40
            else
                dog.x = SCREEN_WIDTH
            end
        end
        dog.flip_x = speed > 0
        dog.physics.speed = speed
        if not dont_reset then
            dog:play(0.25, true)
        end
    end
    local function makeSmallDogHorde(axis, num)
        for _ = 1, num do
            local small_dog = Sprite(sprite, 0, 240 + love.math.random(-80, 80))
            if axis > 0 then
                small_dog.x = -40
            else
                small_dog.x = SCREEN_WIDTH
            end
            small_dog.flip_x = axis > 0
            small_dog.physics.speed = axis * love.math.random(10, 16)
            small_dog.physics.friction = Utils.random(0.01, -0.01)
            local anim_speed = (1 + (small_dog.physics.speed / 4)) * 0.25
            small_dog:play(anim_speed, true)
            -- auto-cleanup
            ---@diagnostic disable-next-line: redefined-local
            Utils.hook(small_dog, "update", function(orig, self, ...)
                orig(self, ...)
                if math.abs(self.x) > SCREEN_WIDTH + 3*TILE_WIDTH then
                    self:remove()
                end
            end)
            self:addChild(small_dog)
        end
    end

    while true do
        for _ = 1, 2 do
            if dog.x < 0 then animateMainDog(10) end
            wait(2.75)
            animateMainDog(-10)
            wait(3)
        end

        makeSmallDogHorde(1, love.math.random(4, 8))
        animateMainDog(12)
        wait(2.5)
        makeSmallDogHorde(-1, love.math.random(5, 12))
        animateMainDog(-12)
        wait(2.5)

        animateMainDog(8)
        wait(1.03)
    end
end

function DogCheck:pumpkinDudeScript(wait)
    local function pumpkinGoLeft(x)
        self.pumpkin_frame = 7
        wait(2/30)
        self.pumpkin_frame = 8
        self.pumpkin_goal_x = x
        wait(5/30)
        self.pumpkin_frame = 9
        wait(3/30)
        self.pumpkin_frame = 10
        wait(1/30)
        self.pumpkin_frame = 6
        wait(5/30)
    end
    local function pumpkinGoRight(x)
        self.pumpkin_frame = 2
        wait(2/30)
        self.pumpkin_frame = 3
        self.pumpkin_goal_x = x
        wait(5/30)
        self.pumpkin_frame = 4
        wait(3/30)
        self.pumpkin_frame = 5
        wait(1/30)
        self.pumpkin_frame = 1
        wait(5/30)
    end
    while true do
        pumpkinGoRight(-15*4)
        pumpkinGoLeft(0)
        pumpkinGoLeft(15*4)
        pumpkinGoRight(0)
    end
end

return DogCheck