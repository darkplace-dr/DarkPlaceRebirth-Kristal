local Floradinn, super = Class(EnemyBattler)

function Floradinn:init()
    super.init(self)

    self.name = "Floradinn"
    self:setActor("floradinn")

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

    self.dialogue = {
        "I'm better than\na normal person.",
        "Flowers over\nboys.",
        "Face my\nFlower Cutter!",
        "We are after\nyour dad!"
    }

    self.text = {
        "* Floradinn is thinking out loud about your dad.",
        "* Floradinn mutters how it likes flowers,[wait:5] then remembers it's a flower and smiles.", -- yes the wait thing is in Deltarune. Yes I was surprised too
        "* Floradinn considers arranging itself beautifully with other enemies.",
        "* Floradinn has strong opinions about flowers."
    }

    self.low_health_text = "* Floradinn seems totally sapped."
    self.tired_text = "* Floradinn is ready to close up and sleep."
	self.spareable_text = "* Floradinn is in full blossom."

    self.low_health_percentage = 1/4

    self:registerAct("Flatter", "60%\nMercy")
    self:registerAct("FlirtS", "Romance\nMercy?", "susie")
    self:registerAct("Convince", "TIRE\nenemy", "ralsei")
	self:setAnimation("idle")
end

function Floradinn:selectWave()
    local waves = self:getNextWaves()

    if waves and #waves > 0 then
        local wave = TableUtils.pick(waves)
        if self.flattened or self:canSpare() then
            wave = "floradinn/homing_triangle"
        end
        self.selected_wave = wave
        return wave
    end
end

function Floradinn:isXActionShort(battler)
    return true
end

function Floradinn:onAct(battler, name)
    if name == "Check" then
        return "* Floradinn - Flowers are sweeter than diamonds...[wait:5] so it thinks." -- name is not in full uppercase so had to do that
    elseif name == "Flatter" then
        Game:addFlag("floradinns_flattened", 1)
		self.flattened = true
        self.dialogue_override = "Flowers,\nlast longer\nthan diamonds!"
        if Game:getFlag("floradinns_flattened") == 1 then
            return "* You pressed Floradinn in a book to make it MORE FLAT![wait:5] The memories will last forever..."
        else
            return "* You flattened Floradinn!"
        end
    elseif name == "FlirtS" then
        self.dialogue_override = "Nice impression.\nReminds me of...\nFlowers."
        return
    elseif name == "Convince" then
        self.dialogue_override = "I'm tired.\nCan I just\nbeat someone up?"
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            local text = {
                "* Susie sniffed wildly!",
                "* Susie blasts hose water!",
                "* Susie sneezes from pollen!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            local text = {
                "* Ralsei pretends to be a bee!",
                "* Ralsei waters daintily!",
                "* Ralsei combs petals!"
            }
            return TableUtils.pick(text)
        end
    end
end

function Floradinn:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            local text = {
                "* Susie sniffed wildly!",
                "* Susie blasts hose water!",
                "* Susie sneezes from pollen!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            local text = {
                "* Ralsei pretends to be a bee!",
                "* Ralsei waters daintily!",
                "* Ralsei combs petals!"
            }
            return TableUtils.pick(text)
        end
    end
    return nil
end

function Floradinn:getEncounterText()
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

    if MathUtils.randomInt(100 + 1) < 3 then
        return "* Oddly,[wait:5] it doesn't actually smell like flowers.[wait:5] Just like vines or grass."
    end

    return TableUtils.pick(self.text)
end

function Floradinn:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if MathUtils.randomInt(100 + 1) < 3 then
        return "Do it for\nthe vine."
    end

    return TableUtils.pick(self.dialogue)
end

return Floradinn