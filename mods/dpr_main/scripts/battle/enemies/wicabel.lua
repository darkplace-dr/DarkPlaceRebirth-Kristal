local Wicabel, super = Class(EnemyBattler)

function Wicabel:init()
    super.init(self)

    self.name = "Wicabel"
    self:setActor("wicabel")

    self.max_health = 470
    self.health = 470
    self.attack = 13
    self.defense = 0
    self.money = 160
    self.experience = 10
    self.spare_points = 10

    self.waves = {
        --"wicabel/penduluma"
    }

    self.dialogue = {
        "Bubell, \nbubell,\ntoil and\ntrubell.",
        "Trembell\nwith\ntrebell.",
        "Wobbell,\nrumbell,\ntinkle and\ntumbell!",
        "Lament-a-bell,\nMiser-a-bell,\nUn-stop-a-bell!"
    }

    self.check = "A metal mage. When\nout of tune, she's\nunpredictabell."

    self.text = {
        "* Wicabel rings a haunting hex.",
        "* Wicabel creates a cursing\nclamor.",
        "* Wicabel spins like a musicbox\nballerina.",
        "* Wicabel emits classical music."
    }
    self.low_health_text = "* Wicabel harkens hexes hoarsely."
    self.tired_text = "* Wicabel chimes a sleeping\nspell."
	self.spareable_text = "* Wicabel plays peacefully."

    self.low_health_percentage = 1/3

    self:registerAct("Tuning", "Good\ntiming=\nmercy")
    self:registerAct("Tuningx2", "Tuning\ntwice", {"susie"})

    self.killable = true
end

function Wicabel:isXActionShort(battler)
    return true
end

function Wicabel:onAct(battler, name)
    if name == "Tuning" or name == "Tuningx2" then
        local isdouble = false
        if name == "Tuningx2" then isdouble = true end
        local tuning = WicabelTuning(self, battler, isdouble)
        Game.battle:addChild(tuning)
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

function Wicabel:onShortAct(battler, name)
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

function Wicabel:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.mercy >= 100 then
        return "I am humbelled."
    end

    return TableUtils.pick(self.dialogue)
end

function Wicabel:getEncounterText()
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
        return "* Smells like damp wood and rust."
    end

    return TableUtils.pick(self.text)
end

return Wicabel