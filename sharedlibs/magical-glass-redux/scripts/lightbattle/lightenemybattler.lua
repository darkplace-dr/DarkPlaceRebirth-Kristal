local LightEnemyBattler, super = Class(Battler)

function LightEnemyBattler:init(actor, use_overlay)
    super.init(self)
    self.name = "Test Enemy"

    if actor then
        self:setActor(actor, use_overlay)
    end

    self.max_health = 100
    self.health = 100
    self.attack = 1
    self.defense = 0

    self.money = 0
    self.experience = 0

    self.tired = false
    self.mercy = 0

    self.spare_points = 0

    -- Whether the enemy runs/slides away when defeated/spared
    self.exit_on_defeat = true

    -- Whether this enemy is automatically spared at full mercy
    self.auto_spare = false

    -- Whether this enemy can be frozen or die, and whether it's the Undertale death or Deltarune death
    self.can_freeze = true
    self.can_die = true
    self.ut_death = true

    -- Whether this enemy should use bigger dust particles upon death when ut_death is enabled.
    self.large_dust = false
    
    -- Whether this enemy damage numbers acts like an amalgamate when hit
    -- If a table of strings, the messages will be them instead of the default ones
    self.special_messages = false
    
    -- Play the "damage" sound even when you deal 0 damage
    self.always_play_damage_sound = false
    
    -- Whether the enemy will shake when it takes damage
    self.can_shake = true

    -- Whether this enemy can be selected or not
    self.selectable = true
    
    -- Whether selecting the enemy using SAVE will skip the turn (similar to the end of the Asirel fight in UT)
    self.save_no_acts = false
    
    -- Whether this enemy display name will have a wavy-rainbow effect like Asriel Dreemurr
    self.rainbow_name = false
    
    -- The the enemy's damage sprites
    self.dmg_sprites = {}
    -- The offset of this enemy's damage sprites
    self.dmg_sprite_offset = {0, 0}

    -- Whether mercy is disabled for this enemy, like snowgrave Spamton NEO.
    -- This only affects the visual mercy bar.
    self.disable_mercy = false

    self.done_state = nil

    self.waves = {}
    self.menu_waves = {}

    self.check = "Remember to change\nyour check text!"

    self.text = {}

    self.low_health_text = nil
    self.tired_text = nil
    self.spareable_text = nil

    self.tired_percentage = 0
    self.spare_percentage = 0.25
    self.low_health_percentage = 0.25

    -- Speech bubble style - defaults to "round" or "cyber", depending on chapter
    -- This is set to nil in `battler.lua` as well, but it's here for completion's sake.
    self.dialogue_bubble = "ut_round"

    -- The offset for the speech bubble, also set in `battler.lua`
    self.dialogue_offset = {0, 0}

    -- Whether the speech bubble should be flipped horizontally.
    self.dialogue_flip = true

    self.dialogue = {}

    self.acts = {
        {
            ["name"] = "Check",
            ["description"] = "",
            ["party"] = {}
        }
    }

    self.hurt_timer = 0
    self.comment = ""
    self.icons = {}
    self.defeated = false
    
    self.active_msg = 0
    self.light_hit_count = 0
    self.x_number_offset = 0

    self.current_target = "ANY"

    self.gauge_size = 100
    self.damage_offset = {5, -40}

    self.show_hp = true
    self.show_mercy = true
end

function LightEnemyBattler:getMoney()
    return self.money
end

function LightEnemyBattler:toggleOverlay(overlay, reset)
    if overlay == nil then
        overlay = self.sprite.visible
    end
    if reset then
        self.sprite:resetSprite()
        self.overlay_sprite:resetSprite()
    end
    if self.overlay_sprite then
        self.overlay_sprite.visible = overlay
        self.sprite.visible = not overlay
    end
end

function LightEnemyBattler:getGaugeSize()
    if type(self.gauge_size) == "number" then
        return {self.gauge_size, 13}
    elseif type(self.gauge_size) == "table" then
        return self.gauge_size
    end
end
function LightEnemyBattler:getDamageOffset() return self.damage_offset end

function LightEnemyBattler:getHPVisibility() return self.show_hp end
function LightEnemyBattler:getMercyVisibility() return self.show_mercy end

function LightEnemyBattler:setTired(bool)
    self.tired = bool
    if self.tired then
        self.comment = "(Tired)"
    else
        self.comment = ""
    end
end

function LightEnemyBattler:registerAct(name, description, party, tp, highlight, icons)
    if type(party) == "string" then
        if party == "all" then
            party = {}
            for _,chara in ipairs(Game.party) do
                table.insert(party, chara.id)
            end
        else
            party = {party}
        end
    end
    local act = {
        ["character"] = nil,
        ["name"] = name,
        ["description"] = description,
        ["party"] = party,
        ["tp"] = tp or 0,
        ["highlight"] = highlight,
        ["short"] = false,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
    return act
end

function LightEnemyBattler:registerShortAct(name, description, party, tp, highlight, icons)
    if type(party) == "string" then
        if party == "all" then
            party = {}
            for _,battler in ipairs(Game.battle.party) do
                table.insert(party, battler.id)
            end
        else
            party = {party}
        end
    end
    local act = {
        ["character"] = nil,
        ["name"] = name,
        ["description"] = description,
        ["party"] = party,
        ["tp"] = tp or 0,
        ["highlight"] = highlight,
        ["short"] = true,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
    return act
end

function LightEnemyBattler:registerActFor(char, name, description, party, tp, highlight, icons)
    if type(party) == "string" then
        if party == "all" then
            party = {}
            for _,chara in ipairs(Game.party) do
                table.insert(party, chara.id)
            end
        else
            party = {party}
        end
    end
    local act = {
        ["character"] = char,
        ["name"] = name,
        ["description"] = description,
        ["party"] = party,
        ["tp"] = tp or 0,
        ["highlight"] = highlight,
        ["short"] = false,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
end

function LightEnemyBattler:registerShortActFor(char, name, description, party, tp, highlight, icons)
    if type(party) == "string" then
        if party == "all" then
            party = {}
            for _,battler in ipairs(Game.battle.party) do
                table.insert(party, battler.id)
            end
        else
            party = {party}
        end
    end
    local act = {
        ["character"] = char,
        ["name"] = name,
        ["description"] = description,
        ["party"] = party,
        ["tp"] = tp or 0,
        ["highlight"] = highlight,
        ["short"] = true,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
end

function LightEnemyBattler:removeAct(name)
    for i,act in ipairs(self.acts) do
        if act.name == name then
            table.remove(self.acts, i)
            break
        end
    end
end

function LightEnemyBattler:spare(pacify)
    if self.exit_on_defeat then
        self:toggleOverlay(true)
        self.alpha = 0.5
        Game.battle.spare_sound:stop()
        Game.battle.spare_sound:play()

        for i = 0, 15 do
            local x = ((Utils.random((self.width / 2)) + (self.width / 4))) - 8
            local y = ((Utils.random((self.height / 2)) + (self.height / 4))) - 8

            local sx, sy = self:getRelativePos(x, y)

            local dust = SpareDust(sx, sy)
            self.parent:addChild(dust)

            dust.rightside = ((8 + x)) / (self.width / 2)
            dust.topside = ((8 + y)) / (self.height / 2)

            Game.battle.timer:after(1/30, function()
                dust:spread()
            end)

            dust.layer = BATTLE_LAYERS["above_ui"] + 3
        end
        
        self:defeat(pacify and "PACIFIED" or "SPARED", false)
    end

    self:onSpared()
end

function LightEnemyBattler:getSpareText(battler, success)
    if success then
        return "* " .. battler.chara:getNameOrYou() .. " spared " .. self.name .. "."
    else
        local text = "* " .. battler.chara:getNameOrYou() .. " spared " .. self.name .. ".\n* But its name wasn't [color:"..Utils.rgbToHex(MagicalGlassLib.spare_color).."]"..MagicalGlassLib.spare_color_name.."[color:reset]..."
        if self.tired then
            local found_spell = nil
            for _,party in ipairs(Game.battle.party) do
                for _,spell in ipairs(party.chara:getSpells()) do
                    if spell:hasTag("spare_tired") then
                        found_spell = spell
                        break
                    end
                end
                if found_spell then
                    text = {text, "* (Try using "..party.chara:getName().."'s [color:blue]"..found_spell:getCastName().."[color:reset].)"}
                    break
                end
            end
            if not found_spell then
                text = {text, "* (Try using [color:blue]ACTs[color:reset].)"}
            end
        end
        return text
    end
end

function LightEnemyBattler:canSpare()
    return self.mercy >= 100
end

function LightEnemyBattler:onSpared()
    if self.actor.use_light_battler_sprite then
        if self.actor:getAnimation("lightbattle_spared") then
            self.overlay_sprite:setAnimation("lightbattle_spared")
        else
            self.overlay_sprite:setAnimation("lightbattle_hurt")
        end
    else
        self.overlay_sprite:setAnimation("spared")
    end
end

function LightEnemyBattler:onSpareable() end

function LightEnemyBattler:addMercy(amount)
    
    if (amount >= 0 and self.mercy >= 100) or (amount < 0 and self.mercy <= 0) then
        -- We're already at full mercy and trying to add more; do nothing.
        -- Also do nothing if trying to remove from an empty mercy bar.
        return
    end
    
    if Kristal.getLibConfig("magical-glass", "mercy_messages") and self:getMercyVisibility() then
        if amount == 0 then
            self:lightStatusMessage("msg", "miss", COLORS.silver)
        else
            if amount > 0 then
                local pitch = 0.8
                if amount < 99 then pitch = 1 end
                if amount <= 50 then pitch = 1.2 end
                if amount <= 25 then pitch = 1.4 end

                local src = Assets.playSound("mercyadd", 0.8)
                src:setPitch(pitch)
            end

            self:lightStatusMessage("mercy", amount)
        end
    end

    self.mercy = self.mercy + amount
    if self.mercy < 0 then
        self.mercy = 0
    end

    if self.mercy >= 100 then
        self.mercy = 100
    end

    if self:canSpare() then
        self:onSpareable()
        if self.auto_spare then
            self:spare(false)
        end
    end

end

function LightEnemyBattler:onMercy(battler)
    if not self.done_state then
        if self:canSpare() then
            self:spare()
            return true
        else
            if self.spare_points ~= 0 or Kristal.getLibConfig("magical-glass", "multi_deltarune_spare") and Game.battle.multi_mode then
                self:addMercy(self.spare_points)
            end
            return false
        end
    end
end

function LightEnemyBattler:onSave(battler) end

function LightEnemyBattler:getNameColors()
    local result = {}
    if self:canSpare() then
        table.insert(result, MagicalGlassLib.spare_color)
    end
    if self.tired then
        table.insert(result, {0, 0.7, 1})
    end
    return result
end

function LightEnemyBattler:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        return self.spareable_text
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    return Utils.pick(self.text)
end

function LightEnemyBattler:getTarget()
    return Game.battle:randomTarget()
end

function LightEnemyBattler:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end
    return Utils.pick(self.dialogue)
end

function LightEnemyBattler:getNextWaves()
    if self.wave_override then
        local wave = self.wave_override
        self.wave_override = nil
        return {wave}
    end
    return self.waves
end

function LightEnemyBattler:getNextMenuWaves()
    if self.menu_wave_override then
        local wave = self.menu_wave_override
        return {wave}
    end
    return self.menu_waves
end

function LightEnemyBattler:selectWave()
    local waves = self:getNextWaves()
    if waves and #waves > 0 then
        local wave = Utils.pick(waves)
        self.selected_wave = wave
        return wave
    end
end

function LightEnemyBattler:selectMenuWave()
    local waves = self:getNextMenuWaves()
    if waves and #waves > 0 then
        local wave = Utils.pick(waves)
        self.selected_menu_wave = wave
        return wave
    end
end

function LightEnemyBattler:onCheck(battler) end
function LightEnemyBattler:onActStart(battler, name) end

function LightEnemyBattler:onAct(battler, name)
    if name == "Check" then
        self:onCheck(battler)
        if type(self.check) == "table" then
            local tbl = {}
            for i,check in ipairs(self.check) do
                if i == 1 then
                    table.insert(tbl, "* " .. string.upper(self.name) .. " - " .. check)
                else
                    table.insert(tbl, "* " .. check)
                end
            end
            return tbl
        else
            return "* " .. string.upper(self.name) .. " - " .. self.check
        end
    end
end

function LightEnemyBattler:onShortAct(battler, name) end

function LightEnemyBattler:onTurnStart() end
function LightEnemyBattler:onTurnEnd() end

function LightEnemyBattler:getAct(name)
    for _,act in ipairs(self.acts) do
        if act.name == name then
            return act
        end
    end
end

function LightEnemyBattler:getXAction(battler)
    return "Standard"
end

function LightEnemyBattler:isXActionShort(battler)
    return false
end

function LightEnemyBattler:hurt(amount, battler, on_defeat, color, anim, attacked)
    if self.defeated then
        return
    end
    if Game.battle:getCurrentAction() and Game.battle:getCurrentAction().action == "SPELL" then
        battler.delay_turn_end = true
    end
    if attacked ~= false then
        attacked = true
    end
    local message
    if amount <= 0 then
        if attacked and self.special_messages then
            message = self:lightStatusMessage("msg", "_special", color or (battler and {battler.chara:getLightDamageColor()}))
            self:onHurt(amount, battler)
        else
            message = self:lightStatusMessage("msg", "miss", color or (battler and {battler.chara:getLightMissColor()}))
        end
        if message and anim then
            message:resetPhysics()
        end
        if not attacked then
            self:onDodge(battler, attacked) -- if attacked gets called in item:onLightAttack()
        end
        
        return
    end

    if self.special_messages then
        message = self:lightStatusMessage("msg", "_special", color or (battler and {battler.chara:getLightDamageColor()}))
    else
        message = self:lightStatusMessage("damage", amount, color or (battler and {battler.chara:getLightDamageColor()}))
    end
    
    if message and anim then
        message:resetPhysics()
    end
    self.health = self.health - amount

    self:onHurt(amount, battler)

    self:checkHealth(on_defeat, amount, battler)
end

function LightEnemyBattler:onDodge(battler, attacked) end

function LightEnemyBattler:checkHealth(on_defeat, amount, battler)
    -- on_defeat is optional
    if self.health <= 0 then
        self.health = 0
        if self.exit_on_defeat then
            self.done_state = "PRE-DEATH"
        end

        if not self.defeated then
            if on_defeat then
                on_defeat(self, amount, battler)
            else
                self:forceDefeat(amount, battler)
            end
        end
    end
end

function LightEnemyBattler:forceDefeat(amount, battler)
    self:onDefeat(amount, battler)
end

function LightEnemyBattler:getAttackDamage(damage, lane, points, stretch)
    local crit = false
    local total_damage
    if isClass(lane) and Utils.getClassName(lane) == "LightPartyBattler" then
        if damage > 0 then
            return damage
        end
        
        local battler = lane
        
        if Game:isLight() then
            total_damage = (battler.chara:getStat("attack") - self.defense) + Utils.random(0, 2, 1)
        else
            total_damage = (battler.chara:getStat("attack") * 3.375 - self.defense * 1.363) + Utils.random(0, 2, 1)
        end
        if points == 150 then
            total_damage = Utils.round(total_damage * 2.2)
        else
            total_damage = Utils.round((total_damage * stretch) * 2)
        end
        
        if Game.battle:getActionBy(battler).critical then
            crit = true
        end
        
        if points >= 150 then
            battler.tp_gain = 6
        elseif points >= 120 then
            battler.tp_gain = 5
        elseif points >= 100 then
            battler.tp_gain = 4
        else
            battler.tp_gain = 3
        end
    elseif lane.attack_type == "shoe" then
        if damage > 0 then
            return damage
        end

        if Game:isLight() then
            total_damage = (lane.battler.chara:getStat("attack") - self.defense)
        else
            total_damage = (lane.battler.chara:getStat("attack") * 3.375 - self.defense * 1.363)
        end
        total_damage = total_damage * ((points / 160) * (4 / lane.weapon:getLightBoltCount()))
        total_damage = Utils.round(total_damage) + Utils.random(0, 2, 1)

        if points > (400 * (lane.weapon:getLightBoltCount() / 4)) then
            crit = true
        end
        
        if crit then
            lane.battler.tp_gain = 6
        elseif points > (350 * (lane.weapon:getLightBoltCount() / 4)) then
            lane.battler.tp_gain = 5
        elseif points > (300 * (lane.weapon:getLightBoltCount() / 4)) then
            lane.battler.tp_gain = 4
        else
            lane.battler.tp_gain = 3
        end
    else
        if damage > 0 then
            return damage
        end

        if Game:isLight() then
            total_damage = (lane.battler.chara:getStat("attack") - self.defense) + Utils.random(0, 2, 1)
        else
            total_damage = (lane.battler.chara:getStat("attack") * 3.375 - self.defense * 1.363) + Utils.random(0, 2, 1)
        end
        if points <= 12 then
            total_damage = Utils.round(total_damage * 2.2)
            crit = true
        else
            total_damage = Utils.round((total_damage * stretch) * 2)
        end
        
        if crit then
            lane.battler.tp_gain = 6
        elseif points <= 20 then
            lane.battler.tp_gain = 5
        elseif points <= 97 then
            lane.battler.tp_gain = 4
        else
            lane.battler.tp_gain = 3
        end
    end
    if not self.post_health then
        self.post_health = self.health
    end
    self.post_health = self.post_health - total_damage
    if self.post_health <= 0 and self.exit_on_defeat then
        self.done_state = "PRE-DEATH"
    end
    return total_damage, crit
end

function LightEnemyBattler:getDamageSound() end
function LightEnemyBattler:getDamageVoice() end

function LightEnemyBattler:getAttackTension(amount)
    return amount * 1
end

function LightEnemyBattler:onHurt(damage, battler)
    self.hurt_timer = 1
    self:toggleOverlay(true)
    if Game.battle.tension then
        Game:giveTension(Utils.round(self:getAttackTension(battler.tp_gain or 0)))
    end
    battler.tp_gain = 0
    if self.actor.use_light_battler_sprite then
        if not self:getActiveSprite():setAnimation("lightbattle_hurt") then
            self:toggleOverlay(false)
        end
    else
        if not self:getActiveSprite():setAnimation("hurt") then
            self:toggleOverlay(false)
        end
    end

    if self.can_shake then
        self:getActiveSprite():shake(6, 0, 0.2, 2/30)
    end

    Game.battle.timer:after(1/3, function()
        local sound = self:getDamageVoice()
        if sound and type(sound) == "string" and not self:getActiveSprite().frozen then
            Assets.stopAndPlaySound(sound)
        end
    end)

    if self.health <= (self.max_health * self.tired_percentage) then
        self:setTired(true)
    end

    if self.health <= (self.max_health * self.spare_percentage) then
        self.mercy = 100
    end
end

function LightEnemyBattler:onHurtEnd()
    if self.can_shake then
        self:getActiveSprite():stopShake()
    end
    if self.health > 0 or not self.exit_on_defeat then
        self:toggleOverlay(false, true)
    end
end

function LightEnemyBattler:onDefeat(damage, battler)
    if self.exit_on_defeat then
        Game.battle.timer:after(self.hurt_timer, function()
            if self.hurt_timer > 0 or self.defeated then
                return false
            end
            if self.actor.use_light_battler_sprite then
                self:toggleOverlay(true)
                if self.actor:getAnimation("lightbattle_defeat") then
                    self.overlay_sprite:setAnimation("lightbattle_defeat")
                else
                    self.overlay_sprite:setAnimation("lightbattle_hurt")
                end
            end
            if self.can_die then
                if self.ut_death then
                    self:onDefeatVaporized(damage, battler)
                else
                    self:onDefeatFatal(damage, battler)
                end
            else
                self:onDefeatRun(damage, battler)
            end
        end)
    elseif not self.actor.use_light_battler_sprite then
        self.sprite:setAnimation("defeat")
    end
end

function LightEnemyBattler:onDefeatRun(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("defeatrun")

    local sweat = Sprite("effects/defeat/sweat")
    sweat:setOrigin(0.5, 0.5)
    sweat:play(5/30, true)
    sweat.layer = 100
    self:addChild(sweat)

    Game.battle.timer:after(15/30, function()
        sweat:remove()
        self:getActiveSprite().run_away_light = true

        Game.battle.timer:after(15/30, function()
            self:remove()
        end)
    end)

    self:defeat("VIOLENCED", true)
end

function LightEnemyBattler:onDefeatVaporized(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("vaporized", 1.2)

    local sprite = self:getActiveSprite()

    sprite.visible = false
    sprite:stopShake()

    local death_x, death_y = sprite:getRelativePos(0, 0, self)
    local death
    if self.large_dust then
        death = DustEffectLarge(sprite:getTexture(), death_x, death_y, function() self:remove() end)
    else
        death = DustEffect(sprite:getTexture(), death_x, death_y, function() self:remove() end)
    end
     
    death:setColor(sprite:getDrawColor())
    death:setScale(sprite:getScale())
    self:addChild(death)

    self:defeat("KILLED", true)
end

function LightEnemyBattler:onDefeatFatal(damage, battler)
    self.hurt_timer = -1

    Assets.playSound("deathnoise")

    local sprite = self:getActiveSprite()

    sprite.visible = false
    sprite:stopShake()

    local death_x, death_y = sprite:getRelativePos(0, 0, self)
    local death = FatalEffect(sprite:getTexture(), death_x, death_y, function() self:remove() end)
    death:setColor(sprite:getDrawColor())
    death:setScale(sprite:getScale())
    self:addChild(death)

    self:defeat("KILLED", true)
end

function LightEnemyBattler:heal(amount)
    MagicalGlassLib.heal_amount = amount
    Assets.stopAndPlaySound("power")
    self:lightStatusMessage("damage", "+" .. amount, {0, 1, 0})

    self.health = self.health + amount

    if self.health >= self.max_health then
        self.health = self.max_health
    end

end

function LightEnemyBattler:freeze()
    if not self.can_freeze then
        self:onDefeat()
        return
    end

    Assets.playSound("petrify")

    self:toggleOverlay(true)

    local sprite = self:getActiveSprite()
    if not sprite:setAnimation("frozen") then
        sprite:setAnimation("hurt")
    end
    sprite:stopShake()

    -- self:recruitMessage("frozen")
    local message = self:lightStatusMessage("msg", "frozen", {58/255, 147/255, 254/255}, true)
    message.y = message.y + 60
    message:resetPhysics()

    self.hurt_timer = -1

    sprite.frozen = true
    sprite.freeze_progress = 0

    Game.battle.timer:tween(20/30, sprite, {freeze_progress = 1})

    if Game:isLight() then
        Game.battle.money = Game.battle.money + 2
    else
        Game.battle.money = Game.battle.money + 24
    end
    self:defeat("FROZEN", true)
end

function LightEnemyBattler:lightStatusMessage(type, arg, color, kill)
    local x, y = self:getRelativePos(self.width/2, self.height/2 - 10)
    
    if self.active_msg <= 0 then
        self.active_msg = 0
        self.light_hit_count = 0
    end
    
    local offset_x, offset_y = Utils.unpack(self:getDamageOffset())
    
    local function y_msg_position()
        return y + (offset_y - 2) - (not kill and self.light_hit_count * (Assets.getFont("lwdmg"):getHeight() + 2) or 0)
    end
    
    if y_msg_position() <= 6 and self.light_hit_count > 0 then
        self.light_hit_count = -2 
    elseif y_msg_position() > SCREEN_HEIGHT / 2 then
        self.light_hit_count = 0
        self.x_number_offset = self.x_number_offset + 1
    end
    local percent
    if (type == "mercy" and self:getMercyVisibility()) or type == "damage" or type == "msg" then
        percent = LightDamageNumber(type, arg, x + offset_x + math.floor((self.x_number_offset + 1) / 2) * 122 * ((self.x_number_offset % 2 == 0) and -1 or 1), y_msg_position(), color, self)
        if kill then
            percent.kill_others = true
        end
        self.parent:addChild(percent)
        self.active_msg = self.active_msg + 1
    
        if not kill then
            if self.light_hit_count >= 0 then
                self.light_hit_count = self.light_hit_count + 1
            else
                self.light_hit_count = self.light_hit_count - 1
            end
        end
    end

    if type ~= "msg" then
        if (type == "damage" and self:getHPVisibility()) or (type == "mercy" and self:getMercyVisibility()) then
            local gauge = LightGauge(type, arg, x + offset_x, y + offset_y + 8, self)
            self.parent:addChild(gauge)
        end
    end

    return percent
end

function LightEnemyBattler:recruitMessage(...)
    return super.recruitMessage(self, self.width/2, self.height, ...)
end

function LightEnemyBattler:spawnSpeechBubble(text, options)
    options = options or {}
    options["right"] = options["right"] or self.dialogue_flip

    local bubble
    if not options["style"] and self.dialogue_bubble then
        options["style"] = self.dialogue_bubble
    end
    if not options["right"] then
        local x, y = self.sprite:getRelativePos(0, self.actor:getHeight()/2, Game.battle)
        x, y = x - self.dialogue_offset[1], y + self.dialogue_offset[2]
        bubble = SpeechBubble(text, x, y, options, self)
    else
        local x, y = self.sprite:getRelativePos(self.actor:getWidth(), self.actor:getHeight()/2, Game.battle)
        x, y = x + self.dialogue_offset[1], y + self.dialogue_offset[2]
        bubble = SpeechBubble(text, x, y, options, self)
    end
    self.bubble = bubble
    self:onBubbleSpawn(bubble)
    bubble:setCallback(function()
        self:onBubbleRemove(bubble)
        bubble:remove()
        self.bubble = nil
    end)
    bubble:setLineCallback(function(index)
        Game.battle.textbox_timer = 3 * 30
    end)
    Game.battle:addChild(bubble)
    return bubble
end

function LightEnemyBattler:defeat(reason, violent)
    self.done_state = reason or "DEFEATED"
    
    self.defeated = true

    if violent then
        Game.battle.used_violence = true
        if self.done_state == "KILLED" or self.done_state == "FROZEN" then
            MagicalGlassLib.kills = MagicalGlassLib.kills + 1
        end
        Game.battle.xp = Game.battle.xp + self.experience
        if MagicalGlassLib.random_encounter and MagicalGlassLib:createRandomEncounter(MagicalGlassLib.random_encounter).population then
            MagicalGlassLib:createRandomEncounter(MagicalGlassLib.random_encounter):addFlag("violent", 1)
        end
    end
    
    Game.battle.money = Game.battle.money + self:getMoney()
    
    Game.battle:removeEnemy(self, true)
end

function LightEnemyBattler:setActor(actor, use_overlay)
    if type(actor) == "string" then
        self.actor = Registry.createActor(actor)
    else
        self.actor = actor
    end

    self.width = self.actor:getWidth()
    self.height = self.actor:getHeight()

    if self.sprite         then self:removeChild(self.sprite)         end
    if self.overlay_sprite then self:removeChild(self.overlay_sprite) end

    if self.actor.use_light_battler_sprite then
        self.sprite = self.actor:createLightBattleSprite()
    else
        self.sprite = self.actor:createSprite()
    end
    self:addChild(self.sprite)

    if use_overlay ~= false then
        self.overlay_sprite = self.actor:createSprite()
        self.overlay_sprite.visible = false
        self:addChild(self.overlay_sprite)
    end

    if self.sprite then
        self.sprite.facing = "down"
        self.sprite.inherit_color = true
    end
    if self.overlay_sprite then
        self.overlay_sprite.facing = "down"
        self.overlay_sprite.inherit_color = true
    end
end

function LightEnemyBattler:setSprite(sprite, speed, loop, after)
    if not self.sprite then
        self.sprite = Sprite(sprite)
        self:addChild(self.sprite)
    else
        self.sprite:setSprite(sprite)
    end
    if not self.sprite.directional and speed then
        self.sprite:play(speed, loop, after)
    end
end

function LightEnemyBattler:getSpritePart(part, parent)
    return self.sprite:getPart(part, parent)
end

function LightEnemyBattler:update()
    if self.actor then
        self.actor:onBattleUpdate(self)
    end

    if self.hurt_timer > 0 then
        self.hurt_timer = Utils.approach(self.hurt_timer, 0, DT)

        if self.hurt_timer == 0 then
            self:onHurtEnd()
        end
    end

    super.update(self)
end

function LightEnemyBattler:draw()
    if self.actor then
        self.actor:onBattleDraw(self)
    end

    super.draw(self)
end

function LightEnemyBattler:canDeepCopy()
    return false
end

function LightEnemyBattler:setFlag(flag, value)
    Game:setFlag("lw_enemy#"..self.id..":"..flag, value)
end

function LightEnemyBattler:getFlag(flag, default)
    return Game:getFlag("lw_enemy#"..self.id..":"..flag, default)
end

function LightEnemyBattler:addFlag(flag, amount)
    return Game:addFlag("lw_enemy#"..self.id..":"..flag, amount)
end

return LightEnemyBattler