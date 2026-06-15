local Battle, super = HookSystem.hookScript(Battle)

function Battle:init()
    super.init(self)

    self.light = false
    self.soul_speed = 4
    self.used_violence_backup = false
    self.money_backup = 0
    self.fled = false
    self.heal_target = false
    self.backup_palettes = {}

    if Game:isLight() then
        for _, palette in ipairs({"action_health", "action_health_bg", "action_health_text", "battle_mercy_bg", "battle_mercy_text"}) do
            self.backup_palettes[palette] = PALETTE[palette]
            PALETTE[palette] = MG_PALETTE[palette]
        end
    end
end

function Battle:postInit(state, encounter)
    local check_encounter
    if type(encounter) == "string" then
        check_encounter = Registry.getEncounter(encounter)
    else
        check_encounter = encounter
    end

    if check_encounter:includes(LightEncounter) then
        error("Attempted to use LightEncounter in a DarkBattle. Convert the encounter \"" .. check_encounter.id .. "\" file to an Encounter")
    end

    super.postInit(self, state, encounter)

    if not Kristal.getLibConfig("magical-glass", "light_world_dark_battle_tension") and Game:isLight() then
        self.tension_bar:remove()
        self.tension_bar = nil
    end
end

function Battle:update()
    if self.soul and self.soul:includes(LightSoul) then
        error("Attempted to use LightSoul class in a DarkBattle. Use Soul class")
    end

    super.update(self)
end

function Battle:heal(amount, force, target)
    self.heal_target = force and "force" or true

    -- If target is a numberic value, it will heal the party battler with that index
    -- "ANY" will choose the target randomly
    -- "ALL" will hurt the entire party all at once
    target = target or "ANY"

    -- Alright, first let's try to adjust targets.

    if type(target) == "number" then
        target = self.party[target]
    end

    if isClass(target) and target:includes(PartyBattler) and not force then
        if (not target) or (target.chara:getHealth() >= target.chara:getStat("health")) then
            target = self:randomTargetOld()
        end
    end

    if target == "ANY" then
        target = self:randomTargetOld()

        if isClass(target) and target:includes(PartyBattler) then
            target.targeted = true
        end
    end

    -- Now it's time to actually heal them!
    if isClass(target) and target:includes(PartyBattler) then
        target:heal(amount)

        self.heal_target = false
        return { target }
    end

    if target == "ALL" then
        local battlers = {}
        for _, battler in ipairs(self.party) do
            if battler.chara:getHealth() < battler.chara:getStat("health") or force then
                battler:heal(amount)
                table.insert(battlers, battler)
            end
        end

        if #battlers == 0 then
            Assets.stopAndPlaySound("power")
        end

        self.heal_target = false
        return battlers
    end
end

function Battle:randomTargetOld()
    if self.heal_target then
        -- This is "scr_randomtarget_old".
        local none_targetable = true
        for _, battler in ipairs(self.party) do
            if battler:canTarget() then
                none_targetable = false
                break
            end
        end

        if none_targetable then
            return self:targetAll()
        end

        -- Pick random party member
        local target = nil
        while not target do
            local party = TableUtils.pick(self.party)
            if party:canTarget() then
                target = party
            end
        end

        target.targeted = true
        return target
    else
        return super.randomTargetOld(self)
    end
end

function Battle:nextTurn()
    self.turn_count = self.turn_count + 1
    if self.turn_count > 1 then
        for _, battler in ipairs(self.party) do
            if battler.chara:onTurnEnd(battler) then
                return
            end
        end
    end
    self.turn_count = self.turn_count - 1

    return super.nextTurn(self)
end

function Battle:updateShortActText()
    if Kristal.getLibConfig("magical-glass", "undertale_text_skipping") == true then
        if Input.pressed("confirm") then super.updateShortActText(self) end
    else
        super.updateShortActText(self)
    end
end

function Battle:onFlee()
    self.fled = true
    self:setState("VICTORY", "FLEE")

    Assets.playSound("defeatrun")

    self.encounter:onFlee()

    for _, party in ipairs(self.party) do
        for _, path in ipairs({"battle/flee", "battle/hurt"}) do
            if party.actor:getAnimation(path) then
                local anim, anim_speed, loop = TableUtils.unpack(party.actor:getAnimation(path))
                party:setSprite(anim)
                party.sprite:play(anim_speed, loop)
                break
            end
        end
        local sweat = Sprite("effects/defeat/sweat")
        sweat:setOrigin(1.5, 0.5)
        sweat:setScale(-1, 1)
        sweat:play(5/30, true)
        sweat.layer = 100
        party:addChild(sweat)

        local counter_start = 0
        local counter_end = 0
        self.timer:doWhile(function() return counter_end >= 0 end, function()
            counter_end = counter_end + DTMULT

            if counter_end >= 30 or self.state == "TRANSITIONOUT" then
                if counter_start < 0 then
                    party.x = -200
                    party.darkner_shield = nil
                end
                party:getActiveSprite().run_away_party = false
                counter_end = -1
            end
        end)

        self.timer:doWhile(function() return counter_start >= 0 end, function()
            counter_start = counter_start + DTMULT

            if counter_start >= 15 or self.state == "TRANSITIONOUT" then
                sweat:remove()
                if counter_end >= 0 then
                    party:getActiveSprite().run_away_party = true
                    party.darkner_shield = false
                end
                counter_start = -1
            end
        end)
    end
end

function Battle:onVictory()
    local value = super.onVictory(self)

    for _, battler in ipairs(self.party) do
        battler.chara:setHealth(battler.chara:getHealth() - battler.karma)
        battler.karma = 0
    end

    if Game:isLight() then
        Game.lw_money = Game.lw_money + self.money
        Game.money = self.money_backup
        Game.xp = Game.xp - self.xp

        if (Game.lw_money < 0) then
            Game.lw_money = 0
        end

        self.used_violence = self.used_violence_backup
    end

    return value
end

function Battle:setWaves(waves, allow_duplicates)
    for i, wave in ipairs(waves) do
        if type(wave) == "string" then
            wave = Registry.getWave(wave)
        end
        if wave:includes(LightWave) then
            error("Attempted to use LightWave in a DarkBattle. Convert \"" .. waves[i] .. "\" to a Wave")
        end
    end

    return super.setWaves(self, waves, allow_duplicates)
end

function Battle:returnToWorld()
    super.returnToWorld(self)

    if Game:isLight() then
        for palette, color in pairs(self.backup_palettes) do
            PALETTE[palette] = self.backup_palettes[palette]
        end
    end
    Mod.libs["magical-glass"].current_battle_system = nil
end

return Battle