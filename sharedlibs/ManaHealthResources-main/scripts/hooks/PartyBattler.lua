---@class PartyBattler : Class
local PartyBattler, super = HookSystem.hookScript(PartyBattler)


-----------------Hooked Functions------------------

---@param amount    number  The damage of the incoming hit
---@param exact?    boolean Whether the damage should be treated as exact damage instead of applying defense and element modifiers
---@param color?    table   The color of the damage number
---@param options?  table   A table defining additional properties to control the way damage is taken
---|"all"   # Whether the damage being taken comes from a strike targeting the whole party
---|"swoon" # Whether the damage should swoon the battler instead of downing them
---|"msg"   # Whether to show the damage messages   (defaults to `true`)
---|"anim"  # Whether to show the hurt animation    (defaults to `true`)
function PartyBattler:hurt(amount, exact, color, options)
    options = options or {}

    if options["msg"] == nil then
        options["msg"] = true
    end
    if options["anim"] == nil then
        options["anim"] = true
    end

    local swoon = options["swoon"]

    if not options["all"] then
        Assets.playSound("hurt")
        if not exact then
            amount = self:calculateDamage(amount)
            if self.defending then
                amount = math.ceil((2 * amount) / 3)
            end
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))
        end

        self:removeHealth(amount, swoon)
    else
        -- We're targeting everyone.
        if not exact then
            amount = self:calculateDamage(amount)
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))

            if self.defending then
                amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
            end
        end

        self:removeHealthBroken(amount, swoon) -- Use a separate function for cleanliness
    end

    if options["msg"]  then
        if (self.chara:getHealth() <= 0) then
            self:statusMessage("msg", swoon and "swoon" or "down", color, true)
        else
            self:statusMessage("damage", amount, color, true)
        end
    end

    if options["anim"] then
        self.hurt_timer = 0
        Game.battle:shakeCamera(4)
    end

    if (not self.defending) and (not self.is_down) and options["anim"] then
        self.sleeping = false
        self.hurting = true
        self:toggleOverlay(true)
        self.overlay_sprite:setAnimation("battle/hurt", function()
            if self.hurting then
                self.hurting = false
                self:toggleOverlay(false)
            end
        end)
        if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
            Game.battle.timer:after(0.5, function()
                if self.hurting then
                    self.hurting = false
                    self:toggleOverlay(false)
                end
            end)
        end
    end
end

---------------------------------------------------

--Prevents mana from going below 0 if `ManaHealthResources.negative_mana` is `false`
function PartyBattler:checkMana()
    if self.chara:getMana() <= 0 and not Kristal.getLibConfig("ManaHealthResources", "negative_mana") then
        self.chara:setMana(0)
    end
end

---@param amount    number  The damage of the incoming hit
---@param exact?    boolean Whether the damage should be treated as exact damage instead of applying defense and element modifiers
---@param color?    table   The color of the damage number
---@param options?  table   A table defining additional properties to control the way damage is taken
---|"all"   # Whether the damage being taken comes from a strike targeting the whole party
function PartyBattler:depleteMana(amount, exact, color, options)
    options = options or {}

    if not options["all"] then
        Assets.stopAndPlaySound("pmd2_pp_down", 0.6)
        if not exact then
            amount = self:calculateDamage(amount)
            if self.defending then
                amount = math.ceil((2 * amount) / 3)
            end
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))
        end

        if self.chara:usesMana() then
            self:removeMana(amount)
        else
            self:removeMana(0)
        end
    else
        -- We're targeting everyone.
        if not exact then
            amount = self:calculateDamage(amount)
            -- we don't have elements right now
            local element = 0
            amount = math.ceil((amount * self:getElementReduction(element)))

            if self.defending then
                amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
            end
        end

        if self.chara:usesMana() then
            self:removeMana(amount)
        else
            self:removeMana(0)
        end
    end

    if (self.chara:getMana() <= 0) then
        --self:statusMessage("msg", swoon and "swoon" or "down", color, true)
    --else
        self:statusMessage("damage", -amount, color or self.chara:getManaMessageColor(), true)
    end

    self.hurt_timer = 0
    Game.battle:shakeCamera(4)

    if (not self.defending) and (not self.is_down) then
        self.sleeping = false
        self.hurting = true
        self:toggleOverlay(true)
        self.overlay_sprite:setAnimation("battle/hurt", function()
            if self.hurting then
                self.hurting = false
                self:toggleOverlay(false)
            end
        end)
        if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
            Game.battle.timer:after(0.5, function()
                if self.hurting then
                    self.hurting = false
                    self:toggleOverlay(false)
                end
            end)
        end
    end
end

--- Removes MP from the character
---@param amount number
function PartyBattler:removeMana(amount)
    --[[if (self.chara:getMana() <= 0) and not ManaHealthResources.negative_mana then
        self.chara:setMana(0)
    else]]
        self.chara:setMana(self.chara:getMana() - amount)
    --end
    self:checkMana()
end

--- Heals the Battler by `amount` mana and does healing effects
---@param amount            number  The amount of mana to restore
---@param sparkle_color?    table   The color of the heal sparkles (defaults to the standard green)
function PartyBattler:regenMana(amount, sparkle_color)
    Assets.stopAndPlaySound("pmd2_pp_up", 0.6)

    amount = math.floor(amount)

    self.chara:setMana(self.chara:getMana() + amount)

    self:flash()

    if self.chara:usesMana() and self.chara:getMana() >= self.chara:getStat("mana") then
        self.chara:setMana(self.chara:getStat("mana"))
        self:statusMessageMana("msg", "max_white", self.chara:getManaMessageColor(), nil, 8)
        --self:statusMessage("heal", amount)
    elseif not self.chara:usesMana() then
        self:statusMessageMana("regen", 0, self.chara:getManaMessageColor())
    else
        self:statusMessageMana("regen", amount, self.chara:getManaMessageColor())
    end

    self:sparkle(unpack(sparkle_color or self.chara:getManaSparkleColor()))
end

function PartyBattler:statusMessageMana(...)    --Offset for cleanliness
    local message = super.super.statusMessage(self, 0, (self.height/2) - 10, ...)
    message.y = message.y - 24
    return message
end

return PartyBattler
