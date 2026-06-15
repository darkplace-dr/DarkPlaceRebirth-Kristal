local Bibliox, super = Class(EnemyBattler)

function Bibliox:init()
    super.init(self)

    self.name = "Bibliox"
    self:setActor("bibliox")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 125
    self.experience = 0
    self.spare_points = 10

    self.waves = {
        "bibliox/book_attack"
    }

    self.dialogue = {
        "Mumble,\nmumble...",
        "To by, or\nnot to by?",
        "Lauren Ipsome,\nLauren Ipsome.",
        "It was the best\nof times, it\nwas the blurst\nof times.",
        "Human soles,\nmonster soles,\nBook soles...",
        "... whose do we?\nWhose do we\ndecimal..."
    }

    self.check = {"A worldly wizard that\ncast spells by spelling.", "Unfortunately prone to typos."}

    self.text = {
        "* Bibliox rearranges bookmarks in\nhis beard.",
        "* Bibliox conjures letters in the\nair.",
        "* Bibliox augurs with alphabet\nsoup.",
        "* Bibliox mumbles a hymn... but,\nthe lyrics were mistaken.",
        "* Bibliox is mumbling and\nbumbling."
    }
    self.low_health_text = "* Bibliox looks ragged."
    self.tired_text = "* Bibliox can't keep its pages\nopen."
	self.spareable_text = "* Bibliox's beard flaps happily."

    self.low_health_percentage = 1/3

    self:registerAct("Proofread", "Fix typo\nfor\nMERCY")
    self:registerAct("EasyProof", "More\ntime to\nfix", {"ralsei"})

    self.killable = true

    self.beardstroke = false
end

function Bibliox:isXActionShort(battler)
    return true
end

function Bibliox:onAct(battler, name)
    if name == "Proofread" or name == "EasyProof" then
        local iseasy = false
        if name == "EasyProof" then iseasy = true end
        local proofread = ProofreadController(self, iseasy)
        Game.battle:addChild(proofread)
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(15)
            return  "* Susie attempted to read!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(30)
            return "* Ralsei wore reading glasses!"
        else
            self:addMercy(25)
            return "* "..battler.chara:getName().." read something!"
        end
    end

    return super.onAct(self, battler, name)
end

function Bibliox:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(15)
            return  "* Susie attempted to read!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(30)
            return "* Ralsei wore reading glasses!"
        else
            self:addMercy(25)
            return "* "..battler.chara:getName().." read something!"
        end
    end

    return super.onShortAct(self, battler, name)
end

function Bibliox:getEncounterText()
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
        return "* Smells like parchment."
    end

    return TableUtils.pick(self.text)
end

function Bibliox:update()
    super.update(self)

    if Game.battle.state == "ENEMYDIALOGUE" and not self.beardstroke and self.mercy < 100 then
        self.beardstroke = true
        self:setAnimation("beard_stroke")
    elseif Game.battle.state == "DEFENDINGEND" and self.beardstroke then
        self.beardstroke = false
        self:setAnimation("idle")
    end
end

return Bibliox