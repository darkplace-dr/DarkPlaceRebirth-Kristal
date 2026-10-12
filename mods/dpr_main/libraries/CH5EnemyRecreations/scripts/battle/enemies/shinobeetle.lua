local Shinobeetle, super = Class(EnemyBattler)

function Shinobeetle:init()
    super.init(self)

    self.name = "Shinobeetle"
    self:setActor("shinobeetle")
    self:setAnimation("transition")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 320

    self.spare_points = 10

    self.waves = {
        --"floradinn/homing_triangle",
        --"floradinn/mane_thorn"
    }

    self.dialogue = {
        "The sound\nof reeds,\nhelter and\nskelter.",
        "Blackbirds,\ncalling to\nthe dead\nof night.",
        "Rice,\nwhere a\nwedding\nhad been.",
        "Love me...\nDO!!!!"
    }
    self.dialogue_alone_first_turn = {
        "Oh,[wait:5] am I alone?\nCan I quit being\na ninja now?",
        "Ah,[wait:5] I'm by\nmyself?[wait:5] That's\na relief!",
        "Phew,[wait:5] it's just\nme?[wait:5] Time to think\nfor yourself!"
    }
    self.dialogue_alone = {
        "Peace\nand\nlove!",
        "Could I get\na little help\nfrom my friends?",
        "I'm happy\njust to dance\nwith you!"
    }

    self.text = {
        "* Shinobeetle waits for the other enemies to pose,[wait:5] then copies them.",
        "* Shinobeetle polishes its bronzed shurakins.",
        "* Shinobeetle says \"nin\", then runs around on tiptoes.",
        "* Shinobeetle spreads diatomaceous earth caltrops."
    }
    self.text_alone = {
        "* Shinobeetle happily cuts a pizza with a non-ninja sai.",
        "* Shinobeetle uses its regular alone-time smoke bombs.",
        "* Shinobeetle creeps through shadows and cracks.",
        "* Shinobeetle uses a kunai as a bookmark."
    }

    self.low_health_text = "* Shinobeetle flips on its back helplessly."
    self.tired_text = "* Shinobeetle conceals its exhaustion with ninja techniques."

    self.low_health_percentage = 1/4

    self:registerAct("Convince", "35%\nMercy")

    self.sprite.active = false
    self.transition_ended = false

    self.first_turn_alone = false
    self.alone = false
    self.convince_count = 0
    self.puppydogeyes = 0
end

function Shinobeetle:isXActionShort(battler)
    return true
end

function Shinobeetle:onAct(battler, name)
    if name == "Check" then
        return "* SHINOBEETLE - Only a ninja by Seth's command.[wait:5] The only thing keeping the ruse is peer pressure."

    elseif name == "Convince" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* You told Shinobeetle to come to your side!")
            self.convince_count = self.convince_count + 1
            if self.convince_count >= 5 then
                self:addMercy(100)
                cutscene:text("* You CONVINCED Shinobeetle...[wait:5] this time,[wait:5] with puppy dog eyes!")
                if self.puppydogeyes == 0 then
                    self.puppydogeyes = 1
                end
            else
                self:addMercy(35)
                if #Game.battle:getActiveEnemies() > 1 then
                    cutscene:text("* But,[wait:5] the enemy was too nervous!")
                else
                    cutscene:text("* ...[wait:5] but,[wait:5] the enemy already wants to do that!")
                end
            end
        end)
        return
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
    end
end

function Shinobeetle:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(20)
            end
            local text = {
                "* Susie flips over a beetle!",
                "* Susie encourages beetles to fight!",
                "* Susie catches bugs with her hands!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(20)
            end
            local text = {
                "* Ralsei unseals a cup jelly!",
                "* Ralsei pretends to be a root veg!",
                "* Ralsei listens to a white album!"
            }
            return TableUtils.pick(text)
        end
    end
    return nil
end

function Shinobeetle:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if #Game.battle:getActiveEnemies() == 1 then
        return TableUtils.pick(self.text_alone)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like roasted chestnuts."
    end

    return super.getEncounterText(self)
end

function Shinobeetle:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if #Game.battle:getActiveEnemies() > 1 then
        return TableUtils.pick(self.dialogue)
    else
        if self.first_turn_alone == false then
            self.first_turn_alone = true
            return TableUtils.pick(self.dialogue_alone_first_turn)
        else
            return TableUtils.pick(self.dialogue_alone)
        end
    end
end

function Shinobeetle:update()
    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        self.sprite.active = true
        self:setAnimation("idle")
    end

    if #Game.battle:getActiveEnemies() == 1 then
        if self.alone == false and self.done_state == nil then
            self.alone = true
            self:addMercy(100)
        end
    end

    super.update(self)
end

return Shinobeetle