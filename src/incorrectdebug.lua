local Debug = {}

function Debug:enter(previous, save)
    Kristal.Console:close()
    Kristal.DebugSystem:closeMenu()

    self.stage = Stage()

    self.save_data = save

    local _NOTHING = function(...) return true end

    self.old_lovequit = love.quit
    love.quit = _NOTHING

    self.old_overlayupdate = Kristal.Overlay.update
    Kristal.Overlay.update = _NOTHING

    self.old_overlaydraw = Kristal.Overlay.draw
    Kristal.Overlay.draw = _NOTHING

    Kristal.DebugSystem:refresh()
    TextInput.endInput()

    self.music = Music("fun")

    self.face = Sprite("misc/howfun")
    self.face:setWrap(true, true)
    self.face:setPhysics({
        speed = 0.5,
        direction = math.pi/4
    })
    self.face:addFX(ShaderFX(MainMenu.BACKGROUND_SHADER))
    self.stage:addChild(self.face)

    self.text = Text("TEST", Utils.random(200, SCREEN_WIDTH-200), Utils.random(200, SCREEN_HEIGHT-200))
    self.text.layer = self.face:getLayer()+10
    self.stage:addChild(self.text)
    self.text:setPhysics({
        speed_x = 2*Utils.randomSign(),
        speed_y = 2*Utils.randomSign()
    })

    self.text_list = {
        "YOU ARE FUNNY!",
        "YOU ARE AN IDIOT!",
        "YOU STARTED IT!",
        "YOU ALWAYS DO!"
    }
    self.list_index = 0

    self.timer = 0
    self.error_done = false

    self.shown_textbox = false

    self:changeTextText()
end

function Debug:changeTextText()
    self.list_index = self.list_index + 1
    if self.list_index > #self.text_list then
        self.list_index = 1
    end

    self.text:setText(self.text_list[self.list_index])
end

function Debug:leave()
    love.quit = self.old_lovequit
    Kristal.Overlay.update = self.old_overlayupdate
    Kristal.Overlay.draw = self.old_overlaydraw

    Kristal.loadAssets("", "mods", "", function ()
        Kristal.loadMod(self.save_data.mod, self.save_data.save_id, self.save_data.name, function ()
            if Kristal.preInitMod(self.save_data.mod) then
                Kristal.setDesiredWindowTitleAndIcon()
                Kristal.setState("Game", self.save_data)
            end
        end)
    end)
end

function Debug:update()
    self.timer = self.timer+DTMULT

    if self.timer >= 600 and not self.shown_textbox then
        self.shown_textbox = true

        self.textbox = Textbox(56, 344, 530, 104)
        self.textbox.layer = WORLD_LAYERS["textbox"]
        self.stage:addChild(self.textbox)
        self.textbox:setParallax(0, 0)

        self.textbox:setSkippable(false)

        self.textbox:setText("ツイートが毎回深読みされる仲間", function()
            self.textbox:remove()
        end)
        self.textbox.text.state["typing_sound"] = ""
    end

    if self.timer >= 1200 then
        if self.error_done then return end

        local previous_traceback = debug.traceback
        debug.traceback = function(...)
            return "stack traceback:\n50 69 72 61 63 79\n69 73\n6E 6F\n50 61 72 74 79\n00 00 00 00 00"
        end
        local loop = Kristal.errorHandler({critical = "unknown error"})
        while true do
            if loop() ~= nil then break end
        end
        debug.traceback = previous_traceback

        self.error_done = true

        Kristal.setState({})
    end

    local function fcolor(h, s, v)
        self.hue = (h / 255) % 1
        return Utils.hsvToRgb((h / 255) % 1, s / 255, v / 255)
    end

    self.text:setColor(fcolor(self.timer / 4, 160 + (math.sin(self.timer / 32) * 60), 255))
    if self.text.x <= 0 or self.text.x+self.text:getTextWidth() >= SCREEN_WIDTH then
        self.text.physics.speed_x = -self.text.physics.speed_x+(Utils.random()/10)*Utils.randomSign()
        self.text.physics.direction = self.text.physics.direction + Utils.random(math.pi/4, 7*math.pi/4)
        if self.text.x <= 0 then
            self.text.x = self.text.x+5
        else
            self.text.x = self.text.x-5
        end
        self:changeTextText()
    end
    if self.text.y <= 0 or self.text.y+self.text:getTextHeight() >= SCREEN_HEIGHT then
        self.text.physics.speed_y = -self.text.physics.speed_y+(Utils.random()/10)*Utils.randomSign()
        self.text.physics.direction = self.text.physics.direction + Utils.random(math.pi/4, 7*math.pi/4)
        if self.text.y <= 0 then
            self.text.y = self.text.y+5
        else
            self.text.y = self.text.y-5
        end
        self:changeTextText()
    end

    self.stage:update()
end

function Debug:draw()
    if self.error_done then return end
    Draw.setColor(1, 1, 1, 1)

    self.stage:draw()
end

return Debug
