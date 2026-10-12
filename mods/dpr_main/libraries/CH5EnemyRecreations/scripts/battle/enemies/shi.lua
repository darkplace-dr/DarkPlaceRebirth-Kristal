local Shi, super = Class(EnemyBattler)

function Shi:init()
    super.init(self)

    self.name = "Shi"
    self:setActor("shi")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 280
    self.spare_points = 10

    self.waves = {
        "floradinn/homing_triangle",
        "floradinn/mane_thorn"
    }

    self.check = {
        "YELLOW's yes-man.[wait:5] A scarecrow with super speed...[wait:5] that can't move.",
        "Supposed to be ORANGE's lackey,[wait:5] but they've never met.[wait:5] As it can't move."
    }

    self.text = {
        "* Shi is focusing its Chi,[wait:5] which it also calls its Shi.",
        "* Shi acts like it's jumping all over the place but does not actually move.",
        "* Shi lowers its hat and chuckles.[wait:5] \"Time to get serious...\"",
        "* Shi shouts \"heh,[wait:5] behind you!\" Then,[wait:5] doesn't actually move."
    }

    self.low_health_text = "* Shi leaks straw."
    self.tired_text      = "* Shi's movements finally slow."
	self.spareable_text  = "* Shi seems satisfied."

    self.low_health_percentage = 1 / 4

    self:registerAct("ActScared",  "30%\nMercy")
    self:registerAct("Intimidate", "Pose for\nMercy", "all")

    self.sadboy = false
end

function Shi:isXActionShort(battler)
    return true
end

function Shi:onAct(battler, name)
    if name == "Intimidate" then
        local intimidation = ShiIntimidate(self, battler)
        Game.battle:addChild(intimidation)
        return

    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            return  "* Susie hammers a bell!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(20)
            return "* Ralsei tapped a bell!"
        else
            self:addMercy(25)
            return "* "..battler.chara:getName().." hit the bell!"
        end
    end

    return super.onAct(self, battler, name)
end

function Shi:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            return  "* Susie hammers a bell!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(20)
            return "* Ralsei tapped a bell!"
        else
            self:addMercy(25)
            return "* "..battler.chara:getName().." hit the bell!"
        end
    end

    return super.onShortAct(self, battler, name)
end

function Shi:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.sadboy then
        self.dialogue = {
            "Uhh... don't\nlook at this.",
            "Oh, GROSS!\nSomeone's, uh...\neww! Bullets!",
            "Oh, no! That,\ngreen box!! Ugh!\nWhat IS that?"
        }
    else
        self.dialogue = {
            "HEH![wait:5] I'm on\nthat PSYCHO DRIFT![wait:5] Try\nand CATCH me!",
            "HEH![wait:5] Follow\nTHIS![wait:5] RISING...\nSUMMERSALT!!",
            "Real boys\ncan't do THIS!\nSONIC DASH!!!",
            "CROW KICK!\nHAH,[wait:5] did you see that?\nToo slow..."
        }
    end

    return TableUtils.pick(self.dialogue)
end

function Shi:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(100+1) < 3 then
        return "* Smells like straw."
    end

    if self.sadboy then
        return "* The opponent...\n* ... denies being the opponent."
    end

    return super.getEncounterText(self)
end

function Shi:update()
    super.update(self)

    if Game.battle.state == "ENEMYDIALOGUE" and not self.talksounddone then
    elseif Game.battle.state ~= "ENEMYDIALOGUE" then
    end
end

return Shi