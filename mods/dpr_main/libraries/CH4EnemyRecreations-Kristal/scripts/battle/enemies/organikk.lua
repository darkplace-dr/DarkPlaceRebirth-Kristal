local Organikk, super = Class(EnemyBattler)

function Organikk:init()
    super.init(self)

    self.name = "Organikk"
    self:setActor("organikk")

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

    self.low_health_percentage = 1/3

    self:registerAct("Perform", "Musical\nmercy")
    self:registerAct("Harmonize", "Musical,\ntouch\nGREEN", {"susie"})
    self:registerAct("Harmonize", "Musical,\ntouch\nGREEN", {"ralsei"})

    self.killable = true

    self.harmon_sound = nil
    self.harmonize = false
    self.chorus = false
    self.harmonize_highlight = false

    self.particle_timer = 0

    self.organsound = false
    self.organsoundtimer = 0
    self.organsoundplayed = {false, false, false}

    self.lullabied = 0

    self.showtempmercy = false
    self.mercyget = 0

    self.sprite.active = false

    local i = 1
    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy.id == self.id then
            self.sprite.siner = (i + 1) * 100
            self.sprite.siner_2 = i * 33
            i = i + 1
        end
    end
end

function Organikk:onAct(battler, name)
    if name == "Check" then -- doesn't have his name in capital letters so had to do that lool
        return "* Organikk - A philosopher. Why\nhe's fighting you is one of\nlife's questions."

    elseif name == "Perform" then
        battler:setAnimation("battle/act", function() battler:setAnimation("battle/idle") end) -- ends early, doesn't wait for act end

        for i = 1, 6 do
            local x = battler.x
            local y = battler.y - battler.height + MathUtils.randomInt(20)
            local particle = DazzleParticle(x, y)
            particle.layer = battler.layer - 0.01
            Game.battle:addChild(particle)
        end

        if Game.battle.wicabel_tuning then
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
        self.showtempmercy = true
        for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
            if enemy.mercy < 100 then
                enemy:addTemporaryMercy(1, true, {0, 100 - enemy.mercy}, (function() return self.showtempmercy == false end))
            end
        end
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

        -- DPR moment
        elseif battler.chara.id == "dess" then
            local notes = {"so", "do", "la", "fa", "mi", "do_a", "re", "ti"}
            for _, note in pairs(notes) do
                Assets.playSound("organ/"..note, 0.5)
            end

            self:addMercy(15)
            self.dialogue_override = "What a terrible\ncacophony!"
            return "* Dess played all sounds at once!"

        else
            self.organsound = true
            self:addMercy(20)
            return "* "..battler.chara:getName().." played random notes!"
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

    if MathUtils.randomInt(100) < 3 then
        return "* Smells like brass and satin."
    end

    return TableUtils.pick(self.text)
end

function Organikk:onTurnEnd()
    for _,enemys in ipairs(Game.battle:getActiveEnemies()) do
        if enemys.mercy >= 100 then
            enemys:setAnimation("spared")
        end
    end

    self.harmonize = false
    self.showtempmercy = false
    self.mercyget = 0
    self.mercyget2 = 0
end

function Organikk:update()
    super.update(self)

    if self.mercy >= 100 then
		self:setAnimation("spared")
	else
		self:setAnimation("idle")
	end

    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.sprite.active = true
        self.sprite.x = (math.sin(self.sprite.siner_2 / 1.5)) * 3
    end

    local king = TableUtils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "organikking" end)
    local other = TableUtils.filter(Game.battle:getActiveEnemies(), function(e) return e.id ~= "organikking" end)

    if self.harmonize and self.mercyget == 1 then
        self.id = "organikking"
        for _, attacker in ipairs(king) do
            attacker:addTemporaryMercy(1, false, {0, 100}, (function() return self.showtempmercy == false end))
        end
        self.mercyget = 0
    else
        self.id = "organikk"
    end

    if self.harmonize and self.mercyget2 == 1 then
        for _, attacker in ipairs(other) do
            attacker:addTemporaryMercy(1, false, {0, 100}, (function() return self.showtempmercy == false end))
        end
        self.mercyget2 = 0
    end

    if self.organsound then
        self.organsoundtimer = self.organsoundtimer + 1 * DTMULT

        if
            (self.organsoundtimer >= 1 and not self.organsoundplayed[1]) or
            (self.organsoundtimer >= 8 and not self.organsoundplayed[2]) or
            (self.organsoundtimer >= 15 and not self.organsoundplayed[3])
        then
            local notes = {"mi", "re", "so", "ti", "do", "do_a", "fa", "la"}
            for _, note in ipairs(notes) do
                Assets.stopSound("organ/" .. note)
            end
            local rand = MathUtils.randomInt(1, 8)
            Assets.playSound("organ/" .. notes[rand])
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
    self.showtempmercy = false
    self.mercyget = 0
    self.mercyget2 = 0

    self:getActiveSprite():stopShake()
    self.hurt_timer = -1
    self.defeated = true

    Assets.playSound("defeatrun")

    local sweat = Sprite("effects/defeat/sweat")
    sweat:setOrigin(0.5, 0.5)
    sweat:play(5/30, true)
    sweat.layer = 100
    self:addChild(sweat)

    Game.battle.timer:after(15/30, function()
        sweat:remove()
        self:getActiveSprite().run_away = true

        Game.battle.timer:after(15/30, function()
            self:remove()
        end)
    end)

    self:defeat("VIOLENCED", true)
end

return Organikk