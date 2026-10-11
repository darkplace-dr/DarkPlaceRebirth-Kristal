local Balthizard, super = Class(EnemyBattler)

function Balthizard:init()
    super.init(self)

    self.name = "Balthizard"
    self:setActor("balthizard")
    self:setAnimation("transition")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 130
    self.experience = 0
    self.spare_points = 10

    self.waves = {
        --"balthizard/incense_cloud_manager",
        "balthizard/incense_censer",
    }

    self.dialogue = {
        "[speed:0.5]Slow down.",
        "[speed:0.5]Take it easy.",
        "[speed:0.5]Glory,\nmemory.",
        "[speed:0.5]Sit back,\nrelax."
    }
    self.dialogue_lightup = {
        "Let's burn\nrubber!",
        "Strike while\nthe iron\nis hot!",
        "Inferno,\nInferno!"
    }

    self.check = "An ancient\naromancer. Punishes intruders\nwith beautiful scent."

    self.text = {
        "* Balthizard clambers slowly.",
        "* Balthizard releases a plume of\nsickly sweet nostalgia.",
        "* Balthizard breathes a fog of\nsunbeam on warm wood.",
        "* Balthizard spins the scent of a\nrainy, grassy day.",
        "* Balthizard coughs plumes like\nold pillows on golden hair."
    }
    self.low_health_text = "* Balthizard coughs scentlessly."
    self.tired_text = "* Balthizard releases a scent of\ncandles and chamomile."
	self.spareable_text = "* Balthizard laughs plumes of\nheart-shaped gas."

    self.low_health_percentage = 1 / 3

    self:registerAct("Shake", "Left &\nRight=\nMercy")
    self:registerAct("ShakeX", "Left &\nRight=\nMercy", { "susie" })
    self:registerAct("LightUp", "50% &\nTIRE\nothers", { "ralsei" })
    --self:registerAct("OldMan", "I'm\nold!") -- he's old

    self.sprite.active = false
    self.transition_ended = false

    self.lightup = false
    self.lightupmessage = false
end

function Balthizard:isXActionShort(battler)
    return true
end

function Balthizard:onAct(battler, name)
    if name == "Shake" or name == "ShakeX" then
        local shakex = false
        if name == "ShakeX" then shakex = true end
        local shake = BalthizardShakeController(self, shakex)
        Game.battle:addChild(shake)
        if not self.lightup then
            self.dialogue_override = "[speed:0.5]A nice\nmassage."
        else
            self.dialogue_override = "What a\nblast!\nHoh hoh!"
        end
        return
    elseif name == "LightUp" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* Ralsei lit up!")
            local litup = false
            local fires = {}
            local ralsei = Game.battle:getPartyBattler("ralsei")
            local function makeFire()
                local b = 0
                local rand = MathUtils.randomInt(31)
                Assets.playSound("wing")
                for i = 1, 9 do
                    local x, y = ralsei:getRelativePos()
                    local fire = BalthizardFire(x + 62, y + 22)
                    fire.physics.direction = -math.rad(b * 45 + rand)
                    fire.physics.speed = 14
                    fire.physics.gravity_direction = -math.rad(270)
                    fire.physics.gravity = 0.4
                    fire:setScale(1.5)
                    fire.layer = ralsei.layer + 0.1
                    Game.battle:addChild(fire)
                    table.insert(fires, fire)
                    b = b + 1
                end
            end
            ralsei:setAnimation("battle/spell")
            Game.battle.timer:after(16 / 30, function()
                ralsei:setSprite("battle/spellend")
                makeFire()
            end)
            Game.battle.timer:after(18 / 30, function()
                local screenflash = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                screenflash.color = { 1, 1, 1 }
                screenflash.alpha = 0
                screenflash.layer = BATTLE_LAYERS["top"]
                Game.battle:addChild(screenflash)
                screenflash:fadeToSpeed(1.1, 0.05, function()
                    for _, fire in ipairs(fires) do fire:remove() end
                    screenflash:fadeOutSpeedAndRemove(0.02)
                end)
            end)
            Game.battle.timer:after(22 / 30, function() makeFire() end)
            Game.battle.timer:after(28 / 30, function() makeFire() end)
            Game.battle.timer:after(34 / 30, function() makeFire() end)
            Game.battle.timer:after(38 / 30, function()
                Assets.playSound("rocket", 0.9, 0.9)
                self.dialogue_override = "Ah! That\nwakes\nme up!!!"
                self.lightup = true
                self.lightupmessage = true
                self.sprite.lightup = true
                ralsei:setAnimation("battle/idle")
            end)
            Game.battle.timer:after(49 / 30, function() litup = true end)
            cutscene:wait(function() return litup end)
            self:addMercy(50)
            local maketired = 0
            local line1 = "* The room got smokey!"
            local line2 = "* Other enemies became TIRED!"
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy ~= self and not enemy.tired then
                    enemy:setTired(true)
                    maketired = 1
                end
            end
            if maketired == 0 then
                cutscene:text(line1)
            else
                cutscene:text(line1 .. "\n" .. line2)
            end
        end)
        return
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Balthizard:onShortAct(battler, name)
    if name == "Standard" then
        self:addMercy(30)
        return "* " .. battler.chara:getName() .. " shakes Balthizard!"
    end
end

function Balthizard:onSpared()
    self:setAnimation("spared_overlay")
end

function Balthizard:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.lightup then
        return TableUtils.pick(self.dialogue_lightup)
    end

    return TableUtils.pick(self.dialogue)
end

function Balthizard:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if self.lightupmessage then
        self.lightupmessage = false
        return "* Balthizard burns with taco-scented excitement."
    end

    return super.getEncounterText(self)
end

function Balthizard:update()
    super.update(self)

    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        self.sprite.active = true
        self:setAnimation("idle")
    end

    if self.mercy >= 100 and not self.sprite.spareable then
        self.sprite.spareable = true
        self:setAnimation("spared")
    end
end

function Balthizard:getNextWaves()
    local balthizards = TableUtils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "balthizard" end)
    local enemys = TableUtils.filter(Game.battle:getActiveEnemies(), function(e) return e.id ~= "balthizard" end)
    if #balthizards >= 2 then
        return {"balthizard/incense_censer"}
    elseif #balthizards == 1 and self.lightup == true then
        return {"balthizard/incense_censer_only"}
    elseif #balthizards == 1 and #enemys >= 1 then
        return {"balthizard/incense_cloud_manager"}
    elseif #balthizards == 1 then
        return {"balthizard/incense_censer_only"}
	end
    return super.getNextWaves(self)
end

return Balthizard