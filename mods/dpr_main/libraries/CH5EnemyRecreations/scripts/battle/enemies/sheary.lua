local Sheary, super = Class(EnemyBattler)

function Sheary:init()
    super.init(self)

    self.name = "Sheary"
    self:setActor("sheary")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 340

    self.spare_points = 10

    self.waves = { --[[\"sheary/scissor_attack"]] }

    self.firstturnballoon = false

    self.dialogue = {
        "Kris:\nShort-Hair?\nLong-Hair?\nNo-Where?",
        "Susie:\nWash-hair?\nHair-wash?\nCar-wash?",
        "Ralsei:\nHot-Shave?\nHot-Wax?\nHot-Shock?",
        "Noelle:\nSnow-Flake?\nSnow-Flake?"
    }

    self.text = {
        "* Sheary rotates like a barber pole.",
        "* Sheary stocks gardening and paranormal magazines as reading material.",
        "* A Floradinn comes by,[wait:5] sees there's 3 people in line,[wait:5] sighs,[wait:5] and leaves.",
        "* Sheary briefly forgets they're not an overworld obstacle."
    }

    self.low_health_text = "* Sheary refuses to run.[wait:5] (It'd be dangerous.)"
    self.tired_text = "* Sheary looks ready to shear sheep."
    self.spareable_text = "* Sheary dances spareably."

    self.low_health_percentage = 1 / 4

    self:registerAct("SalonCut", "Relaxed\ncut", "all")
    self:registerAct("ValueCut", "Cut\nquick!", "susie")
    self:registerAct("HyperCut", "Cut\nFAST!!!")

    self.acttimer = 0
    self.cuttextcon = 0
    self.cuttexttimer = 30
    self.mercy_to_add = 0

    self.saloncut = false
    self.valuecut = false
    self.hypercut = false
    self.truancy = false
end

function Sheary:isXActionShort(battler)
    return true
end

function Sheary:onAct(battler, name)
    if name == "Check" then
        return "* SHEARY - An elegant dancer with sharp legs.[wait:5] Part of Blue's dance troupe,[wait:5] which Aqua also attends."

    elseif name == "SalonCut" or name == "ValueCut" or name == "HyperCut" then
        if name == "SalonCut" then
            self:salonCutSprites()
            self.saloncut = true
        elseif name == "ValueCut" then
            self.valuecut = true
        elseif name == "HyperCut" then
            self.hypercut = true
        end
        Game.battle:addChild(ScissorsActController(self))
        return

    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Sheary:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            local oy = -2 / 2
            battler:setActSprite("party/susie/dark/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -3 - 18, -1 - 2 + oy)
            return "* Susie received a haircut!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            if battler.actor:getSpritePath() == "party/ralsei/dark_ch1" then
                local ox, oy = -2 / 2, -6 / 2
                battler:setActSprite("party/ralsei/dark_ch1/hairs_" .. TableUtils.pick({ 1, 2, 3 }), -3 + ox, -2 + oy)
            else
                local oy = -2 / 2
                battler:setActSprite("party/ralsei/dark/hairs_" .. TableUtils.pick({ 1, 2, 3, 4 }), -2 + 1, -6 + 2 + oy)
            end
            return "* Ralsei received a haircut!"
        end
    end
end

function Sheary:salonCutSprites()
    for _, battler in ipairs(Game.battle.party) do
        if battler.chara.id == "kris" then
            battler:setActSprite("party/kris/dark/papersnow", -2, -1)
        elseif battler.chara.id == "susie" then
            battler:setActSprite("party/susie/dark/papersnow", -3 + 5, -1 + 2)
        elseif battler.chara.id == "ralsei" then
            battler:setActSprite("party/ralsei/dark/papersnow", -2, -6 + 6)
        end
    end
end

function Sheary:onTurnEnd()
    self.saloncut = false
    self.valuecut = false
    self.hypercut = false
end

function Sheary:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like freshly cut grass."
    end

    return super.getEncounterText(self)
end

function Sheary:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.firstturnballoon == false then
        self.firstturnballoon = true
        self.dialogue_bubble = "sheary_special"
        return "Half-Off?\nOff-Half?"

    else
        local dialogue = TableUtils.pick(self.dialogue)
        if dialogue == self.dialogue[4] then
            self.dialogue_bubble = "sheary"
        else
            self.dialogue_bubble = "sheary_long"
        end
        return dialogue
    end
end

return Sheary
