local Leafling, super = Class(EnemyBattler)

function Leafling:init()
    super.init(self)

    self.name = "Leafling"
    self:setActor("leafling")
    self:setAnimation("idle")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 260

    self.spare_points = 10

    self.waves = {
        --"leafling/petal_burst",
        --"leafling/petal_wind"
    }

    self.dialogue = {
        "Fly away,\nfly away...",
        "Let the\nbreeze take you...",
        "Any way\nthe wind\nblows...",
        "Let's float,\nfloat through\nthe sky... ",
        "The world\nrevolves\nwith\nfreedom..."
    }
    self.dialogue_pinneddown = {
        "I'm too\nbusy for\nthis.",
        "I'll try\nand pencil\nit in.",
        "Sorry,[wait:5] I\nhave to\ntake a\ncall.",
        "Don't have\ntime to\ntalk now."
    }

    self.text = {
        "* Leafling dances freely on the wind.",
        "* Leafling sings in dandelion language.",
        "* Leafling flies into a scenery object and gets stuck for a while.",
        "* Leafling plays with ribbons of sunshine."
    }
    self.text_pinneddown = {
        "* Leafling stays staring at its newspaper.",
        "* Leafling checks for work notifications on the weekend.",
        "* Leafling doesn't take a lunch break.",
        "* Leafling grunts that it's going to be late."
    }

    self.low_health_text = "* Leafling looks shriveled."
    self.tired_text = "* Leafling seems to be breathing oxygen and not CO2."
	self.spareable_text = "* Leafling seems ready to be spared."

    self.low_health_percentage = 1 / 4

    self:registerAct("TurboSpin", "100% Mercy\nto all", nil, 64)
    self:registerAct("PinDown", "Make\nTIRED", "susie")
    self:registerAct("BlowAway", "Mash for\nMercy", "ralsei")

    self.pinneddown = false
end

function Leafling:isXActionShort(battler)
    return true
end

function Leafling:onAct(battler, name)
    if name == "Check" then
        if not self.pinneddown then
            return "* Leafling - An irresponsibly carefree leaf.[wait:5] It doesn't realize it creates its own wind."
        else
            return "* Leafling - A responsible leaf.[wait:5] The air feels stagnant around it."
        end
    elseif name == "TurboSpin" then
    elseif name == "PinDown" then
    elseif name == "BlowAway" then
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Leafling:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(35)
            local text = {
                "* Susie blows on a dandelion!",
                "* Susie slacks off!",
                "* Susie takes the wind face on!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(35)
            local text = {
                "* Ralsei counts petals daintily!",
                "* Ralsei floats fuzzily!",
                "* Ralsei puts soil in his hat!"
            }
            return TableUtils.pick(text)
        end
    end
    return nil
end

function Leafling:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        if not self.pinneddown then
            return "* Smells like sunshine and green."
        else
            return "* Smells like burnt leaves."
        end
    end

    if self.pinneddown then
        return TableUtils.pick(self.text_pinneddown)
    end

    return TableUtils.pick(self.text)
end

function Leafling:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.pinneddown then
        return TableUtils.pick(self.dialogue_pinneddown)
    end

    return TableUtils.pick(self.dialogue)
end

function Leafling:update()

    super.update(self)
end

return Leafling