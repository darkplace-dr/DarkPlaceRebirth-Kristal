local function getBind(name)
    if Input.usingGamepad() then
        return Input.getText(name)
    end
    return Input.getText(name) .. " "
end

---@type table<string, fun(cutscene:WorldCutscene, event: Event|NPC)>
local cliffside = {
    ---@param cutscene WorldCutscene
    intro = function (cutscene, event)
        Kristal.hideBorder(0)
        cutscene:wait(function ()
            if Game.world.map.id == [[floor1/dess_house]] then
                return true
            else
                return false
            end
        end)
        Game.fader:fadeIn { speed = 0 }
        Game.world.music:stop()
        local darknessoverlay = DarknessOverlay()
        darknessoverlay.layer = 1
        Game.world:addChild(darknessoverlay)
        local lightsource = LightSource(15, 28, 60)
        lightsource.alpha = 0.25
        Game.world.player:addChild(lightsource)

        local textobj = shakytextobject("Press " .. getBind("menu") .. "to open your menu.", 115, 405)
        textobj.layer = 2
        Game.world:addChild(textobj)


        local dess = cutscene:getCharacter("dess")
        dess:setSprite("battle/defeat_1")

        local function openMenulol(menu, layer)
            local self = Game.world
            if self.menu then
                self.menu:remove()
                self.menu = nil
            end

            if not menu then
                menu = self:createMenu()
            end

            self.menu = menu
            if self.menu then
                self.menu.layer = layer and self:parseLayer(layer) or WORLD_LAYERS["ui"]

                if self.menu:includes(AbstractMenuComponent) then
                    self.menu.close_callback = function ()
                        self:afterMenuClosed()
                    end
                elseif self.menu:includes(Component) then
                    -- Sigh... traverse the children to find the menu component
                    for _, child in ipairs(self.menu:getComponents()) do
                        if child:includes(AbstractMenuComponent) then
                            child.close_callback = function ()
                                self:afterMenuClosed()
                            end
                            break
                        end
                    end
                end

                self:addChild(self.menu)
                self:setState("MENU")
            end
            return self.menu
        end
        Game.tutorial = true


        --cutscene:text("* press c")

        cutscene:wait(function ()
            return Input.pressed("menu")
        end)
        openMenulol()
        --Game.world.menu:addChild()

        textobj:setText("Press " .. getBind("confirm") .. "to select the TALK option.")
        textobj.x, textobj.y = 10, 280


        cutscene:wait(function ()
            return Input.pressed("confirm")
        end)
        Assets.playSound("ui_select")
        textobj:setText ""

        Game.world:closeMenu()

        local choicer = cutscene:choicer({ "* Dess..." })
        if choicer == 1 then
            cutscene:wait(0.5)
            Game.stage.timer:tween(1, lightsource, { alpha = 0.50 })
            local wing = Assets.playSound("wing")
            Game.world.player:shake()
            cutscene:wait(1.5)
            wing:play()
            Game.world.player:shake()
            cutscene:wait(0.5)
            wing:stop()
            wing:play()
            Game.world.player:shake()
            lightsource.y = 25
            dess:setSprite("walk/right")
            cutscene:wait(2)
            cutscene:textTagged("* hello?", "neutral", "dess")
            local stime = 0.30
            cutscene:wait(stime)
            dess:setSprite("walk/up")
            cutscene:wait(stime)
            dess:setSprite("walk/left")
            cutscene:wait(stime)
            dess:setSprite("walk/down")
            cutscene:wait(stime)
            dess:setSprite("walk/right")
            cutscene:wait(0.75)

            cutscene:textTagged("* who tf is there", "neutral_b", "dess")

            textobj:setText "What will you do?"
            textobj.x, textobj.y = 200, 560

            local choicer = cutscene:choicer({ "Speak", "Do not" })
            textobj:setText ""
            if choicer == 1 then
                dess:setSprite("walk/down")
                cutscene:wait(0.75)
                cutscene:textTagged("* oh hey its the person who chose my name", "heckyeah", "dess")
                cutscene:textTagged("* welcome to [funnytext:dess_mode/dess_mode,mode,0,0,152,28] ", "swag", "dess") -- apparently you need an extra character at the end for the funnytext to work properly. huh.
                if Game:isSpecialMode("i can literally put anything in this check and it behaves as expected since dess mode doesn't apply in EVERYCHALLEN") then
                    cutscene:textTagged("* specifically nightmare mode[font:main_mono,16]TM[font:reset] ", "doom_shiteatinggrin", "dess")
                end
                cutscene:textTagged("* where im the main character and you only get to play as ME", "heckyeah", "dess")
                if Game:isSpecialMode("warning overkill attack!!!") then
                    cutscene:textTagged("* and also the game is blatantly unfair", "doom_shiteatinggrin", "dess")
                end
                cutscene:textTagged("* if your playing this on the day this came out then merry krismas", "challenging", "dess")
                cutscene:textTagged("* if not then uhhh idk", "neutral_b", "dess")
                cutscene:textTagged("* ok where tf did wing gaster put me", "angry", "dess")
            elseif choicer == 2 then
                cutscene:wait(2)
                cutscene:textTagged("* hello?", "neutral", "dess")

                cutscene:wait(4)

                cutscene:textTagged("* damn guess im hearing voices again", "mspaint", "dess")

                cutscene:wait(0.5)
                dess:setFacing("up")
                dess:resetSprite()
                cutscene:wait(0.5)

                cutscene:textTagged("* where tf am i tho", "annoyed", "dess")
            end
            dess:resetSprite()
            Game.stage.timer:tween(1, lightsource, { radius = 900 })
            Game.stage.timer:tween(1, lightsource, { alpha = 1 })
            Kristal.showBorder(1.5)
            cutscene:wait(1.5)
            cutscene:textTagged("* man when tf is someone gonna finish my house", "angy", "dess")
            cutscene:textTagged("* you could call it a myhouse.wad", "doom_shiteatinggrin", "dess")
            Game.world.music:play()
            Game.world:spawnObject(MusicLogo("Our Castle Town", 30, 20), WORLD_LAYERS["ui"])
        elseif choicer == 2 then

        end





        cutscene:wait(function ()
            if lightsource.alpha >= 0.95 or lightsource.radius >= 890 then
                return true
            else
                return false
            end
        end)
        Game.tutorial = nil
        darknessoverlay:remove()
    end,
}
return cliffside
