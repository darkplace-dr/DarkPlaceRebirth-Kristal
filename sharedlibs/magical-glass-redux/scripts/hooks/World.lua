local World, super = HookSystem.hookScript(World)

function World:mapTransition(...)
    super.mapTransition(self, ...)

    Mod.libs["magical-glass"].map_transitioning = true
    Mod.libs["magical-glass"].steps_until_encounter = nil
    if Mod.libs["magical-glass"].initiating_random_encounter then
        Game.lock_movement = false
        Mod.libs["magical-glass"].initiating_random_encounter = nil
    end
end

function World:loadMap(...) -- Punch Card Exploit Emulation
    if Mod.libs["magical-glass"].exploit then
        self:stopCutscene()
    end

    super.loadMap(self, ...)

    Mod.libs["magical-glass"].map_transitioning = false
    if Mod.libs["magical-glass"].viewing_image == 2 then
        for _, chara in ipairs(Game.world:getPlayerAndFollowers()) do
            chara:setPosition(self.map:getMarker("spawn"))
        end
    elseif Mod.libs["magical-glass"].viewing_image == 1 then
        Game.lock_movement = false
    end
    Mod.libs["magical-glass"].viewing_image = 0
end

function World:showHealthBars()
    if Game:isLight() then
        if self.healthbar then
            self.healthbar:transitionIn()
        else
            self.healthbar = LightHealthBar()
            self.healthbar.layer = WORLD_LAYERS["ui"] + 1
            self:addChild(self.healthbar)
        end
    else
        super.showHealthBars(self)
    end
end

-- Replaces a phone call in the Light World CELL menu with another
function World:replaceCall(replace_name, name, scene)
    for i, call in ipairs(self.calls) do
        if call[1] == replace_name then
            self.calls[i] = {name, scene}
            break
        end
    end
end

-- Removes a phone call in the Light World CELL menu
function World:removeCall(name)
    for i, call in ipairs(self.calls) do
        if call[1] == name then
            table.remove(self.calls, i)
            break
        end
    end
end

-- Removes all the phone calls in the Light World CELL menu
function World:clearCalls()
    self.calls = {}
end

function World:lightShopTransition(shop, options)
    self:fadeInto(function()
        Mod.libs["magical-glass"]:enterLightShop(shop, options)
    end)
end

function World:spawnBullet(bullet, ...)
    local check_world_bullet
    if type(bullet) == "string" then
        check_world_bullet = Registry.getWorldBullet(bullet)
    else
        check_world_bullet = bullet
    end

    if check_world_bullet:includes(LightWorldBullet) then
        error("Attempted to use LightWorldBullet in a WorldBullet. Convert the world bullet \"" .. check_world_bullet.id .. "\" file to a WorldBullet")
    end

    return super.spawnBullet(self, bullet, ...)
end

function World:spawnLightBullet(bullet, ...)
    local check_world_bullet
    if type(bullet) == "string" then
        check_world_bullet = Mod.libs["magical-glass"]:getLightWorldBullet(bullet)
    else
        check_world_bullet = bullet
    end

    if not check_world_bullet:includes(LightWorldBullet) then
        error("Attempted to use WorldBullet in a LightWorldBullet. Convert the world bullet \"" .. check_world_bullet.id .. "\" file to a LightWorldBullet")
    end

    local new_bullet
    if isClass(bullet) and bullet:includes(LightWorldBullet) then
        new_bullet = bullet
    elseif Mod.libs["magical-glass"]:getLightWorldBullet(bullet) then
        new_bullet = Mod.libs["magical-glass"]:createLightWorldBullet(bullet, ...)
    else
        local x, y = ...
        table.remove(arg, 1)
        table.remove(arg, 1)
        new_bullet = LightWorldBullet(x, y, bullet, unpack(arg))
    end
    new_bullet.layer = WORLD_LAYERS["bullets"]
    new_bullet.world = self
    table.insert(self.bullets, new_bullet)
    if not new_bullet.parent then
        self:addChild(new_bullet)
    end

    return new_bullet
end

function World:onKeyPressed(key)
    super.onKeyPressed(self, key)

    if Kristal.isDevMode() and Input.ctrl() then
        if key == "s" and Game:isLight() then
            -- close the old one
            self.menu:remove()
            self:closeMenu()

            local save_pos = nil
            if Input.shift() then
                save_pos = {self.player.x, self.player.y}
            end
            if Kristal.getLibConfig("magical-glass", "savepoint_style") ~= "undertale" then
                self:openMenu(LightSaveMenu(save_pos))
            elseif not Kristal.getLibConfig("magical-glass", "light_save_menu_expanded") then
                self:openMenu(LightSaveMenuNormal(Game.save_id, save_pos))
            else
                self:openMenu(LightSaveMenuExpanded(save_pos))
            end
        end
    end
end

function World:heal(target, amount, text, item)
    if Game:isLight() then
        Mod.libs["magical-glass"].heal_amount = amount

        if type(target) == "string" then
            target = Game:getPartyMember(target)
        end

        local maxed = target:heal(amount, false)
        if text and item and item.getLightWorldHealingText and item:getLightWorldHealingText(target, amount, maxed) then
            if type(text) == "table" then
                text[#text] = text[#text] .. (text[#text] ~= "" and "\n" or "") .. item:getLightWorldHealingText(target, amount, maxed)
            else
                text = text .. (text ~= "" and "\n" or "") .. item:getLightWorldHealingText(target, amount, maxed)
            end
        end

        if text then
            if not Game.world:hasCutscene() then
                Game.world:showText(text)
            end
        else
            Assets.stopAndPlaySound("power")
        end
    else
        super.heal(self, target, amount, text)
    end
end

function World:spawnPlayer(...)
    super.spawnPlayer(self, ...)

    if Game.party[1]:getUndertaleMovement() then
        local old_player = TableUtils.copy(self.player, false)
        self.player:remove()
        self.player = UnderPlayer(old_player.actor, old_player.x, old_player.y)
        self.player.layer = old_player.layer
        self.player:setFacing(old_player.facing)
        self.player.party = old_player.party
        self:addChild(self.player)
    end
end

return World