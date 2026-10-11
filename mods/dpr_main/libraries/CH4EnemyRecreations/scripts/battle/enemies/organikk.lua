local Organikk, super = Class(EnemyBattler)

function Organikk:init()
    super.init(self)

    self.name = "Organikk"
    self:setActor("organikk")
    self:setAnimation("transition")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 150
    self.experience = 0
    self.spare_points = 10

    self.waves = {
        "organikk/pillars",
        "organikk/bar"
    }

    self.dialogue = {
        "I am the\nphilosopher.\nAmen.",
        "Listen!\nThe song of\nlegend plays.\nAmen.",
        "The truth\nsung in\nglass.\nAmen.",
        "The tale\nwhich must\nbe followed.",
        "The tail\nwhich must\nnot be\nfollowed.",
        "Do re mii\nDo re yuu\nDo re mon.\nAmen.",
        "It was\nglowing.\nThe voice\nwas glowing!",
        "What is\nDELTARUNE?",
        "What isn't\nDELTARUNE?",
        "What am I?\nAm I a butterfly?",
        "What am I?\nAm I a man?",
        "Why are we\nfighting?",
        "How could we\never make\npeace?"
    }

    self.text = {
        "* Organikk toots philosophically.",
        "* Organikk divinates through\necholocation.",
        "* Organikk claps with one hand.",
        "* Organikk considers the meaning\nof the stars and sky."
    }
    self.low_health_text = "* Organikk extolls the virtues of\nhaving low HP."
    self.tired_text = "* Organikk extolls the virtues of\nnaptime."
	self.spareable_text = "* Organikk extolls the virtues of\nmercy."

    self.low_health_percentage = 1 / 3

    self:registerAct("Perform", "Musical\nmercy")
    self:registerAct("Harmonize", "Musical,\ntouch\nGREEN", { "susie" })
    self:registerAct("Harmonize", "Musical,\ntouch\nGREEN", { "ralsei" })

    self.harmonize = false
    self.chorus = false
    self.harmonize_highlight = false
    self.harmonizer = false

    self.particle_timer = 0

    self.organsound = false
    self.organsoundtimer = 0
    self.organsoundplayed = {false, false, false}

    self.lullabied = 0

    self.wicabell_tuning = false

    self.sprite.active = false
    self.transition_ended = false
    self.idling = false

    local i = 1
    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy.id == self.id then
            self.sprite.siner = (i + 1) * 100
            self.sprite.siner2 = i * 33
            i = i + 1
        end
    end
end

function Organikk:onAct(battler, name)
    if name == "Check" then -- doesn't have his name in capital letters so had to do that lool
        return "* Organikk - A philosopher. Why\nhe's fighting you is one of\nlife's questions."

    elseif name == "Perform" then
        battler:setAnimation("battle/act", function() battler:setAnimation("battle/idle") end) -- ends early, doesn't wait for act end

        Game.battle.timer:after(2 / 30, function()
            for i = 1, 6 do
                local x, y = battler:getRelativePos()
                local particle = DazzleParticle(x + 40, y + 20 + MathUtils.randomInt(41))
                particle.layer = battler.layer - 1
                Game.battle:addChild(particle)
            end
        end)

        if self.wicabell_tuning then
            Assets.playSound("act_perform_better")
            self:addMercy(100)
            return "* You performed a tune! It was\nsuper effective!"
        else
            Assets.playSound("act_perform")
            self:addMercy(35)
            return "* You performed a tune! It was\nmildly effective!"
        end

    elseif name == "Harmonize" then
        self.harmonize = true
        self.harmonizer = true
        return "* You tried to harmonize!\n* Touch the GREEN!"
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self.organsound = true
            self:addMercy(20)
            return  "* Susie played random notes!"

        elseif battler.chara.id == "ralsei" then
            Game.battle:startActCutscene(function(cutscene)
                Game.battle.music:pause()

                local singy
                if self.lullabied == 0 then
                    singy = Assets.playSound("ralseising1")
                    self.lullabied = 1
                else
                    singy = Assets.playSound("ralseising2")
                    self.lullabied = 0
                end

                battler:setAnimation("sing")
                cutscene:text("* Ralsei sang sweetly!")
                singy:stop()
                Game.battle.music:resume()
                self:addMercy(50)
            end)
            return

        else
            self.organsound = true
            self:addMercy(20)
            return "* " .. battler.chara:getName() .. " played random notes!"
        end
    end

    return super.onAct(self, battler, name)
end

function Organikk:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.mercy >= 100 then
        return "The answer...\n... was LOVE?"
    end

    return TableUtils.pick(self.dialogue)
end

function Organikk:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like brass and satin."
    end

    return super.getEncounterText(self)
end

function Organikk:setIdling(bool)
    self.idling = bool
    if self.idling then
        self:setAnimation("idle")
    elseif not self.idling then
        if self.mercy >= 100 then
            self:setAnimation("spared")
        end
    end
end

function Organikk:onSpareable()
    self:setIdling(false)
end

function Organikk:onTurnEnd()
    self.harmonize = false
end

function Organikk:update()
    super.update(self)

    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        self.sprite.active = true
        self:setIdling(true)
    end

    local do_always = { "DEFENDINGBEGIN", "DEFENDING" }
    if TableUtils.contains(do_always, Game.battle.state) and not self.idling then
        self:setIdling(true)
    elseif not TableUtils.contains(do_always, Game.battle.state) and self.idling and self.mercy >= 100 then
        self:setIdling(false)
    end

    if self.idling then
        self.sprite.x = self.sprite.init_x + (math.sin(self.sprite.siner2 / 1.5)) * 3
    end

    if self.organsound then
        self.organsoundtimer = self.organsoundtimer + DTMULT

        if
            (self.organsoundtimer >= 1 and not self.organsoundplayed[1]) or
            (self.organsoundtimer >= 8 and not self.organsoundplayed[2]) or
            (self.organsoundtimer >= 15 and not self.organsoundplayed[3])
        then
            local notes = {"mi", "re", "so", "ti", "do", "do_a", "fa", "la"}
            for _, note in ipairs(notes) do
                Assets.stopSound("organ/" .. note)
            end
            Assets.playSound("organ/" .. TableUtils.pick(notes))
            if self.organsoundtimer >= 1  then self.organsoundplayed[1] = true end
            if self.organsoundtimer >= 8  then self.organsoundplayed[2] = true end
            if self.organsoundtimer >= 15 then self.organsoundplayed[3] = true end
        end

        if self.organsoundtimer >= 16 then
            self.organsoundtimer = 0
            self.organsoundplayed = {false, false, false}
            self.organsound = false
        end
    end
end

function Organikk:getNextWaves()
    local any_enemy_harmonize, any_enemy_selected_pillar = false, false
    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy.id == "organikk" and enemy ~= self then
            if not any_enemy_harmonize and enemy.harmonize then any_enemy_harmonize = true end
            if not any_enemy_selected_pillar and enemy.selected_wave == "organikk/pillars" then any_enemy_selected_pillar = true end
            if any_enemy_harmonize and any_enemy_selected_pillar then break end
        end
    end

    if self.harmonize then
        return {"organikk/bar_harmonize"}
    elseif any_enemy_harmonize then
        return {"organikk/nothing"}
    elseif any_enemy_selected_pillar then
        return {"organikk/bar"}
    else
        return self.waves
    end
end

function Organikk:onDefeatRun(damage, battler)
    self.harmonize = false

    super.onDefeatRun(self, damage, battler)
end

return Organikk