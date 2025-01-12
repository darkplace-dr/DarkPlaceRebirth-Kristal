local LightEnemyBattler, super = Class(Battler, "LightEnemyBattler")

function LightEnemyBattler:init(actor)
    super.init(self)
    -- This enemy's name.
    -- Associated getter: getName (string)
    self.name = "Test Enemy"

    if actor then
        self:setActor(actor)
    end

    self.max_health = 100
    self.health = 100
    self.attack = 1
    self.defense = 0

    -- The base amount of money this enemy gives the player when defeated.
    -- Asociated getter: getMoney (number, rounded)
    self.money = 0
    -- The EXP rewarded when this enemy is defeated.
    -- Associated getter: getEXP (number, rounded)
    self.exp = 0
    -- Whether this enemy should increase the kill count and call the current
    -- encounter group (if applicable)'s onEnemyKillled function.
    self.count_as_kill = true

    -- Whether this enemy can be spared via a pacifying spell.
    self.tired = false

    -- This enemy's current mercy points. When it reaches 100, this enemy can be
    -- spared.
    -- Typically, this should be changed with addMercy.
    self.mercy = 0

    -- The amount of mercy points added when this enemy is spared before mercy
    -- reaches 100.
    self.spare_points = 0

    -- Should this enemy turn to dust and be removed from battle when defeated?
    self.remove_on_defeat = true
    -- Whether this enemy's dust should be separated by lines instead of pixels.
    -- Recommended for larger enemies.
    self.large_vapor = false

    -- Whether this enemy runs away instead of turning to dust.
    self.run_on_defeat = false
    -- Whether this enemy can be frozen.
    self.can_freeze = true

    -- Whether this enemy can be selected.
    self.selectable = true

    -- Whether this enemy's HP should be shown in ENEMYSELECT and if
    -- an HP gauge will be spawned with the damage numbers
    self.show_health = true
    -- Whether the mercy gauge should be shown when mercy is added to this enemy.
    self.show_mercy_gauge = true
    -- Whether mercy is disabled for this enemy, like in the weird route Spamton NEO fight.
    -- This only affects the visual mercy bar in ENEMYSELECT.
    self.disable_mercy = false
  
    -- The width of the gauge that appears when this enemy is damaged.
    -- Associated getter: getGaugeWidth (number)
    self.gauge_width = 100
    -- The offset of this enemy's damage popups. The first value is the x, and the second is the y.
    -- Associated getter: getDamageOffset (table)
    self.damage_offset = {5, -10}

    -- A table of strings of wave IDs that this enemy can use.
    -- Associated getter: getNextWaves (string)
    self.waves = {}

    self.wave_override = nil
    -- A table of strings of wave IDs that this enemy can use while the player is in the menu.
    -- Associated getter: getNextMenuWaves (string)
    self.menu_waves = {}
    self.menu_wave_override = nil
    
    -- The text that gets displayed when the Check ACT is used, prefixed with "ENEMY NAME - "
    -- Associated getter: getCheckText (string or table)
    self.check = "Time to wake up and \nsmell the [color:red]pain[color:reset]."

    -- A table of strings containing flavor text that can be displayed in ACTIONSELECT when
    -- this enemy is active.
    -- Associated getter: getEncounterText (string or table{string})
    self.text = {}

    -- A table of strings or just a string containing the message that is displayed in
    -- ACTIONSELECT when this enemy is active and has low health.
    -- Associated getter: getLowHealthText (string or table)
    self.low_health_text = nil
    -- A table of strings or just a string containing the message that is displayed in
    -- ACTIONSELECT when this enemy is TIRED.
    -- Associated getter: getTiredText (string or table)
    self.tired_text = nil
    -- A table of strings or just a string containing the message that is displayed in
    -- ACTIONSELECT when this enemy can be spared.
    -- Associated getter: getSparableText (string or table)
    self.spareable_text = nil

    -- When this enemy is below this percentage of health, they will become sparable.
    self.spare_percentage = 1/3
    -- When this enemy is below this percentage of health, their tired text will be displayed.
    self.tired_percentage = 0
    -- When this enemy is below this percentage of health, their low health text will be displayed.
    self.low_health_percentage = 0.2

    -- The sound that plays when this enemy is hit by an attack.
    -- Associated getter: getDamageSound (string)
    self.damage_sound = "damage"
    -- The sound that plays about a second after this enemy is hit by an attack.
    -- Associated getter: getDamageVoice (string)
    self.damage_voice = nil
    -- Display 0 instead of miss when attacked.
    self.display_damage_on_miss = false

    -- A table of strings or just a string containing the message that is displayed in
    -- this enemy's dialogue box in the ENEMYDIALOGUE phase.
    -- Associated getter: getDialogue (string or table)
    self.dialogue = {}
    self.dialogue_override = nil
    -- The style of speech bubble this enemy should use.
    self.dialogue_bubble = "ut_large"
    -- The offset for this enemy's speech bubble.
    self.dialogue_offset = {0, 0}
    -- Whether the speech bubble should be flipped horizontally.
    self.flip_dialogue = false

    -- A string displayed next to the enemy's name in ENEMYSELECT.
    -- setTired sets this to "(Tired)" when it's true, and clears it when it's false.
    self.comment = ""

    -- The acts that this enemy has.
    -- It is HEAVILY recommended to use the registerAct functions instead of directly
    -- editing this table.
    self.acts = {
        {
            ["name"] = "Check",
            ["description"] = "",
            ["party"] = {}
        }
    }

    self.identifier = nil
    self.encounter = nil

    self.bubble = nil

    self.current_target = nil

    self.hurt_timer = 0

    self.popups = {}
    self.gauge = nil

    self.defeated = false

    -- How this enemy was removed from battle. If they're still active, this is nil.
    -- This is an internal variable. Do not edit this unless you know what you're doing.
    self.done_state = nil
end

-- Getters

function LightEnemyBattler:getName() return self.name end
function LightEnemyBattler:getMoney() return self.money end
function LightEnemyBattler:getEXP() return self.exp end

function LightEnemyBattler:getCheckText() return self.check end

function LightEnemyBattler:getGaugeWidth() return self.gauge_width end
function LightEnemyBattler:getDamageOffset() return Utils.unpack(self.damage_offset) end

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

function LightEnemyBattler:getAct(name)
    for _,act in ipairs(self.acts) do
        if act.name == name then
            return act
        end
    end
end

function LightEnemyBattler:getXAction(battler) return "Standard" end
function LightEnemyBattler:isXActionShort(battler) return false end

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

function LightEnemyBattler:getDamageSound()
    return self.damage_sound
end

function LightEnemyBattler:getDamageVoice()
    return self.damage_voice
end

function LightEnemyBattler:getAttackTension(points)
    return 3
end

function LightEnemyBattler:getSpritePart(part)
    if self.sprite:includes(LightEnemySprite) then
        return self.sprite.sprite_parts[part]
    end
end

-- Callbacks

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

function LightEnemyBattler:onTurnStart() end
function LightEnemyBattler:onTurnEnd() end

function LightEnemyBattler:onMercy(battler)
    if self:canSpare() then
        self:spare()
        return true
    else
        self:addMercy(self.spare_points)
        return false
    end
end

function LightEnemyBattler:onSpareable() end
function LightEnemyBattler:onSpared()
    if self.actor:getAnimation("lightbattle_spared") then
        self:setAnimation("lightbattle_spared")
    else
        self:setAnimation("lightbattle_hurt")
    end
end

function LightEnemyBattler:onHurt(damage, battler)
    battler.chara:onLightBattleAttackHit(self, damage)

    self:toggleOverlay(true)
    if self.actor.light_enemy_sprite then
        if not self:setAnimation("lightbattle_hurt") then
            self:toggleOverlay(false)
        end
    else
        if not self:setAnimation("hurt") then
            self:toggleOverlay(false)
        end
    end

    self:shake(9, 0, 0.5, 2/30) -- still not sure if this should be different

    Game.battle.timer:after(1/3, function()
        local sound = self:getDamageVoice()
        if sound and type(sound) == "string" and not self.overlay_sprite.frozen then
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
    self:stopShake()
    if self.health > 0 or not self.remove_on_defeat then
        self:toggleOverlay(false, true)
    end
end

function LightEnemyBattler:onDodge(battler, attacked) end

function LightEnemyBattler:onDefeatSpared(pacified)
    self:toggleOverlay(true)
    self.overlay_sprite.alpha = 0.5
    Assets.playSound("vaporized")

    for i = 0, 15 do
        local x = ((Utils.random((self.width / 2)) + (self.width / 4))) - 8
        local y = ((Utils.random((self.height / 2)) + (self.height / 4))) - 8

        local sx, sy = self:getRelativePos(x, y)

        local dust = SpareDust(sx, sy, ((8 + x)) / (self.width / 2), ((8 + y)) / (self.height / 2))
        self.parent:addChild(dust)
    end
end

function LightEnemyBattler:onDefeat(damage, battler)
    self.hurt_timer = -1
    if self.remove_on_defeat then
        if self.run_on_defeat then
            self:onDefeatRun(damage, battler)
        else
            self:onDefeatVaporized(damage, battler)
        end
    else
        self.done_state = "DEFEATED"
        self:toggleOverlay(true)
        if self.actor:getAnimation("lightbattle_defeat") then
            self:setAnimation("lightbattle_defeat")
        else
            self:setAnimation("lightbattle_hurt")
        end
    end
end

function LightEnemyBattler:onDefeatVaporized(damage, battler)
    self:toggleOverlay(true)

    self.hurt_timer = -1
    self.defeated = true

    self:stopShake()

    Assets.playSound("vaporized")

    if self.actor:getAnimation("lightbattle_defeat") then
        self:setAnimation("lightbattle_defeat")
    else
        self:setAnimation("lightbattle_hurt")
    end

    local sprite = self.overlay_sprite
    local vapor
    if self.large_vapor then
        vapor = DustEffectLarge(sprite:getTexture(), sprite:getRelativePos(0, 0, self))
    else
        vapor = DustEffect(sprite:getTexture(), sprite:getRelativePos(0, 0, self))
    end

    self.sprite.visible = false
    self.overlay_sprite.visible = false
     
    vapor:setColor(sprite:getDrawColor())
    vapor:setScale(sprite:getScale())
    self:addChild(vapor)

    self:defeat("KILLED", true)
end

function LightEnemyBattler:onDefeatRun(damage, battler)
    self.hurt_timer = -1
    self.defeated = true

    Assets.playSound("escaped")
    Assets.playSound("escaped")

    if self.actor:getAnimation("lightbattle_run") then
        self:setAnimation("lightbattle_run")
    else
        self:setAnimation("lightbattle_hurt")
    end

    local sweat = Sprite("effects/defeat/sweat")
    sweat:setOrigin(0.5, 0.5)
    sweat:play(5/30, true)
    sweat.layer = 100
    self:addChild(sweat)

    local direction = Utils.pick({0, 180})
    self.physics.direction = math.rad(direction)
    self.physics.speed = 15

    Game.battle.timer:after(2, function()
        self:remove()
    end)

    self:defeat("VIOLENCED", true)
end

-- Functions

function LightEnemyBattler:setActor(actor)
    if type(actor) == "string" then
        self.actor = Registry.createActor(actor)
    else
        self.actor = actor
    end

    if self.sprite         then self:removeChild(self.sprite)         end
    if self.overlay_sprite then self:removeChild(self.overlay_sprite) end

    if self.actor.light_enemy_sprite then
        self.sprite = self.actor:createLightEnemySprite()

        self.width = self.actor:getLightEnemyWidth()
        self.height = self.actor:getLightEnemyHeight()
    else
        self.sprite = self.actor:createSprite()

        self.width = self.actor:getWidth()
        self.height = self.actor:getHeight()
    end
    self:addChild(self.sprite)

    self.overlay_sprite = self.actor:createSprite()
    self.overlay_sprite.visible = false
    self:addChild(self.overlay_sprite)
end

function LightEnemyBattler:toggleOverlay(overlay)
    if overlay == nil then
        overlay = self.sprite.visible
    end
    self.overlay_sprite.visible = overlay
    self.sprite.visible = not overlay
end

function LightEnemyBattler:callPartFunction(part, func_id, ...)
    if self.sprite:includes(LightEnemySprite) then
        self.sprite.sprite_parts:callPartFunction(part, func_id, ...)
    end
end

function LightEnemyBattler:setCustomSprite(texture, ox, oy, keep_anim)
    if self.sprite:includes(LightEnemySprite) then
        self:toggleOverlay(true)
        self.overlay_sprite:setCustomSprite(texture, ox, oy, keep_anim)
    end
end

function LightEnemyBattler:set(name, callback, ignore_actor_callback)
    if self.sprite:includes(LightEnemySprite) then
        if not ignore_actor_callback and self.actor:preLightEnemySet(self.sprite, self.overlay_sprite, name, callback) then
            return
        end    
        self:toggleOverlay(true)
        self.overlay_sprite:set(name, callback, ignore_actor_callback)
        self.actor:onLightEnemySet(self.sprite, self.overlay_sprite, name, callback)
    end
end

function LightEnemyBattler:setAnimation(anim, callback, ignore_actor_callback)
    if self.sprite:includes(LightEnemySprite) then
        if not ignore_actor_callback and self.actor:preLightEnemySetAnim(self.sprite, self.overlay_sprite, anim, callback) then
            return
        end    
        self:toggleOverlay(true)
        local result = self.overlay_sprite:setAnimation(anim, callback, ignore_actor_callback)
        self.actor:onLightEnemySetAnim(self.sprite, self.overlay_sprite, anim, callback)
        return result
    end
end

function LightEnemyBattler:setSprite(texture, keep_anim, ignore_actor_callback)
    if self.sprite:includes(LightEnemySprite) then
        if not ignore_actor_callback and self.actor:preLightEnemySetSprite(self.sprite, self.overlay_sprite, texture, keep_anim) then
            return
        end    
        self:toggleOverlay(true)
        self.overlay_sprite:setSprite(anim, callback, ignore_actor_callback)
        self.actor:onLightEnemySetSprite(self.sprite, self.overlay_sprite, texture, keep_anim)
    end
end

function LightEnemyBattler:shake(...)
    self:getActiveSprite():shake(...)
end

function LightEnemyBattler:stopShake()
    self:getActiveSprite():stopShake()
end

function LightEnemyBattler:setTired(bool)
    self.tired = bool
    if self.tired then
        self.comment = "(Tired)"
    else
        self.comment = ""
    end
end

function LightEnemyBattler:addMercy(amount) 
    if (amount >= 0 and self.mercy >= 100) or (amount < 0 and self.mercy <= 0) then
        -- This enemy either has full mercy or 0 mercy and some is being removed. 
        -- Regardless, nothing should happen.
        return
    end

    if MagicalGlass.light_battle_mercy_messages and self.show_mercy_gauge then
        if amount == 0 then
            self:lightStatusMessage("msg", "miss", {color = COLORS.yellow, dont_animate = true})
        else
            if amount > 0 then
                local pitch = 0.8
                if amount < 99 then pitch = 1 end
                if amount <= 50 then pitch = 1.2 end
                if amount <= 25 then pitch = 1.4 end

                local sound = Assets.playSound("mercyadd", 0.8)
                sound:setPitch(pitch)
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

function LightEnemyBattler:spawnSpeechBubble(text, options)
    options = options or {}
    options["flip"] = options["flip"] or self.flip_dialogue

    if not options["style"] and self.dialogue_bubble then
        options["style"] = self.dialogue_bubble
    end

    local bubble
    local x, y
    if options["flip"] then
        local w, h = self.actor:getLightEnemyWidth(), self.actor:getLightEnemyHeight()
        if self.sprite:includes(ActorSprite) then
            w, h = self.actor:getWidth(), self.actor:getHeight()
        end
        x, y = self.sprite:getRelativePos(w, h / 2, Game.battle)
        options = Utils.merge({right = true}, options)
    else
        local h = self.actor:getLightEnemyWidth(), self.actor:getLightEnemyHeight()
        if self.sprite:includes(ActorSprite) then
            h = self.actor:getWidth(), self.actor:getHeight()
        end
        x, y = self.sprite:getRelativePos(0, h / 2, Game.battle)
    end
    x, y = x - self.dialogue_offset[1], y + self.dialogue_offset[2]
    bubble = UnderSpeechBubble(text, x, y, options, self)

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

function LightEnemyBattler:registerAct(name, description, party, tp, icons, unusable)
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
        ["unusable"] = unusable,
        ["description"] = description,
        ["party"] = party,
        ["tp"] = tp or 0,
        ["short"] = false,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
    return act
end

--[[ function LightEnemyBattler:registerShortAct(name, description, party, tp, icons)
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
        ["short"] = true,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
    return act
end ]]

function LightEnemyBattler:registerActFor(char, name, description, party, tp, icons)
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
        ["short"] = false,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
end

--[[ function LightEnemyBattler:registerShortActFor(char, name, description, party, tp, icons)
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
        ["short"] = true,
        ["icons"] = icons
    }
    table.insert(self.acts, act)
end ]]

function LightEnemyBattler:removeAct(name)
    for i,act in ipairs(self.acts) do
        if act.name == name then
            table.remove(self.acts, i)
            break
        end
    end
end

function LightEnemyBattler:getNameColors()
    local result = {}
    if self:canSpare() then
        if MagicalGlass.pink_spare then
            table.insert(result, MagicalGlass.PALETTE["pink_spare"])
        else
            table.insert(result, {1, 1, 0})
        end
    end
    if self.tired then
        table.insert(result, {0, 0.7, 1})
    end
    return result
end

function LightEnemyBattler:getTarget()
    return Game.battle:randomTarget()
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

function LightEnemyBattler:getAttackDamage(battler, attack, damage)
    if damage and damage ~= 0 then return damage end

    if attack:isMultibolt() then
        local total_damage
        local crit = false

        total_damage = (battler.chara:getStat("attack") - self.defense)
        total_damage = total_damage * ((attack.score / 160) * (4 / attack.count))
        total_damage = Utils.round(total_damage) + Utils.random(0, 2, 1)

        if attack.score > (400 * (attack.count / 4)) then
            crit = true
        end

        return total_damage, crit
    else
        local total_damage = (battler.chara:getStat("attack") - self.defense) + Utils.random(0, 2, 1)

        if attack.score <= 12 then
            total_damage = Utils.round(total_damage * 2.2)
        else
            total_damage = Utils.round((total_damage * attack.stretch) * 2)
        end

        return total_damage
    end
end

function LightEnemyBattler:heal(amount)
    Assets.stopAndPlaySound("power")
    self:lightStatusMessage("heal", amount)

    self.health = self.health + amount

    if self.health >= self.max_health then
        self.health = self.max_health
    end
end

function LightEnemyBattler:hurt(amount, battler, on_defeat, options)
    options = options or {}
    if amount <= 0 then
        if attacked then self.hurt_timer = 1 end
        if not options["show_status"] then
			if battler.chara.id == "pauling" then
				self:lightStatusMessage("msg", "miss_pauling", {color = options["color"] or battler.chara.color, dont_animate = not options["attacked"]})
			else
				self:lightStatusMessage("msg", "miss", {color = options["color"] or battler.chara.color, dont_animate = not options["attacked"]})
			end
        end
        self:onDodge(battler, options["attacked"])
        return
    end

    if not options["show_status"] then
        self:lightStatusMessage("damage", amount, {color = options["color"] or battler.chara.color})
    end

    self.health = self.health - amount

    if amount > 0 then	-- Why is this check here? The previous return removes the other case
        self.hurt_timer = 1
        self:onHurt(amount, battler)
    end

    self:checkHealth(on_defeat, amount, battler)
end

function LightEnemyBattler:checkHealth(on_defeat, amount, battler)
    -- on_defeat is optional
    if self.health <= 0 then
        self.health = 0

        if not self.defeated then
            if on_defeat then
                on_defeat(self, amount, battler)
            else
                self:forceDefeat(amount, battler)
            end
        end
    end
end

function LightEnemyBattler:canSpare()
    return self.mercy >= 100
end

function LightEnemyBattler:spare(pacified)
    if self.remove_on_defeat then
        self:onDefeatSpared(pacified)
    end

    self:defeat(pacified and "PACIFIED" or "SPARED", false)
    self:onSpared()
end

function LightEnemyBattler:freeze()
    if not self.can_freeze then
        self:onDefeat()
        return
    end

    Assets.playSound("petrify")

    self:toggleOverlay(true)

    if not self:setAnimation("lightbattle_frozen") then
        self:setAnimation("lightbattle_hurt")
    end
    self:stopShake()

    local message = self:lightStatusMessage("msg", "frozen")
    message.y = message.y + 60
    message:resetPhysics()

    self.hurt_timer = -1
    self.sprite.visible = false

    self.overlay_sprite.frozen = true
    self.overlay_sprite.freeze_progress = 0

    Game.battle.timer:tween(20/30, self.overlay_sprite, {freeze_progress = 1})

    Game.battle.money = Game.battle.money + 24
    
    self:defeat("FROZEN", true)
end

function LightEnemyBattler:defeat(reason, violent)
    self.done_state = reason or "DEFEATED"

    if violent then
        Game.battle.used_violence = true
        if self.done_state == "KILLED" or self.done_state == "FROZEN" then
            if self.count_as_kill then
                if Game.battle.encounter_group then
                    Game.battle.encounter_group:onEnemyKilled(self)
                end
                MagicalGlass.kills = MagicalGlass.kills + 1
            end
            Game.battle.exp = Game.battle.exp + self:getEXP()
        end
    end
    
    Game.battle.money = Game.battle.money + self:getMoney()
    Game.battle:removeEnemy(self, true)
end

function LightEnemyBattler:forceDefeat(amount, battler)
    self.done_state = "FALLENDOWN"
end

function LightEnemyBattler:statusMessage(...)
    return super.statusMessage(self, self.width/2, self.height/2, ...)
end

function LightEnemyBattler:lightStatusMessage(...)
    return super.lightStatusMessage(self, self.width/2, self.height/2, ...)
end

function LightEnemyBattler:recruitMessage(...)
    return super.recruitMessage(self, self.width/2, self.height/2, ...)
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

    if self.sprite and self.sprite:includes(LightEnemySprite) then
        if not self.done_state and self.hurt_timer == 0 then
            for id, part in pairs(self.sprite.sprite_parts) do
                part.timer = part.timer + DTMULT
            end
        end
    end

    if self.done_state == "FALLENDOWN" and self.hurt_timer <= 0 then
        self:onDefeat()
    end

    super.update(self)
end

function LightEnemyBattler:draw()
    if self.actor then
        self.actor:onBattleDraw(self)
    end

    super.draw(self)
end

function LightEnemyBattler:setFlag(flag, value)
    Game:setFlag("lw_enemy#" .. self.id .. ":" .. flag, value)
end

function LightEnemyBattler:getFlag(flag, default)
    return Game:getFlag("lw_enemy#" .. self.id .. ":" .. flag, default)
end

function LightEnemyBattler:addFlag(flag, amount)
    return Game:addFlag("lw_enemy#" .. self.id .. ":" .. flag, amount)
end

function LightEnemyBattler:canDeepCopy()
    return false
end

return LightEnemyBattler