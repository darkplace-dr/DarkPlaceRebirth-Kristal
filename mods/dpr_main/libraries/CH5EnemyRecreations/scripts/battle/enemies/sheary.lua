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

function Sheary:getEncounterText()
    if (self:getSpareableText() and self:canSpare()) or (self:getLowHealthText() and self:hasLowHealth()) or (self:getTiredText() and self:isTired()) then
        return super.getEncounterText(self)
    end

    if MathUtils.randomInt(101) < 3 then
        return "* Smells like freshly cut grass."
    end

    return super.getEncounterText(self)
end

-- Figure out how to set up Sheary's unique speech bubbles.
function Sheary:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.firstturnballoon == false then
        self.firstturnballoon = true
        return "Half-Off?\nOff-Half?"

    else
        return TableUtils.pick(self.dialogue)
    end
end

function Sheary:spawnSpeechBubble(text, options)
    options = options or {}
    local bubble
    local spr = self.sprite or self
    local x, y = spr:getRelativePos(0, spr.height/2, Game.battle)
    x, y = x - self.dialogue_offset[1], y + self.dialogue_offset[2]

    bubble = SpeechBubble(text, x, y, {}, self)
    self.bubble = bubble

    if self.dialogue[4] or self.firstturnballoon == false then
        bubble:setStyle("sheary")
    else
        bubble:setStyle("sheary_long")
    end

    self:onBubbleSpawn(bubble)
    bubble:setCallback(function()
        self:onBubbleRemove(bubble)
        bubble:remove()
        self.bubble = nil
    end)
    bubble:setLineCallback(function(index)
        Game.battle.textbox_timer = 3 * 30
    end)

    Game.battle:addChild(bubble)

    return bubble
end

return Sheary