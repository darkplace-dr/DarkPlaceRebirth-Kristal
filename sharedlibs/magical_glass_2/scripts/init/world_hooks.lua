--[[ Utils.hook(World, "lightShopTransition", function(orig, self, shop, options)
    self:fadeInto(function()
        MagicalGlass:enterLightShop(shop, options)
    end)
end) ]]

Utils.hook(World, "spawnPlayer", function(orig, self, ...)
    local args = {...}

    local x, y = 0, 0
    local chara = self.player and self.player.actor
    if #args > 0 then
        if type(args[1]) == "number" then
            x, y = args[1], args[2]
            chara = args[3] or chara
        elseif type(args[1]) == "string" then
            x, y = self.map:getMarker(args[1])
            chara = args[2] or chara
        end
    end

    if type(chara) == "string" then
        chara = Registry.createActor(chara)
    end

    local facing = "down"

    if self.player then
        facing = self.player.facing
        self:removeChild(self.player)
    end
    if self.soul then
        self:removeChild(self.soul)
    end
    
    if Game.party[1].undertale_movement then
        self.player = UnderPlayer(chara, x, y)
    else
        self.player = Player(chara, x, y)
    end
    self.player.layer = self.map.object_layer
    self.player:setFacing(facing)
    self:addChild(self.player)

    self.soul = OverworldSoul(self.player:getRelativePos(self.player.actor:getSoulOffset()))
    self.soul:setColor(Game:getSoulColor())
    self.soul.layer = WORLD_LAYERS["soul"]
    self:addChild(self.soul)

    if self.camera.attached_x then
        self.camera:setPosition(self.player.x, self.camera.y)
    end
    if self.camera.attached_y then
        self.camera:setPosition(self.camera.x, self.player.y - (self.player.height * 2)/2)
    end
end)

Utils.hook(World, "heal", function(orig, self, target, amount, text, item)
    if type(target) == "string" then
        target = Game:getPartyMember(target)
    end
    
    if Game:isLight() then
        local maxed = target:heal(amount, false)
        local message
        if item and item.getLightWorldHealingText then
            message = item:getLightWorldHealingText(target, amount, maxed)
        else
            if target.you and maxed then
                message = "* Your HP was maxed out."
            elseif maxed then
                message = "* " .. target:getNameOrYou() .. "'s HP was maxed out."
            else
                message = "* " .. target:getNameOrYou() .. " recovered " .. amount .. " HP!"
            end
        end

        if text then
            message = text .. " \n" .. message
        end
        
        if not Game.world:hasCutscene() then
            Game.world:showText(message)
        end
    else
        orig(self, target, amount, text)
    end
end)

if not Mod.libs["widescreen"] then
    Utils.hook(WorldCutscene, "text", function(orig, self, text, portrait, actor, options)
        local function waitForTextbox(self) return not self.textbox or self.textbox:isDone() end
        if type(actor) == "table" and not isClass(actor) then
            options = actor
            actor = nil
        end
        if type(portrait) == "table" then
            options = portrait
            portrait = nil
        end
    
        options = options or {}
    
        self:closeText()
    
        local width, height = 529, 103
        if Game:isLight() then
            width, height = 530, 104
        end
    
        if (Game:isLight() and MagicalGlass:getConfig("lightWorldUndertaleText")) or options["undertext"] then
            self.textbox = UnderTextbox(56, 344, width, height)
        else
            self.textbox = Textbox(56, 344, width, height)
        end
        self.textbox.layer = WORLD_LAYERS["textbox"]
        self.world:addChild(self.textbox)
        self.textbox:setParallax(0, 0)
    
        if type(actor) == "string" then
            actor = self:getCharacter(actor) or actor
        end    

        local speaker = self.textbox_speaker
        if not speaker and isClass(actor) and actor:includes(Character) then
            speaker = actor.sprite
        end
    
        if options["talk"] ~= false then
            self.textbox.text.talk_sprite = speaker
        end
    
        actor = actor or self.textbox_actor
        if isClass(actor) and actor:includes(Character) then
            actor = actor.actor
        end
        if actor then
            self.textbox:setActor(actor)
        end
    
        if options["top"] == nil and self.textbox_top == nil then
            local _, player_y = Game.world.player:localToScreenPos()
            options["top"] = player_y > 260
        end
        if options["top"] or (options["top"] == nil and self.textbox_top) then
        local bx, by = self.textbox:getBorder()
        self.textbox.y = by + 2
        end
    
        self.textbox.active = true
        self.textbox.visible = true
        self.textbox:setFace(portrait, options["x"], options["y"])
    
        if options["reactions"] then
            for id,react in pairs(options["reactions"]) do
                self.textbox:addReaction(id, react[1], react[2], react[3], react[4], react[5])
            end
        end
    
        if options["functions"] then
            for id,func in pairs(options["functions"]) do
                self.textbox:addFunction(id, func)
            end
        end
    
        if options["font"] then
            if type(options["font"]) == "table" then
                self.textbox:setFont(options["font"][1], options["font"][2])
            else
                self.textbox:setFont(options["font"])
            end
        end
    
        if options["align"] then
            self.textbox:setAlign(options["align"])
        end
    
        self.textbox:setSkippable(options["skip"] or options["skip"] == nil)
        self.textbox:setAdvance(options["advance"] or options["advance"] == nil)
        self.textbox:setAuto(options["auto"])
    
        if false then -- future feature
            self.textbox:setText("[wait:2]"..text, function()
                self.textbox:remove()
                self:tryResume()
            end)
        else
            self.textbox:setText(text, function()
                self.textbox:remove()
                self:tryResume()
            end)
        end
    
        local wait = options["wait"] or options["wait"] == nil
        if not self.textbox.text.can_advance then
            wait = options["wait"] -- By default, don't wait if the textbox can't advance
        end
    
        if wait then
            return self:wait(waitForTextbox)
        else
            return waitForTextbox, self.textbox
        end
    end)
end

Utils.hook(World, "onKeyPressed", function(orig, self, key)
    if Kristal.Config["debug"] and Input.ctrl() then
        if key == "m" then
            if self.music then
                if self.music:isPlaying() then
                    self.music:pause()
                else
                    self.music:resume()
                end
            end
        end
        if key == "s" then
            local save_pos = nil
            if Input.shift() then
                save_pos = {self.player.x, self.player.y}
            end
            if Game:isLight() then
                if MagicalGlass.advanced_save_menu then
                    self:openMenu(LightAdvancedSaveMenu(self.marker))
                else
                    self:openMenu(LightSaveMenu(Game.save_id, self.marker))
                end
            else
                if Game:getConfig("smallSaveMenu") then
                    self:openMenu(SimpleSaveMenu(Game.save_id, save_pos))
                else
                    self:openMenu(SaveMenu(save_pos))
                end
            end
        end
        if key == "n" then
            NOCLIP = not NOCLIP
        end
    end

    if Game.lock_movement then return end

    if self.state == "GAMEPLAY" then
        if Input.isConfirm(key) and self.player and not self:hasCutscene() then
            if self.player:interact() then
                Input.clear("confirm")
            end
        elseif Input.isMenu(key) and not self:hasCutscene() then
            self:openMenu(nil, WORLD_LAYERS["ui"] + 1)
            Input.clear("menu")
        end
    elseif self.state == "MENU" then
        if self.menu and self.menu.onKeyPressed then
            self.menu:onKeyPressed(key)
        end
    end
end)