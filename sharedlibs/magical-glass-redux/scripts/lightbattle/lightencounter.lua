local LightEncounter = Class()

function LightEncounter:init()
    -- Text that will be displayed when the battle starts
    self.text = "* A skirmish breaks out!"

    -- Is an "event" encounter (can't attack, only hp and lv are shown. A wave is started as soon as the battle starts)
    self.event = false
    self.event_waves = {"_story"}
    
    -- A table defining the default location of where the soul should move to
    -- during the battle transition. If this is nil, it will move to the default location.
    self.soul_target = nil
    self.soul_offset = nil

    -- Speeds up the soul transition (useful for world hazards encounters)
    self.fast_transition = false

    -- Whether the default grid background is drawn
    self.background = true
    self.background_image = "ui/lightbattle/backgrounds/standard"
    self.background_color = Game:isLight() and {34/255, 177/255, 76/255, 1} or {175/255, 35/255, 175/255, 1}

    -- The music used for this encounter
    self.music = Game:isLight() and "battle_ut" or "battle_dt"

    -- Whether characters have the X-Action option in their spell menu
    self.default_xactions = Game:getConfig("partyActions")

    -- Should the battle skip the YOU WON! text?
    self.no_end_message = false

    -- Table used to spawn enemies when the battle exists, if this encounter is created before
    self.queued_enemy_spawns = {}

    -- A copy of battle.defeated_enemies, used to determine how an enemy has been defeated.
    self.defeated_enemies = nil
    
    -- Whether Karma (KR) UI changes will appear.
    self.karma_mode = false
    
    -- Whether "* But it refused." will replace the game over and revive the player.
    self.invincible = false

    -- Whether the flee command is available at the mercy button
    self.can_flee = Game:isLight()

    -- The chance of successful flee (increases by 10 every turn)
    self.flee_chance = 50
    
    self.flee_messages = {
        "* I'm outta here.", -- 1/20
        "* I've got better to do.", --1/20
        "* Don't slow me down.", --1/20
        "* Escaped..." --17/20
    }

    self.reduced_tension = false
end

function LightEncounter:onSoulTransition()
    local soul_char = Mod.libs["multiplayer"] and Game.world.player or Game.world:getPartyCharacterInParty(Game:getSoulPartyMember())
    Game.battle.fake_player = Game.battle:addChild(FakeClone(soul_char, soul_char:getScreenPos()))
    Game.battle.fake_player.layer = Game.battle.fader.layer + 1

    Game.battle.timer:script(function(wait)
        -- Black bg (also, just the fake player without the soul)
        wait(2/30)
        -- Show heart
        Assets.stopAndPlaySound("noise")
        local transition_soul = Sprite("player/heart_menu", Game.world.soul:getScreenPos())
        transition_soul:setScale(2)
        transition_soul:setOrigin(0.5)
        transition_soul:setColor(self:getSoulColor())
        transition_soul:setLayer(Game.battle.fader.layer + 2)
        Game.battle:addChild(transition_soul)

        if not self.fast_transition then
            wait(2/30)
            -- Hide heart
            transition_soul.visible = false
            wait(2/30)
            -- Show heart
            transition_soul.visible = true
            Assets.stopAndPlaySound("noise")
            wait(2/30)
            -- Hide heart
            transition_soul.visible = false
            wait(2/30)
            -- Show heart
            transition_soul.visible = true
            Assets.stopAndPlaySound("noise")
            wait(2/30)
            -- Do transition
            Game.battle.fake_player:remove()
            Assets.playSound("battlefall")
            
            local target_x, target_y = 49, 455
            local offset_x, offset_y = 0, 0
            if self.soul_target then
                target_x, target_y = self.soul_target[1], self.soul_target[2]
            elseif self.event then
                target_x, target_y = Game.battle.arena:getCenter()
            end
            if self.soul_offset then
                offset_x, offset_y = self.soul_offset[1], self.soul_offset[2]
            end
            transition_soul:slideTo(target_x + offset_x, target_y + offset_y, self.event and 10/30 or 18/30)

            wait(self.event and 10/30 or 18/30)
            
            -- Wait
            if not self.event then
                wait(3/30)
            else
                wait(1/30)
            end
            
            transition_soul:remove()
            Game.battle:spawnSoul(target_x + offset_x - 1, target_y + offset_y - 1)
            Game.battle.soul:setLayer(Game.battle.fader.layer + 2)

            if not self.event then
                Game.battle.fader:fadeIn(nil, {speed=5/30})
            else
                Game.battle.fader.alpha = 0
            end
        else
            wait(1/30)
            -- Hide heart
            transition_soul.visible = false
            wait(1/30)
            -- Show heart
            transition_soul.visible = true
            Assets.stopAndPlaySound("noise")
            wait(1/30)
            -- Hide heart
            transition_soul.visible = false
            wait(1/30)
            -- Show heart
            transition_soul.visible = true
            Assets.stopAndPlaySound("noise")
            wait(1/30)
            -- Do transition
            Game.battle.fake_player:remove()
            Assets.playSound("battlefall")
            
            local target_x, target_y = 49, 455
            local offset_x, offset_y = 0, 0
            if self.soul_target then
                target_x, target_y = self.soul_target[1], self.soul_target[2]
            elseif self.event then
                target_x, target_y = Game.battle.arena:getCenter()
            end
            if self.soul_offset then
                offset_x, offset_y = self.soul_offset[1], self.soul_offset[2]
            end
            transition_soul:slideTo(target_x + offset_x, target_y + offset_y, 10/30)
            
            wait(10/30)
            
            -- Wait
            if not self.event then
                wait(3/30)
            else
                wait(5/30)
            end
            
            transition_soul:remove()
            Game.battle:spawnSoul(target_x + offset_x - 1, target_y + offset_y - 1)
            Game.battle.soul:setLayer(Game.battle.fader.layer + 2)
            
            Game.battle.fader.alpha = 0
        end
        Game.battle.transitioned = true
        self:setBattleState()
    end)
end

function LightEncounter:onNoTransition()
    Game.battle.timer:after(1/30, function()
        Game.battle.fader.alpha = 0
        Game.battle.transitioned = true
        self:setBattleState()
    end)
end

function LightEncounter:onBattleInit() end

function LightEncounter:eventWaves()
    return self.event_waves
end

function LightEncounter:setBattleState()
    if Game.battle.forced_victory then return end
    if self.event then
        Game.battle:setState("ENEMYDIALOGUE")
    else
        Game.battle:setState("ACTIONSELECT")
    end
    self:onBattleStart()
end

function LightEncounter:onBattleStart() end

function LightEncounter:onBattleEnd() end

function LightEncounter:onTurnStart() end

function LightEncounter:onTurnEnd()
    self.flee_chance = self.flee_chance + 10
end

function LightEncounter:onActionsStart() end
function LightEncounter:onActionsEnd() end

function LightEncounter:onCharacterTurn(battler, undo) end

function LightEncounter:onFlee()
    Assets.playSound("escaped")
    
    local money = self:getVictoryMoney(Game.battle.money) or Game.battle.money
    local xp = self:getVictoryXP(Game.battle.xp) or Game.battle.xp

    if money ~= 0 or xp ~= 0 or Game.battle.used_violence and Game:getConfig("growStronger") and not Game:isLight() then
        if Game:isLight() then
            for _,battler in ipairs(Game.battle.party) do
                for _,equipment in ipairs(battler.chara:getEquipment()) do
                    money = math.floor(equipment:applyMoneyBonus(money) or money)
                end
            end

            Game.lw_money = Game.lw_money + math.floor(money)

            if (Game.lw_money < 0) then
                Game.lw_money = 0
            end

            self.used_flee_message = "* Ran away with " .. xp .. " EXP\nand " .. money .. " " .. Game:getConfig("lightCurrency"):upper() .. "."

            for _,member in ipairs(Game.battle.party) do
                local lv = member.chara:getLightLV()
                member.chara:addLightEXP(xp)

                if lv ~= member.chara:getLightLV() then
                    Assets.stopAndPlaySound("levelup")
                end
            end
        else
            for _,battler in ipairs(Game.battle.party) do
                for _,equipment in ipairs(battler.chara:getEquipment()) do
                    money = math.floor(equipment:applyMoneyBonus(money) or money)
                end
            end

            Game.money = Game.money + math.floor(money)
            Game.xp = Game.xp + xp

            if (Game.money < 0) then
                Game.money = 0
            end
            
            if Game.battle.used_violence and Game:getConfig("growStronger") then
                local stronger = "You"

                local party_to_lvl_up = {}
                for _,battler in ipairs(Game.battle.party) do
                    table.insert(party_to_lvl_up, battler.chara)
                    if Game:getConfig("growStrongerChara") and battler.chara.id == Game:getConfig("growStrongerChara") then
                        stronger = battler.chara:getName()
                    end
                    for _,id in pairs(battler.chara:getStrongerAbsent()) do
                        table.insert(party_to_lvl_up, Game:getPartyMember(id))
                    end
                end
                
                for _,party in ipairs(Utils.removeDuplicates(party_to_lvl_up)) do
                    party.level_up_count = party.level_up_count + 1
                    party:onLevelUp(party.level_up_count)
                end

                if xp == 0 then
                    self.used_flee_message = "* Ran away with " .. money .. " " .. Game:getConfig("darkCurrencyShort") .. ".\n* "..stronger.." became stronger."
                else
                    self.used_flee_message = "* Ran away with " .. xp .. " EXP\nand " .. money .. " " .. Game:getConfig("darkCurrencyShort") .. ".\n* "..stronger.." became stronger."
                end

                Assets.playSound("dtrans_lw", 0.7, 2)
                --scr_levelup()
            else
                self.used_flee_message = "* Ran away with " .. xp .. " EXP\nand " .. money .. " " .. Game:getConfig("darkCurrencyShort") .. "."
            end
        end
    else
        self.used_flee_message = self:getFleeMessage()
    end

    Game.battle.soul.collidable = false
    Game.battle.soul.y = Game.battle.soul.y + 4
    Game.battle.soul.sprite:setAnimation({"player/heart_gtfo", 1/15, true})
    Game.battle.soul.physics.speed_x = -3

    Game.battle.timer:after(1, function()
        Game.battle:setState("TRANSITIONOUT")
        self:onBattleEnd()
    end)
end

function LightEncounter:onFleeFail() end

function LightEncounter:beforeStateChange(old, new) end
function LightEncounter:onStateChange(old, new) end

function LightEncounter:onActionSelect(battler, button) end

function LightEncounter:onMenuSelect(state_reason, item, can_select) end
function LightEncounter:onMenuCancel(state_reason, item) end

function LightEncounter:onEnemySelect(state_reason, enemy_index) end
function LightEncounter:onEnemyCancel(state_reason, enemy_index) end

function LightEncounter:onPartySelect(state_reason, party_index) end
function LightEncounter:onPartyCancel(state_reason, party_index) end

function LightEncounter:onGameOver() end
function LightEncounter:onReturnToWorld(events) end

function LightEncounter:getDialogueCutscene() end

function LightEncounter:getVictoryMoney(money) end
function LightEncounter:getVictoryXP(xp) end
function LightEncounter:getVictoryText(text, money, xp) end

function LightEncounter:update() end

function LightEncounter:draw() end
function LightEncounter:drawBackground()
    love.graphics.setColor(self.background_color)
    love.graphics.draw(Assets.getTexture(self.background_image))
end

function LightEncounter:addEnemy(enemy, x, y, ...)
    local enemy_obj
    if type(enemy) == "string" then
        enemy_obj = MagicalGlassLib:createLightEnemy(enemy, ...)
    else
        enemy_obj = enemy
    end

    local enemies = self.queued_enemy_spawns
    local enemies_index = Utils.copy(self.queued_enemy_spawns, true)
    if Game.battle and Game.state == "BATTLE" then
        enemies = Game.battle.enemies
        enemies_index = Game.battle.enemies_index
    end

    if x and y then
        enemy_obj:setPosition(x, y)
    else
        for _,enemy in ipairs(enemies) do
            enemy.x = enemy.x - 76
        end
        local x, y = SCREEN_WIDTH/2 - 1 + (76 * #enemies), 244
        enemy_obj:setPosition(x, y)
    end

    enemy_obj.encounter = self
    table.insert(enemies, enemy_obj)
    table.insert(enemies_index, enemy_obj)
    if Game.battle and Game.state == "BATTLE" then
        Game.battle:addChild(enemy_obj)
    end
    return enemy_obj
end

function LightEncounter:getFleeMessage()
    return self.flee_messages[math.min(Utils.random(1, 20, 1), #self.flee_messages)]
end

function LightEncounter:getEncounterText()
    local enemies = Game.battle:getActiveEnemies()
    local enemy = Utils.pick(enemies, function(v)
        if not v.text then
            return true
        else
            return #v.text > 0
        end
    end)
    if enemy then
        return enemy:getEncounterText()
    else
        return self.text
    end
end

function LightEncounter:getNextWaves()
    local waves = {}
    if self.event then
        for _,wave in ipairs(self:eventWaves()) do
            table.insert(waves, wave)
        end
    else
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            local wave = enemy:selectWave()
            if wave then
                table.insert(waves, wave)
            end
        end
    end
    return waves
end

function LightEncounter:getNextMenuWaves()
    local waves = {}
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy:selectMenuWave()
        if wave then
            table.insert(waves, wave)
        end
    end
    return waves
end

function LightEncounter:getSoulColor()
    return Game:getSoulColor()
end

function LightEncounter:onDialogueEnd()
    Game.battle:setState("DEFENDINGBEGIN")
end

function LightEncounter:onWavesDone()
    Game.battle:setState("DEFENDINGEND", "WAVEENDED")
end

function LightEncounter:onMenuWavesDone() end

function LightEncounter:getDefeatedEnemies()
    return self.defeated_enemies or Game.battle.defeated_enemies
end

function LightEncounter:createSoul(x, y, color)
    return LightSoul(x, y, color)
end

function LightEncounter:setFlag(flag, value)
    if self.id == nil then return end
    Game:setFlag("lightencounter#"..self.id..":"..flag, value)
end

function LightEncounter:getFlag(flag, default)
    if self.id == nil then return end
    return Game:getFlag("lightencounter#"..self.id..":"..flag, default)
end

function LightEncounter:addFlag(flag, amount)
    if self.id == nil then return end
    return Game:addFlag("lightencounter#"..self.id..":"..flag, amount)
end

function LightEncounter:hasReducedTension()
    return self.reduced_tension
end

function LightEncounter:getDefendTension(battler)
    if self:hasReducedTension() then
        return 2
    end
    return 16
end

function LightEncounter:isAutoHealingEnabled(battler)
    return true
end

function LightEncounter:canSwoon(target)
    return true
end

function LightEncounter:canDeepCopy()
    return false
end

return LightEncounter