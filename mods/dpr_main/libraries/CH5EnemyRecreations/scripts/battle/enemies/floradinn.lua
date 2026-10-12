local Floradinn, super = Class(EnemyBattler)

function Floradinn:init()
    super.init(self)

    self.name = "Floradinn"
    self:setActor("floradinn")
    self:setAnimation("idle")

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

    self.low_health_percentage = 1 / 4

    self:registerAct("Flatter", "60%\nMercy")
    self:registerAct("FlirtS", "Romance\nMercy?", "susie")
    self:registerAct("Convince", "TIRE\nenemy", "ralsei")

    self.bookcon = 0
    self.booktimer = 0
    self.book_x = -180
    self.book = nil

    self.flat_xscale = 1.8
    self.flattened = false
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
        Game.battle:startActCutscene(function(cutscene)
            Game:addFlag("floradinns_flattened", 1)
            self.dialogue_override = "Flowers,\nlast longer\nthan diamonds!"
            self.bookcon = 1
            Game.battle.timer:after(20 / 30, function() Assets.playSound("impact"); Game.battle:shakeCamera() end)
            Game.battle.timer:after(24 / 30, function() self:addMercy(60) end)
            if Game:getFlag("floradinns_flattened") == 1 then
                cutscene:text("* You pressed Floradinn in a book to make it MORE FLAT![wait:5] The memories will last forever...")
            else
                cutscene:text("* You flattened Floradinn!")
            end
            cutscene:wait(function() return self.booktimer >= 30 end)
            self.visible = true
            if not self:canSpare() then
                self:setSprite("postflattened")
            else
                self:setSprite("postflattened_pink")
            end
            self.book:remove()
            self.book = nil
            self.book_x = -180
            self.booktimer = 0
            self.bookcon = 0
            self.flattened = true
            self.actor.flattened = true
            if (self.flat_xscale < 3) then
                self.flat_xscale = self.flat_xscale + 0.2
            end
        end)
        return
    elseif name == "FlirtS" then
        Game.battle:startActCutscene(function(cutscene)
            local susie = Game.battle:getPartyBattler("susie")
            local susie_x, susie_y = susie:getRelativePos()
            Game:addFlag("floradinn_flirts", 1)
            self.dialogue_override = "Nice impression.\nReminds me of...\nFlowers."
            if Game:getFlag("floradinn_flirts") == 1 then
                cutscene:text("* Susie gets ready to FLIRT!")
                cutscene:battlerText(susie, {
                    "Heh,[wait:5] watch THIS.\nI'm way better\nat this now...!",
                    "...",
                    "'cept,[wait:5] I\nguess...[wait:5] if...",
                    "If me and Noelle are...\na thing...",
                    "I should probably...\nsave my flirts,[wait:5] right?"
                }, { right = true, x = susie_x + 100 - 31, y = susie_y + 40 - 1 }) -- exact correct bubble position
            else
                cutscene:text("* Susie abstains from flirting!")
            end
            self:addMercy(100)
            battler:setAnimation("flutter")
            susie:setAnimation("battle/idle_embarrassed")
            local offsets = battler:getActiveSprite():getOffset()
            local offsets_s = susie:getActiveSprite():getOffset()
            battler:actEffect(battler:getActiveSprite():getTexture(), offsets[1], offsets[2])
            susie:actEffect(susie:getActiveSprite():getTexture(), offsets_s[1], offsets_s[2])
            if Game:getFlag("floradinn_flirts") == 1 then
                cutscene:text("* Susie got psyched out![wait:5] You just did a flower impression instead!")
            else
                cutscene:text("* You did a flower impression!")
            end
        end)
        return
    elseif name == "Convince" then
        Game.battle:startActCutscene(function(cutscene)
            local ralsei = Game.battle:getPartyBattler("ralsei")
            local ralsei_x, ralsei_y = ralsei:getRelativePos()
            Game:addFlag("floradinns_convinced", 1)
            self.dialogue_override = "I'm tired.\nCan I just\nbeat someone up?"
            if Game:getFlag("floradinns_convinced") == 1 then
                cutscene:text("* Ralsei tried to CONVINCE Floradinn!")
                cutscene:battlerText(ralsei, {
                    "We don't want to\nfight you,[wait:5] Floradinn!",
                    "If you come to our side...\nwe can all be friends!"
                }, { right = true, x = ralsei_x + 100 + 30 - 31, y = ralsei_y + 40 + 20 - 3 }) -- exact correct bubble position
                cutscene:text("* (Floradinn agreed!)")
                if not self.flattened then
                    if not self:canSpare() then
                        self:setSprite("swordraise")
                    else
                        self:setSprite("swordraise_pink")
                    end
                else
                    if not self:canSpare() then
                        self:setSprite("swordraise_flattened")
                    else
                        self:setSprite("swordraise_pink_flattened")
                    end
                end
                cutscene:text("* (It's going to beat up everyone on its side!)")
                ralsei:setSprite("battle/hurt")
                ralsei:shake()
                cutscene:battlerText(ralsei, "Umm, w-wait!\nDon't do that!!", { right = true, x = ralsei_x + 100 - 31, y = ralsei_y + 40 - 3 }) -- exact correct bubble position
                ralsei:setAnimation("battle/idle")
            else
                cutscene:text("* Ralsei made a boring speech!")
            end
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                enemy:setTired(true)
            end
            if Game:getFlag("floradinns_convinced") == 1 then
                if not self.flattened then
                    if not self:canSpare() then
                        self:setSprite("disappointed")
                    else
                        self:setSprite("disappointed_spared")
                    end
                else
                    if not self:canSpare() then
                        self:setSprite("postflattened_disappointed")
                    else
                        self:setSprite("disappointed_flattened_pink")
                    end
                end
                cutscene:text("* (It seems confused...[wait:5] It became TIRED.)")
                if not self:canSpare() then
                    if not self.flattened then
                        self:setAnimation("idle")
                    else
                        self:setSprite("postflattened")
                    end
                else
                    self:setAnimation("spared")
                end
            else
                cutscene:text("* Floradinn became increasingly TIRED!!")
            end
        end)
        return
    elseif name == "Standard" then
        return self:onShortAct(battler, name)
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

function Floradinn:onSpared()
    self.actor.pink = true
    super.onSpared(self)
end

function Floradinn:onSpareable()
    self.actor.pink = true
    super.onSpareable(self)
end

function Floradinn:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Oddly,[wait:5] it doesn't actually smell like flowers.[wait:5] Just like vines or grass."
    end

    return super.getEncounterText(self)
end

function Floradinn:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if MathUtils.randomInt(101) < 3 then
        return "Do it for\nthe vine."
    end

    return TableUtils.pick(self.dialogue)
end

function Floradinn:update()
    if self.bookcon == 1 then
        self.booktimer = self.booktimer + DTMULT
        if self.booktimer <= 20 then
            self.book_x = MathUtils.lerp(self.book_x, -40, self.booktimer / 20)
            local x, y = self:getRelativePos()
            if not self.book then
                local book = Sprite("battle/enemies/floradinn/big_book", x + self.book_x, y - 20)
                book:setScale(2)
                book.layer = self.layer - 1
                self.book = Game.battle:addChild(book)
            end
            self.book.x = x + self.book_x
        elseif self.booktimer > 20 and self.booktimer < 24 then
            self.visible = false
            self.book:setFrame(2)
        elseif self.booktimer >= 24 then
            self.book:setFrame(3)
        end
    end

    super.update(self)
end

return Floradinn