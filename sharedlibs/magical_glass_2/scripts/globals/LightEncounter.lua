local LightEncounter = Class(nil, "LightEncounter")

function LightEncounter:init()
    -- Text that will be displayed when the battle starts
    -- Associated getter: getEncounterText (string)
    self.text = "* TestMonster and its cohorts\ndraw near!"

    -- Whether this encounter allows commands to be input. Changes the UI if active.
    self.story = false
    -- The cutscene that will play once a battle starts and story is true.
    self.story_cutscene = nil

    -- A table defining the default location of where the soul should move to
    -- during the battle transition. If this is nil, it will move to the FIGHT button.
    -- Associated getter: getSoulTarget (table[x, y])
    self.soul_target = nil

    -- The image to draw for the background. Leave blank to disable the background.
    -- Associated getter: getBackgroundImage (bool)
    self.background_image = "ui/lightbattle/backgrounds/battle"

    -- The music used for this encounter
    -- Associated getter: getMusic (string representing the path to an audio file)
    self.music = "battle_ut"

    -- Whether characters have the X-Action option in their spell menu
    self.default_x_actions = Game:getConfig("partyActions")

    -- Should the battle skip the YOU WON! text?
    -- Associated getter: shouldSkipEndMessage (bool)
    self.no_end_message = false

    -- Whether Karmic Retribution (KR) is enabled for this encounter.
    self.karma = false

    self.allow_tension = MagicalGlass:getConfig("lightBattleTensionDefault")
    self.allow_defend = MagicalGlass:getConfig("lightBattleDefendDefault")

    -- Whether the "Flee" command should be shown in the MERCY menu by default.
    -- To change this in battle, use LightBattle.can_flee.
    self.allow_flee = true

    -- When rolling to determine if an escape is successful, that number must EXCEED this number
    -- for a successful escape.
    -- This is always 50 in UNDERTALE.
    self.flee_threshold = 50

    -- Whether items should use their serious names or not.
    -- Doesn't affect on the list item menu.
    self.serious = false

    self.id_letters = {"A", "B", "C"}
    self.enemy_count = {}

    -- Table used to spawn enemies after a battle starts and this encounter file is loaded
    -- beforehand.
    self.queued_enemy_spawns = {}

    -- A copy of Battle.defeated_enemies, used to determine how an enemy has been defeated.
    -- This is an internal variable. Do not edit it unless you know what you're doing.
    self.defeated_enemies = nil
end

-- Getters

function LightEncounter:getMusic()
    if self.music then
        if type(self.music) == "string" then
            -- Load and return the song if it's a string.
            return Assets.newSound(self.music)
        elseif type(self.music) == "userdata" then
            -- Just return if if it's already loaded, and is thus userdata.
            return self.music
        end
    else
        -- Otherwise, return nil to signify that no music should be played.
        return nil
    end
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
    if self.story then
        local wave = self:getStoryWave()
        table.insert(waves, wave)
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

function LightEncounter:getSoulTarget() return self.soul_target end

function LightEncounter:getStoryCutscene() return self.story_cutscene end

function LightEncounter:getBackgroundImage()
    if self.background_image then
        if type(self.background_image) == "string" then
            -- Load and return the image if it's a string.
            return Assets.getTexture(self.background_image)
        elseif type(self.background_image) == "userdata" then
            -- Just return if if it's already loaded, and is thus userdata.
            return self.background_image
        end
    else
        -- Otherwise, return nil to signify that an image shouldn't be drawn.
        return nil
    end
end

function LightEncounter:getSoulColor() return Game:getSoulColor() end

function LightEncounter:getFleeThreshold()
    return self.flee_threshold 
end

function LightEncounter:getFleeMessage()
    local message = love.math.random(0, 20)

    if message == 0 or message == 1 then
        return "* I'm outta here."
    elseif message == 2 then
        return "* I've got better to do."
    elseif message > 3 then
        return "* Escaped..."
    elseif message == 3 then
        return "* Don't slow me down."
    end
end

function LightEncounter:getRewardFleeMessage(exp, money)
    return "* Ran away with " .. exp .. " EXP\nand " .. money .. " " .. Game:getConfig("lightCurrency"):upper() .. "."
end

function LightEncounter:getDialogueCutscene() end

function LightEncounter:getVictoryMoney(money) end
function LightEncounter:getVictoryEXP(exp) end
function LightEncounter:getVictoryText(text, money, exp) end

-- Callbacks

function LightEncounter:onTransition()
    self:soulTransition(x, y)
end

function LightEncounter:onTransitionFinished()
    Game.battle:setState("INTRO")
end

function LightEncounter:onBattleInit() end
function LightEncounter:onBattleStart() end
function LightEncounter:onBattleEnd(fled) end

function LightEncounter:onFleeStart() end
function LightEncounter:onFlee() end
function LightEncounter:onFleeFail() end

function LightEncounter:onTurnStart() end
function LightEncounter:onTurnEnd() end

function LightEncounter:onActionsStart() end
function LightEncounter:onActionsEnd() end

function LightEncounter:onCharacterTurn(battler, undo) end

function LightEncounter:beforeStateChange(old, new, reason, extra) end
function LightEncounter:onStateChange(old, new, reason, extra) end

function LightEncounter:beforeSubStateChange(old, new, reason, extra) end
function LightEncounter:onSubStateChange(old, new, reason, extra) end

function LightEncounter:onActionButtonSelect(battler, button) end

function LightEncounter:onDialogueEnd() end

function LightEncounter:onWavesDone(waves) end
function LightEncounter:onMenuWavesDone(waves) end

function LightEncounter:getDefeatedEnemies()
    return self.defeated_enemies or Game.battle.defeated_enemies
end

function LightEncounter:onGameOver() end
function LightEncounter:onReturnToWorld(events) end

function LightEncounter:update() end

function LightEncounter:preUIDraw(ui) end
function LightEncounter:onUIDraw(ui) end

function LightEncounter:preDraw() end
function LightEncounter:postDraw() end

function LightEncounter:drawBackground()
    local texture = self:getBackgroundImage()
    local x, y = ((SCREEN_WIDTH / 2) - (texture:getWidth() / 2)), 9
    
    Draw.setColor(1, 1, 1, 1)
    Draw.draw(texture, math.floor(x), math.floor(y))
end

-- Functions

function LightEncounter:createSoul(x, y, color)
    return LightSoul(x, y, color)
end

function LightEncounter:soulTransition(x, y)
    local target_x, target_y
    if x and y then
        target_x, target_y = x, y
    elseif self:getSoulTarget() then
        target_x, target_y = self:getSoulTarget()
    else
        -- replace this with non-absolute coords
        target_x, target_y = 49, 455
    end

    local soul_chara = Game.world:getPartyCharacterInParty(Game:getSoulPartyMember())
    local fake_player = FakeClone(soul_chara, soul_chara:getScreenPos())
    fake_player.layer = Game.battle.fader.layer + 1
    Game.battle:addChild(fake_player)

    local sx, sy = soul_chara:getSoulPosition()
    -- offsetting this at all causes it to desync with the camera
    local soul_x, soul_y = soul_chara:getRelativePos(sx, sy, Game.battle)
    Game.battle:spawnSoul(soul_x, soul_y)
    Game.battle.soul.layer = Game.battle.fader.layer + 1
    Game.battle.soul.visible = false

    local noise = Assets.newSound("noise")

    Game.battle.timer:script(function(wait)
        -- Dark frame, only chara
        wait(1/30)
        -- Show soul
        noise:play()
        Game.battle.soul.visible = true
        Game.battle.soul:startTransition()
        wait(2/30)
        -- Hide soul
        Game.battle.soul.visible = false
        wait(2/30)
        -- Show soul
        Game.battle.soul.visible = true
        noise:play()
        wait(2/30)
        -- Hide soul
        Game.battle.soul.visible = false
        wait(2/30)
        -- Show soul
        Game.battle.soul.visible = true
        noise:play()
        wait(2/30)
        -- Remove fake player, move soul
        fake_player:remove()
        Assets.playSound("battlefall")

        Game.battle.soul:slideTo(target_x, target_y, 17/30)

        wait(17/30)
        -- Wait for soul
        wait(5/30)

        Game.battle.fader:fadeIn(function()
           Game.battle.soul.layer = BATTLE_LAYERS["soul"] 
        end, {speed=5/30})
        Game.battle.transitioned = true

        Game.battle.soul:reset()
        Game.battle.soul.x = Game.battle.soul.x - 1
        Game.battle.soul.y = Game.battle.soul.y - 1

        self:onTransitionFinished()
    end)
end

function LightEncounter:fastSoulTransition(x, y)
    local target_x, target_y
    if x and y then
        target_x, target_y = x, y
    elseif self:getSoulTarget() then
        target_x, target_y = self:getSoulTarget()
    else
        -- replace this with non-absolute coords
        target_x, target_y = 49, 455
    end

    local soul_chara = Game.world:getPartyCharacterInParty(Game:getSoulPartyMember())
    local fake_player = FakeClone(soul_chara, soul_chara:getScreenPos())
    fake_player.visible = false
    fake_player.layer = Game.battle.fader.layer + 1
    Game.battle:addChild(fake_player)

    local noise = Assets.newSound("noise")
    local function playNoise()
        noise:stop()
        noise:play()
    end

    Game.battle.timer:script(function(wait)
        -- Dark frame, no chara
        wait(1/30)
        -- Show soul and chara
        fake_player.visible = true
        playNoise()
        
        local player = fake_player.ref
        local x, y = Game.world.soul:localToScreenPos()
        Game.battle:spawnSoul(x, y)
        Game.battle.soul:startTransition()
        wait(1/30)
        -- Hide soul
        Game.battle.soul.visible = false
        wait(1/30)
        -- Show soul
        Game.battle.soul.visible = true
        playNoise()
        wait(1/30)
        -- Hide soul
        Game.battle.soul.visible = false
        wait(1/30)
        -- Show soul
        Game.battle.soul.visible = true
        playNoise()
        wait(1/30)
        -- Remove fake player, move soul
        fake_player:remove()
        Assets.playSound("battlefall")

        Game.battle.soul:slideTo(target_x, target_y, 11/30)

        wait(11/30)
        -- Wait for soul
        --wait(5/30)

        Game.battle.soul:reset()
        Game.battle.soul.x = Game.battle.soul.x - 1
        Game.battle.soul.y = Game.battle.soul.y - 1

        Game.battle.fader.alpha = 0
        Game.battle.transitioned = true

        self:onTransitionFinished()
    end)
end

function LightEncounter:addEnemy(enemy, x, y, ...)
    local enemy_obj
    if type(enemy) == "string" then
        enemy_obj = MagicalGlass:createLightEnemy(enemy, ...)
    else
        enemy_obj = enemy
    end

    local enemies = self.queued_enemy_spawns
    if Game.battle and Game.state == "BATTLE" then
        enemies = Game.battle.enemies
    end

    self:positionEnemy(enemy_obj, x, y)

    enemy_obj.encounter = self
    table.insert(enemies, enemy_obj)

    if Game.battle and Game.state == "BATTLE" then
        table.insert(Game.battle.enemy_index, enemy_obj)
        Game.battle:addChild(enemy_obj)
    end

    self:assignIdentifiers()

    return enemy_obj
end

function LightEncounter:assignIdentifiers()
    local enemies = self.queued_enemy_spawns
    if Game.battle and Game.state == "BATTLE" then
        enemies = Game.battle.enemies
    end

    for _,enemy in ipairs(enemies) do
        if enemy then
            self.enemy_count[enemy.id] = 0
        end
    end

    for _,enemy in ipairs(enemies) do
        if enemy then
            self.enemy_count[enemy.id] = self.enemy_count[enemy.id] + 1
            if not enemy.identifier and self.enemy_count[enemy.id] <= math.pow(#self.id_letters, 2) + #self.id_letters then
                if self.enemy_count[enemy.id] > #self.id_letters then
                    local index = math.floor((self.enemy_count[enemy.id] - 1) / #self.id_letters)
                    local extended_index = self.enemy_count[enemy.id] - #self.id_letters * math.floor((self.enemy_count[enemy.id] - 1) / #self.id_letters)
                    enemy.identifier = self.id_letters[index] .. self.id_letters[extended_index]
                else
                    enemy.identifier = self.id_letters[self.enemy_count[enemy.id]]
                end
            end
        end
    end
end

function LightEncounter:positionEnemy(enemy, x, y)
    if x and not y then
        enemy:setPosition(x, self:getDefaultEnemyPositioning()[2])
    elseif x and y then
        enemy:setPosition(x, y)
    else
        enemy:setPosition(self:getDefaultEnemyPositioning())
    end
end

function LightEncounter:getDefaultEnemyPositioning()
    local enemies = self.queued_enemy_spawns
    if Game.battle and Game.state == "BATTLE" then
        enemies = Game.battle.enemies
    end
    return SCREEN_WIDTH/2 + math.floor((#enemies + 1) / 2) * 120 * ((#enemies % 2 == 0) and -1 or 1), 240
end

function LightEncounter:attemptFlee(turn_count)
    self:onFleeStart()

    local chance = Utils.random(100) + (10 * (turn_count - 1))
    for _,party in ipairs(Game.battle.party) do
        for _,equip in ipairs(party.chara:getEquipment()) do
            chance = equip:applyFleeBonus(chance)
        end
    end

    if chance > self:getFleeThreshold() then
        self:onFlee()
        return true
    else
        self:onFleeFail()
        return false
    end
end

-- Since a dark encounter and a light encounter could theoretically share IDs,
-- LightEncounter flags use a different prefix.
function LightEncounter:setFlag(flag, value)
    Game:setFlag("lw_encounter#" .. self.id .. ":" .. flag, value)
end

function LightEncounter:getFlag(flag, default)
    return Game:getFlag("lw_encounter#" .. self.id .. ":" .. flag, default)
end

function LightEncounter:addFlag(flag, amount)
    return Game:addFlag("lw_encounter#" .. self.id .. ":" .. flag, amount)
end

function LightEncounter:canDeepCopy()
    return false
end

return LightEncounter