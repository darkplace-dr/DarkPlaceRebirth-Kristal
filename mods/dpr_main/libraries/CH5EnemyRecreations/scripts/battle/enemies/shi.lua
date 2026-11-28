local Shi, super = Class(EnemyBattler)

function Shi:init()
    super.init(self)

    self.name = "Shi"
    self:setActor("shi")

    self.max_health = 515
    self.health = 515
    self.attack = 16
    self.defense = 0
    self.money = 300
    self.spare_points = 10

    self.waves = {
        "shi/easy_attack",
        --"shi/scythebomb"
    }

    self.dialogue = {
        "HEH![wait:5] I'm on\nthat PSYCHO DRIFT![wait:5] Try\nand CATCH me!",
        "HEH![wait:5] Follow\nTHIS![wait:5] RISING...\nSUMMERSALT!!",
        "Real boys\ncan't do THIS!\nSONIC DASH!!!",
        "CROW KICK!\nHAH,[wait:5] did you see that?\nToo slow..."
    }
    self.dialogue_sad = {
        "Uhh... don't\nlook at this.",
        "Oh, GROSS!\nSomeone's, uh...\neww! Bullets!",
        "Oh, no! That,\ngreen box!! Ugh!\nWhat IS that?"
    }

    self.check = {
        "YELLOW's yes-man.[wait:5] A scarecrow with super speed...[wait:5] that can't move.",
        "Supposed to be ORANGE's lackey,[wait:5] but they've never met.[wait:5] As it can't move."
    }

    self.text = {
        "* Shi is focusing its Chi,[wait:5] which it also calls its Shi.",
        "* Shi acts like it's jumping all over the place but does not actually move.",
        "* Shi lowers its hat and chuckles.[wait:5] \"Time to get serious...\"",
        "* Shi shouts \"heh,[wait:5] behind you!\" Then,[wait:5] doesn't actually move."
    }

    self.low_health_text = "* Shi leaks straw."
    self.tired_text = "* Shi's movements finally slow."
	self.spareable_text  = "* Shi seems satisfied."

    self.low_health_percentage = 1 / 4

    self:registerShortAct("ActScared", "30%\nMercy")
    self:registerAct("Intimidate", "Pose for\nMercy", "all")

    self.do_defeat = false
    self.defeatanim = nil

    self.sadboy = false
end

function Shi:isXActionShort(battler)
    return true
end

function Shi:onAct(battler, name)
    if name == "Intimidate" then
        Game.battle:addChild(ShiIntimidate(self, battler))
        return
    elseif name == "ActScared" or name == "Standard" then
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Shi:onShortAct(battler, name)
    if name == "ActScared" then
        if #Game.battle:getActiveParty() == 1 then
            self:addMercy(50)
        else
            self:addMercy(30)
        end
        battler:setActSprite("party/kris/dark/chicken", -2 + 3, -1 + 5, 1 / 5)
        return "* You acted like a scared crow!"
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(30)
            end
            local text = {
                "* Susie eats hay!",
                "* Susie pretends to scare crows!",
                "* Susie beats up the ground!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            if #Game.battle:getActiveParty() == 1 then
                self:addMercy(50)
            else
                self:addMercy(30)
            end
            local text = {
                "* Ralsei trades hats!",
                "* Ralsei poses like a scarecrow!",
                "* Ralsei eats hay!"
            }
            return TableUtils.pick(text)
        end
    end
end

function Shi:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.sadboy then
        return TableUtils.pick(self.dialogue_sad)
    else
        return TableUtils.pick(self.dialogue)
    end
end

function Shi:getEncounterText()
    if self.sadboy then
        return "* The opponent...\n* ... denies being the opponent."
    end

    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like straw."
    end

    return super.getEncounterText(self)
end

function Shi:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

    if self.health <= 0 then
        Game.battle.timer:after(29 / 30, function()
            if self.done_state == nil then
                self.do_defeat = true
                self:onDefeat()
            end
        end)
    end
end

function Shi:onDefeat(damage, battler)
    if not self.do_defeat then
        return
    end
    self.visible = false
    local x, y = self:getRelativePos()
    self.defeatanim = Sprite("battle/enemies/shi/surrender", x - 38, y - 2)
    self.defeatanim:setScale(2)
    self.defeatanim:setColor(ColorUtils.mergeColor(COLORS.gray, COLORS.white, 0.1))
    self.defeatanim:setOriginExact(-9, -5)
    self.defeatanim:setLayer(self.layer)
    self.defeatanim:play(1 / 10, true)
    Game.battle:addChild(self.defeatanim)
    for i = 0, 7 do
        local cloud = ShinobeetleSmokecloud(x + 40 + MathUtils.randomInt(41), y + 20 + MathUtils.randomInt(61))
        cloud.layer = self.layer + 1
        cloud:setFrame(i + 1)
        cloud:stop()
        cloud.physics.direction = -math.rad(45 + (i * 90))
        cloud.physics.speed = 2 + MathUtils.random(1)
        cloud.alpha = cloud.alpha - MathUtils.random(0.07)
        cloud.fadespeed = 0.08
        Game.battle:addChild(cloud)
    end
    self:defeat("VIOLENCED", true)
end

function Shi:update()
    super.update(self)

    if self.defeatanim ~= nil and Game.battle.state == "TRANSITIONOUT" then
        local fade = self.defeatanim:getFX("battle_end")
        if not fade then
            fade = self.defeatanim:addFX(AlphaFX(1), "battle_end")
        end
        fade.alpha = Game.battle.transition_timer / 10
    end
end

return Shi