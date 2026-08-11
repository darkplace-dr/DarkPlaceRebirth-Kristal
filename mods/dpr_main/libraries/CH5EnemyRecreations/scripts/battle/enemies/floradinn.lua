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
        "* Floradinn mutters how it likes flowers,[wait:5] then remembers it's a flower and smiles.", 
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
        local wave = Utils.pick(waves)
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
        return "* Floradinn - Flowers are sweeter than diamonds...[wait:5] so it thinks." 
        
    elseif name == "Flatter" then
        self:addMercy(60)
        Game:addFlag("floradinns_flattened", 1)
		self.flattened = true
        self.dialogue_override = "Flowers,\nlast longer\nthan diamonds!"
        if Game:getFlag("floradinns_flattened") == 1 then
            return "* You pressed Floradinn in a book to make it MORE FLAT![wait:5] The memories will last forever..."
        else
            return "* You flattened Floradinn!"
        end
        
    elseif name == "FlirtS" then
        self:addMercy(100)
        self.dialogue_override = "Nice impression.\nReminds me of...\nFlowers."
        
        if not Game:getFlag("floradinn_flirts") then
            Game:setFlag("floradinn_flirts", true)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Susie gets ready to FLIRT!")
                cutscene:text("* Heh, watch THIS. I'm way better at this now...!", "smirk", "susie")
                cutscene:text("* ...", "neutral", "susie")
                cutscene:text("* 'cept, I guess... if...", "shy", "susie")
                cutscene:text("* If me and Noelle are... a thing...", "shy_down", "susie")
                cutscene:text("* I should probably... save my flirts, right?", "nervous_side", "susie")
                cutscene:text("* Susie got psyched out! You just did a flower impression instead!")
            end)
            return
        else
            return "* Susie abstains from flirting!\n* You did a flower impression!"
        end
        
    elseif name == "Convince" then
        self:setTired(true)
        self.dialogue_override = "I'm tired.\nCan I just\nbeat someone up?"
        -- don't even think ralsei is in the game, but for completetion's sake
        if not Game:getFlag("floradinn_convince") then
            Game:setFlag("floradinn_convince", true)
            Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Ralsei tried to CONVINCE Floradinn!")
                cutscene:text("* We don't want to fight you, Floradinn!", "pleased", "ralsei")
                cutscene:text("* If you come to our side... we can all be friends!", "smile", "ralsei")
                cutscene:text("* (Floradinn agreed!)")
                cutscene:text("* (It's going to beat up everyone on its side!)")
                cutscene:text("* Umm, w-wait! Don't do that!!", "shock", "ralsei")
                cutscene:text("* (It seems confused... It became TIRED.)")
            end)
            return
        else
            return "* Ralsei made a boring speech!\n* Floradinn became increasingly TIRED!"
        end
        
    elseif name == "Standard" then
        self:addMercy(40)
        if battler.chara.id == "susie" then
            local text = {
                "* Susie sniffed wildly!",
                "* Susie blasts hose water!",
                "* Susie sneezes from pollen!"
            }
            return Utils.pick(text)
        elseif battler.chara.id == "ralsei" then
            local text = {
                "* Ralsei pretends to be a bee!",
                "* Ralsei waters daintily!",
                "* Ralsei combs petals!"
            }
            return Utils.pick(text)
        else

            return "* "..battler.chara:getName().." does a flower impression!"
        end
    end
end

function Floradinn:onShortAct(battler, name)
    if name == "Standard" then
        self:addMercy(40)
        if battler.chara.id == "susie" then
            local text = {
                "* Susie sniffed wildly!",
                "* Susie blasts hose water!",
                "* Susie sneezes from pollen!"
            }
            return Utils.pick(text)
        elseif battler.chara.id == "ralsei" then
            local text = {
                "* Ralsei pretends to be a bee!",
                "* Ralsei waters daintily!",
                "* Ralsei combs petals!"
            }
            return Utils.pick(text)
        else

            return "* "..battler.chara:getName().." poses like a flower!"
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

    if math.random(1, 100) <= 3 then
        return "* Oddly,[wait:5] it doesn't actually smell like flowers.[wait:5] Just like vines or grass."
    end

    return Utils.pick(self.text)
end

function Floradinn:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if math.random(1, 100) <= 3 then
        return "Do it for\nthe vine."
    end

    return Utils.pick(self.dialogue)
end

return Floradinn
