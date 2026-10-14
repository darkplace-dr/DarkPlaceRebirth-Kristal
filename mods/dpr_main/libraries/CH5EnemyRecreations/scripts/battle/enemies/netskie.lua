local Netskie, super = Class(EnemyBattler)

function Netskie:init()
    super.init(self)

    self.name = "Netskie"
    self:setActor("netskie")
    self:setAnimation("transition")

    self.max_health = 1545
    self.health = 1545
    self.attack = 16
    self.defense = 0
    self.money = 444

    self.spare_points = 10

    self.waves = { --[["netskie/pawprint"]] }

    self.dialogue = {
        "Kon kon~\nKee kee~",
        "(Swisches my big\nfluffy $$$$-ing\ntail)",
        "(Stamp!)\nApproved as\ngullible...",
        "A fox would never\nenjoy tricking\nanyone~"
    }

    self.text = {
        "* Netskie swisches its big fluffy tail (which it has).",
        "* Netskie stamps (kan) and stomps (kon).",
        "* Netskie scratches where a heart had been carved in it.",
        "* Netskie does a tricky trick![wait:5] (Kickflip?)"
    }

    self.low_health_text = "* Netskie is peeling."
    self.tired_text = "* Netskie is snoring like a log."
    self.spareable_text = "* Netskie laughs spareably."

    self.low_health_percentage = 1 / 4

    self:registerAct("Faker", "Touch fake\nbullets", "all")
    self:registerShortAct("Impression", "Slight\nMercy")

    self.sprite.active = false
    self.transition_ended = false

    self.faker_type = 0
end

function Netskie:isXActionShort(battler)
    return true
end

function Netskie:onAct(battler, name)
    if name == "Check" then
        return "* NETSKIE - Tail looks like this[image:ui/battle/check/netskie_tail, 10, -3, 2, 2, 3 / 30]"

    elseif name == "Faker" then
        self.faker_type = TableUtils.pick({ 1, 2, 3 })
        return "* You tried to break the enemy's ruse!\n* Touch the FAKE BULLETS!"

    elseif name == "Impression" or name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Netskie:onShortAct(battler, name)
    if name == "Impression" then
        if #Game.battle:getActiveParty() == 1 then
            self:addMercy(30)
        else
            self:addMercy(10)
        end
        local ox = 80 / 2
        local rand = TableUtils.pick({ 0, 1, 2 })
        if rand == 0 then
            battler:setActSprite("party/kris/dark/chicken", -2 + ox, -1 + 12 / 2, 1 / 5)
            return "* Your Berdly impression!"
        elseif rand == 1 then
            battler:setActSprite("party/kris/dark/wiggle", -2 + ox - 2, -1 - 7, 1 / 5)
            return "* Your Jockington impression!"
        elseif rand == 2 then
            battler:setActSprite("party/kris/dark/susie_pose_2", -2 + ox, -1)
            return "* Your Susie impression!"
        end

    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(29)
            else
                self:addMercy(9)
            end
            local rand = TableUtils.pick({ 0, 1, 2 })
            if rand == 0 then
                battler:setActSprite("party/susie/dark/laugh_spin", -3 - 18 / 2, -1 + 25 / 2, 1 / 3)
                return "* Susie's Lancer impression!"
            elseif rand == 1 then
                battler:setActSprite("party/susie/dark/kris_pose", -3, -1)
                return "* Susie's Kris impression!"
            elseif rand == 2 then
                battler:setActSprite("party/susie/dark/ralsei_pose", -3, -1)
                return "* Susie's Ralsei impression!"
            end

        elseif battler.chara.id == "ralsei" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(29)
            else
                self:addMercy(9)
            end
            local ox, oy = 80 / 2 - 10 / 2, -30 / 2
            local rand = TableUtils.pick({ 0, 1 })
            if rand == 0 then
                if battler.actor:getSpritePath() ~= "party/ralsei/dark_ch1" then
                    battler:setActSprite("party/ralsei/dark/impressionist_painting", -2 + ox, -6 + oy)
                else
                    battler:setActSprite("party/ralsei/dark_ch1/impressionist_painting", -3 + ox, -2 + oy)
                end
                return "* Ralsei's Impressionist art!"
            elseif rand == 1 then
                if battler.actor:getSpritePath() ~= "party/ralsei/dark_ch1" then
                    battler:setActSprite("party/ralsei/dark/impressionist_fossil", -2 + ox, -6 + oy)
                else
                    battler:setActSprite("party/ralsei/dark_ch1/impressionist_fossil", -3 + ox, -2 + oy)
                end
                return "* Ralsei's impression fossil!"
            end
        end
    end
end

function Netskie:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like wood."
    end

    return super.getEncounterText(self)
end

function Netskie:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if not Game:getFlag("netskie_original_phrase") and self.faker_type > 0 then
        Game:setFlag("netskie_original_phrase", true)
        return "I'M the Original!\nKon,[wait:5] kon,[wait:5] kee kee!"
    end

    return TableUtils.pick(self.dialogue)
end

function Netskie:update()
    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        self.sprite.active = true
        self:setAnimation("idle")
    end

    super.update(self)
end

return Netskie