local Terakota, super = Class(EnemyBattler)

function Terakota:init()
    super.init(self)

    self.name = "Terakota"
    self:setActor("terakota")
    self:setAnimation("transition")

    self.max_health = 1545
    self.health = 1545
    self.attack = 16
    self.defense = 0
    self.money = 400

    self.spare_points = 10

    self.waves = {
        --"floradinn/homing_triangle",
        --"floradinn/mane_thorn"
    }

    self.dialogue = {
        "GOLDHAIR\nGIVE WATER\n...[wait:5] FRAIND",
        "HUMAN...\nDIGGING\n...[wait:5] \nNO GOOD",
        "LITTLE\nDIRT\nNEVER\nHURT"
    }

    self.text = {
        "* Terakota thunders with each step.",
        "* Terakota offers a battle prayer to the Great Pumpkin.",
        "* Terakota attempts to dig bedrock.",
        "* Birds (from the song Weird Birds) land on Terakota peacefully."
    }

    self.low_health_text = "* Terakota's armor pH is out of wack."
    self.tired_text = "* Terakota's eyes (?) blink slowly."

    self.low_health_percentage = 1/4

    self:registerAct("WateringCan", "Waters\nplants", "all")
    self:registerAct("SlowerCan", "Waters\nslower")

    self.sprite.active = false
    self.transition_ended = false

    self.wateringcan = false
    self.slowercan = false

    self.savepot1hp = 5
    self.savepot2hp = 5
    self.savepot3hp = 5
    self.savepot4hp = 5
    self.savepot5hp = 5

    self.bonsaicon = 0
    self.bonsaitimer = 0

    self.attackalreadyseenbyplayer = false
    self.headballooncon = 0
    self.headballoontimer = 0
end

function Terakota:isXActionShort(battler)
    return true
end

function Terakota:onAct(battler, name)
    if name == "Check" then
        return "* TERAKOTA - A thick exterior.[wait:5] But it's what's inside that counts."

    elseif name == "WateringCan" or name == "SlowerCan" then
        self.wateringcan = true
        if name == "SlowerCan" then
            self.slowercan = true
        end
        return "* Use watering can droplets to turn all pots green!"

    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Terakota:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(18)
            local text = {
                "* Susie ate dirt unharmed!",
                "* Susie lifted pots!",
                "* Susie lifted weeds!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(18)
            local text = {
                "* Ralsei alters soil pH!",
                "* Ralsei does the worm!",
                "* Ralsei acts stone!"
            }
            return TableUtils.pick(text)
        end
    end
    return nil
end

function Terakota:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like fresh soil."
    end

    return super.getEncounterText(self)
end

function Terakota:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if not Game:getFlag("terakota_king_phrase") then
        Game:setFlag("terakota_king_phrase", true)
        return "PROTECT\n...[wait:5] KING"
    end

    return TableUtils.pick(self.dialogue)
end

function Terakota:update()
    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        self.sprite.active = true
        self:setAnimation("idle")
    end

    super.update(self)
end

return Terakota