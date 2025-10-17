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
    self.experience = 10
    self.spare_points = 10

    self.waves = {
        -- "organikk/notes",
        "organikk/longnotes"
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

    self.siner = MathUtils.random(100)

    self.harmonizing = false

    self.sound_timer = 0

    self.ralsei_sing = 1
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
        self.harmonizing = true
        return "* You tried to harmonize!\n* Touch the GREEN!"
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self.sound_timer = 1
            self:addMercy(20)
            return  "* Susie played random notes!"
        elseif battler.chara.id == "ralsei" then
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Ralsei sang sweetly!")
                Game.battle.music:pause()
                if self.ralsei_sing == 1 then
                    self.ralsei_sing = 2
                    Assets.playSound("ralseising1")
                else
                    self.ralsei_sing = 1
                    Assets.playSound("ralseising2")
                end
                battler:setAnimation("sing")
                cutscene:wait(4)
                Game.battle.music:resume()
                self:addMercy(50)
            end)
            return
        elseif battler.chara.id == "dess" then
            Assets.stopAndPlaySound("organ/mi", 0.5)
            Assets.stopAndPlaySound("organ/re", 0.5)
            Assets.stopAndPlaySound("organ/so", 0.5)
            Assets.stopAndPlaySound("organ/ti", 0.5)
            Assets.stopAndPlaySound("organ/do", 0.5)
            Assets.stopAndPlaySound("organ/do_a", 0.5)
            Assets.stopAndPlaySound("organ/fa", 0.5)
            Assets.stopAndPlaySound("organ/la", 0.5)
            self:addMercy(15)
            self.dialogue_override = "What a terrible\ncacophony!"
            return "* Dess played all sounds at once!"
        else
            self.sound_timer = 1
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

function Organikk:update()
    super.update(self)

    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.siner = self.siner + (1 / 6) * DTMULT
        self.x = self.init_x + (math.sin(self.siner / 1.5)) * 3
    end

    if Game.battle.state == "DEFENDINGEND" and self.harmonizing then
        self.harmonizing = false
    end

    if self.sound_timer > 0 and self.sound_timer < 16 then
        local function playSound()
            local rand = MathUtils.randomInt(7)
            if rand == 0 then
                Assets.stopAndPlaySound("organ/mi")
            elseif rand == 1 then
                Assets.stopAndPlaySound("organ/re")
            elseif rand == 2 then
                Assets.stopAndPlaySound("organ/so")
            elseif rand == 3 then
                Assets.stopAndPlaySound("organ/ti")
            elseif rand == 4 then
                Assets.stopAndPlaySound("organ/do")
            elseif rand == 5 then
                Assets.stopAndPlaySound("organ/do_a")
            elseif rand == 6 then
                Assets.stopAndPlaySound("organ/fa")
            elseif rand == 7 then
                Assets.stopAndPlaySound("organ/la")
            end
        end
        if self.sound_timer == 1 or self.sound_timer == 8 or self.sound_timer == 15 then
            playSound()
        end
        if self.sound_timer == 16 then
            self.sound_timer = 0
        end
        self.sound_timer = self.sound_timer + 1 * DTMULT
    end
end

return Organikk