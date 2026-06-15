---@class World : Class
---@field world_caster          PartyMember|nil           The party member that is casting a spell in the overworld.
local World, super = HookSystem.hookScript(World)

function World:init(map)
    super.init(self, map)

    self.world_caster = nil
end

--[[function World:onKeyPressed(key)
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
            if Game:getConfig("smallSaveMenu") then
                self:openMenu(SimpleSaveMenu(Game.save_id, save_pos))
            elseif Game:isLight() then
                self:openMenu(LightSaveMenu(save_pos))
            else
                self:openMenu(SaveMenu(save_pos))
            end
        end
        if key == "h" then
            for _,party in ipairs(Game.party) do
                party:heal(math.huge)
            end
        end
        if key == "p" then
            for _,party in ipairs(Game.party) do
                if party:usesMana() then
                    party:regenMana(math.huge)
                end
            end
        end
        if key == "b" then
            if Input.shift() then
                Game.world:hurtParty(20)
            else
                Game.world:hurtParty(math.huge)
            end
        end
        if key == "l" then
            for _,party in ipairs(Game.party) do
                party:setMana(0)
                Assets.stopAndPlaySound("PMD2_PP_Down", 0.7)
            end
        end
        if key == "k" then
            Game:setTension(Game:getMaxTension() * 2, true)
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
end]]

--- Regenerate mana for a party member
---@param target    string|PartyMember  The party member to regen
---@param amount    number              The amount of MP to restore
---@param text?     string              An optional text to display when MP is resotred in the Light World, before the MP restoration message
function World:regenMana(target, amount, text)
    if type(target) == "string" then
        target = Game:getPartyMember(target)
    end

    local success = false
    local maxed = false
    if target:usesMana() then
        success = true
        maxed = target:regenMana(amount)
    end

    if Game:isLight() then
        local message
        if maxed and success then
            message = "* Your MP was maxed out."
        elseif not maxed and success then
            message = "* You recovered "..amount.." MP!"
        else
            message = "* No MP to recover..."
        end
        if text then
            message = text.." \n"..message
        end
        Game.world:showText(message)
    elseif self.healthbar then
        for _, actionbox in ipairs(self.healthbar.action_boxes) do
            if actionbox.chara.id == target.id then
                local text = MPText("+" .. amount, self.healthbar.x + actionbox.x + 69, self.healthbar.y + actionbox.y - 10, target.mana_message_color)
                text.layer = WORLD_LAYERS["ui"] + 1
                Game.world:addChild(text)
                return
            end
        end
    end
end

--- Depletes the party member `battler` by `amount`, or hurts the whole party for `amount`
---@overload fun(self: World, amount: number)
---@param battler   Character|string    The Character to hurt
---@param amount    number              The amount of damage to deal
---@return boolean  broke  Whether all targetted characters had all thier mana completely depleted
function World:depleteManaParty(battler, amount)
    Assets.playSound("pmd2_pp_down", 0.6)

    self:shakeCamera()
    self:showHealthBars()

    if type(battler) == "number" then
        amount = battler
        battler = nil
    end

    local any_drained = false
    local any_left_with = false
    for _, party in ipairs(Game.party) do
        if not battler or battler == party.id or battler == party then
            local current_mana = 0
            if party:usesMana() then
                current_mana = party:getMana()
                party:setMana(party:getMana() - amount)
                if party:getMana() <= 0 then
                    if not Kristal.getLibConfig("ManaHealthResources", "negative_mana") then
                        party:setMana(0)
                    end
                    any_drained = true
                else
                    any_left_with = true
                end
            end

            local drained_amount = current_mana - party:getMana()

            for _, char in ipairs(self.stage:getObjects(Character)) do
                if char.actor and (char.actor.id == party:getActor().id) and drained_amount > 0 then
                    char:statusMessageMana("damage", -drained_amount, char:getPartyMember():getManaMessageColor())
                end
            end
        elseif party:getMana() > amount then
            any_left_with = true
        end
    end

    if self.player then
        self.player.hurt_timer = 7
    end

    if any_drained and not any_left_with then
        --[[if not self.map:onGameOver() then
            Game:gameOver(self.soul:getScreenPos())
        end]]
        return true
    elseif battler then
        return any_drained
    end

    return false
end

--- Sets the world caster
---@param caster    PartyMember|nil    The party member that is casting, if any
function World:setWorldCaster(caster)
    self.world_caster = caster
end

---@return PartyMember|nil
function World:getWorldCaster()
    return self.world_caster
end

return World