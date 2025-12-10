local Balthizard, super = Class(EnemyBattler)

function Balthizard:init()
    super.init(self)

    self.name = "Balthizard"
    self:setActor("balthizard")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 130
    self.experience = 10
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

    self.low_health_percentage = 1/3

    self:registerAct("Shake", "Left &\nRight=\nMercy")
    self:registerAct("ShakeX", "Left &\nRight=\nMercy", {"susie"})
    self:registerAct("LightUp", "50% &\nTIRE\nothers", {"ralsei"})
    --self:registerAct("OldMan", "I'm\nold!") -- he's old

    self.killable = true

    self.lightuptimer = 0
    self.lightuptime = false

    self.fires = {}

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
        if not self.sprite.lightup then
            self.dialogue_override = "[speed:0.5]A nice\nmassage."
        else
            self.dialogue_override = "What a\nblast!\nHoh hoh!"
        end
        return
    elseif name == "LightUp" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* Ralsei lit up!")
            self.lightuptime = true
            cutscene:wait(function() return self.lightuptimer >= 50 end)
            self.lightuptime = false
            self.lightuptimer = 0
            self:addMercy(50)
            local line1 = "* The room got smokey!"
            local line2 = "* Other enemies became TIRED!"
            local madetired = 0
            for _,enemy in ipairs(Game.battle.enemies) do
                if enemy ~= self then
                    if not enemy.tired then
                        madetired = madetired + 1
                        enemy:setTired(true)
                    end
                end
            end
            if madetired == 0 then
                cutscene:text(line1)
            else
                cutscene:text(line1.."\n"..line2)
            end
            self.dialogue_override = "Ah! That\nwakes\nme up!!!"
        end)
        return
    elseif name == "Standard" then
        self:addMercy(30)
        return "* "..battler.chara:getName().." shakes Balthizard!"
    end

    return super.onAct(self, battler, name)
end

function Balthizard:onShortAct(battler, name)
    if name == "Standard" then
        self:addMercy(30)
        return "* "..battler.chara:getName().." shakes Balthizard!"
    end

    return super.onShortAct(self, battler, name)
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

    if self.sprite.lightup then
        return TableUtils.pick(self.dialogue_lightup)
    end

    return TableUtils.pick(self.dialogue)
end

function Balthizard:getEncounterText()
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

    if self.lightupmessage then
        self.lightupmessage = false
        --self.lightup = false
        return "* Balthizard burns with taco-scented excitement."
    end

    return TableUtils.pick(self.text)
end

function Balthizard:update()
    super.update(self)

    if self.mercy >= 100 and not self.sprite.spareable then
        self.sprite.spareable = true
        self:setAnimation("spared")
    end

    if self.lightuptime then
        local ralsei = Game.battle:getPartyBattler("ralsei")
        if self.lightuptimer == 0 then
            ralsei:setSprite("battle/spell")
            ralsei.sprite:play(1/15, false, function() ralsei:setSprite("battle/spellend") end)
        end
        if self.lightuptimer == 16 or self.lightuptimer == 22 or self.lightuptimer == 28 or self.lightuptimer == 34 then
            local b = 0
            local rand = MathUtils.randomInt(30)
            Assets.playSound("wing")
            for i = 1, 9 do
                local fire = BalthizardFire(ralsei.x + 34, ralsei.y - 70) -- ehh seems somewhat correct at least
                fire.physics.direction = -math.rad(b * 45 + rand)
                fire.physics.speed = 14
                fire.physics.gravity_direction = -math.rad(270)
                fire.physics.gravity = 0.4
                fire:setScale(1.5)
                fire.layer = ralsei.layer + 0.1
                Game.battle:addChild(fire)
                table.insert(self.fires, fire)
                b = b + 1
            end
        end
        if self.lightuptimer == 18 then
            local screenflash = BalthizardScreenFlash(self.fires)
            Game.battle:addChild(screenflash)
        end
        if self.lightuptimer == 38 then
            ralsei:setAnimation("battle/idle")
            Assets.playSound("rocket", 0.9, 0.9)
            self.lightup = true
            self.lightupmessage = true
            self.sprite.lightup = true
        end
        self.lightuptimer = self.lightuptimer + 1 * DTMULT
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