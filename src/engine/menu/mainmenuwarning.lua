---@class MainMenuWarning : StateClass
---
---@field menu MainMenu
---@field container Object
---
---@overload fun(menu:MainMenu) : MainMenuWarning
local MainMenuWarning, super = Class(StateClass)

function MainMenuWarning:init(menu)
    self.menu = menu

    self.list = nil

    self.warning_state = ""

    self.warnings = Utils.split(love.filesystem.read("assets/warning.txt"), "\n")
    -- Clean up line endings
    do
        local banned = {[" "] = true, ["\r"] = true, ["\t"] = true}
        for index, value in ipairs(self.warnings) do
            while banned[self.warnings[index][#self.warnings[index]]] do
                self.warnings[index] = Utils.sub(self.warnings[index], 1, utf8.len(self.warnings[index])-1)
            end
        end
    end
    -- Removes the last item and errors if that wasn't a blank line
    assert(table.remove(self.warnings, #self.warnings) == "", "No final newline on warnings.txt!")

    local noel_data = Noel:loadNoel()
    local noel_reset = false

    if noel_data and noel_data.version ~= 0.016 then
        love.filesystem.remove("saves/null.char")
        noel_reset = true
    end

    if Kristal.Config["seenLegitWarning"] then
        if love.math.random(1, 100) <= 50 then
            self.current_warning = Utils.pick(self.warnings)
        else
            self.current_warning = "This game is still under active development. Some bugs or crashes may appear during your playing experience."
        end
        if noel_reset == true then
            Assets.playSound("ominous", 4, 0.5)
            self.current_warning = "Invalid null.char found!?!?\nnull.char has been [color:red][shake:0.55]deleted.\n\n\n\n\n\n\n\n\n[color:white]WARNING\nnan_spawn.lua is [color:red]missing!\n(IMPORTANT FILE)"
        end
        if Utils.startsWith(self.current_warning, "state_") then
            self.warning_state = Utils.sub(self.current_warning, utf8.len("state_")+1)
            self.current_warning = ""
        end
    else
        self.current_warning = "This game is still under active development. Some bugs or crashes may appear during your playing experience."
        Kristal.Config["seenLegitWarning"] = true
    end

    self.loading_dlcs = false

    self.animation_clock = -1
    self.active = false
    
    self.old_time = os.time()
end

function MainMenuWarning:registerEvents()
    self:registerEvent("enter", self.onEnter)
    self:registerEvent("leave", self.onLeave)
    self:registerEvent("keypressed", self.onKeyPressed)
    self:registerEvent("update", self.update)
    self:registerEvent("draw", self.draw)
end

function MainMenuWarning:update()
    if self.animation_clock > 2 then
        self.menu:setState("TITLE")
        self.menu.title_screen:selectOption("play")
        return
    elseif self.animation_clock >= 0 then
        self.animation_clock = self.animation_clock + DT
        self.container:setScale(Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0.2
        ), Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0.0
        ))
        self.alphafx.alpha = Utils.clampMap(
            self.animation_clock, 0, 1.3, 1, 0
        )
    end

    if self.warning_state == "SUBNAUTICA" then
        self:detecting_leviathans()
    end

    if self.warning_state == "CLOCK" then
        self:clock()
    end
end

function MainMenuWarning:onEnter()
    self.menu.music:pause()
	self.active = true
    local options = {align = "center"}
    self.container = self.menu.stage:addChild(Object(0,0,SCREEN_WIDTH, SCREEN_HEIGHT))
    self.alphafx = self.container:addFX(AlphaFX(1))
    self.container:setScaleOrigin(0.5, 0.5)
    self.text_warn = self.container:addChild(Text("asdf", 0, 115 + 30, options))
    self.text_warn.inherit_color = true
    self.text_contents = self.container:addChild(Text("", 0, 115 + 30*2, options))
    self.text_contents.inherit_color = true
    self.text_accept = self.container:addChild(Text("", 0, 115 + 30*5, options))
    self.text_accept.inherit_color = true
    self:updateTexts()
	self.menu.heart_target_x = -640
	self.menu.heart_target_y = 270
end

function MainMenuWarning:onLeave()
    self.menu.music:play()
	self.active = false
    self.container:remove()
    self.container = nil
end

function MainMenuWarning:updateTexts()
    self.text_warn:setText("WARNING")
    self.text_contents:setText(self.current_warning)

    if self.warning_state == "SUBNAUTICA" then
        self.subnautica = Assets.playSound("subnautica", 5)
    else
        self.text_accept:setText("Press "..Input.getText("confirm").. (Input.usingGamepad() and "" or " ").. "to accept.")
    end
end

function MainMenuWarning:onKeyPressed(key, is_repeat)

    if self.warning_state == "SUBNAUTICA" then --You have to wait through the whole thing :)

    else
        self:updateTexts()
	if Input.isConfirm(key) and not is_repeat and self.animation_clock < 0 then
	    Assets.stopAndPlaySound("ui_select")
	    Assets.stopAndPlaySound("ui_spooky_action")
            self.animation_clock = 0

            return true
        end
    end
end

function MainMenuWarning:draw()
    Draw.setColor(COLORS.black)
    Draw.rectangle("fill", 0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
end

function MainMenuWarning:detecting_leviathans()
        if self.subnautica then
            local foo = function (text) self.text_contents:setText(text) end

            local time = self.subnautica:tell()

            --Detecting multiple leviathan class lifeforms in the region.\nAre you certain whatever you're doing is worth it?

            if not self.last_time then self.last_time = time end

            if time < self.last_time then
                self.warning_state = ""
                self.text_accept:setText("Press "..Input.getText("confirm").. (Input.usingGamepad() and "" or " ").. "to accept.")
            elseif time > 5.5 then
                local text = "Detecting multiple leviathan class lifeforms in the region.\n Are"
		if time >= 7.9 then
            	    self.current_warning = text.. " you certain whatever you're doing is worth it?"
                    foo(text.. " you certain whatever you're doing is worth it?")
		elseif time >= 7.6 then
                    foo(text.. " you certain whatever you're doing is worth")
		elseif time >= 7.4 then
                    foo(text.. " you certain whatever you're doing is")
		elseif time >= 7 then
                    foo(text.. " you certain whatever you're doing")
		elseif time >= 6.8 then
                    foo(text.. " you certain whatever you're")
		elseif time >= 6.5 then
                    foo(text.. " you certain whatever")
		elseif time >= 5.85 then
                    foo(text.. " you certain")
		elseif time >= 5.6 then
                    foo(text.. " you")
		else
                    foo(text.. "")
		end
            else
		if time >= 4.5 then
                    foo("Detecting multiple leviathan class lifeforms in the region.")
		elseif time >= 4.3 then
                    foo("Detecting multiple leviathan class lifeforms in the")
		elseif time >= 4 then
                    foo("Detecting multiple leviathan class lifeforms in")
		elseif time >= 3.3 then
                    foo("Detecting multiple leviathan class lifeforms")
		elseif time >= 2.5 then
                    foo("Detecting multiple leviathan class")
		elseif time >= 1.8 then
                    foo("Detecting multiple leviathan")
		elseif time >= 1 then
                    foo("Detecting multiple")
		elseif time >= 0.5 then
                    foo("Detecting")
                end
            end

            self.last_time = time     
	end
end

function MainMenuWarning:clock()
    self.text_contents:setText(os.date("%X", os.time()))
    self.text_accept:setText("Press "..Input.getText("confirm").. (Input.usingGamepad() and "" or " ").. "to start.")
    
    if self.old_time ~= os.time() then
        self.old_time = os.time()
        Assets.playSound("graze")
    end
end

return MainMenuWarning
