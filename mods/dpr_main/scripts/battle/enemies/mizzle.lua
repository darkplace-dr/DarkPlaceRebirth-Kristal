local Mizzle, super = Class(EnemyBattler)

function Mizzle:init()
    super.init(self)

    self.name = "Mizzle"
    self:setActor("mizzle")

    self.max_health = 470
    self.health = 470
    self.attack = 13
    self.defense = 0
    self.money = 110
    self.experience = 10
    self.spare_points = 10

    self.waves = {
        --"mizzle/idk",
    }

    self.dialogue = {
        "Who's there?\nWho's there?",
        "Water you\ndoing?",
        "What is it?\nWhat is it?",
        "Am I still\ndreaming?"
    }

    self.check = "A sleepy water spirit.\nWhen TIRED, use Ralsei's\nPACIFY!"

    self.text = {
        "* Mizzle sings effervescently.",
        "* Mizzle ho-hums, ho-hums.",
        "* Mizzle uses a ring left by a\ncup as a magic circle.",
        "* Mizzle contemplates going back\nin her container."
    }
    self.low_health_text = "* Mizzle's hat is melting."
    self.tired_text = "* Mizzle is dozing."
	self.spareable_text = "* Mizzle turns the hue of\nunsweetened caffeine-free pink\nlemonade."

    self.low_health_percentage = 1/3

    self.itemstolen = false

    self:registerAct("Dazzle", "35%\nMercy")
    self:registerAct("Embezzle", "TIRE,\nsteal\nitem", {"susie"})
    self:registerAct("Nuzzle", "TIRE by\nfluffy\nmove", {"ralsei"})
    self:registerAct("LullabyX", "Sing to\neveryone\n...?", {"susie", "ralsei"})

    self.siner = MathUtils.random(100)

    self.timer = 0
    self.dazzletimer = 0

    self.dazzle = false
    self.embezzle = false
    self.nuzzle = false
    self.lullaby = false
end

function Mizzle:setTired(bool, hide_message)
    local old_tired = self.tired
    self.tired = bool
    if self.tired then
        self:setAnimation("idle")
        self.comment = "(Tired)"
        if Game:getConfig("tiredMessages") and not old_tired and not hide_message then
            if self.parent then
                self:statusMessage("msg", "tired")
                Assets.playSound("spellcast", 0.5, 0.9)
            end
        end
    else
        self:setAnimation("alarm")
        self.comment = ""
        if Game:getConfig("awakeMessages") and old_tired and not hide_message then
            if self.parent then self:statusMessage("msg", "awake") end
        end
    end
end

function Mizzle:onSpareable()
    self.actor.pink = true
    if self.tired then
        self:setAnimation("idle")
    else
        self:setAnimation("alarm")
    end
end

function Mizzle:onAct(battler, name)
    if name == "Dazzle" then
        Game.battle:startActCutscene(function(cutscene)
            self.dazzlebattler = battler
            self.dazzle = true
            cutscene:text("* You DAZZLEd MIZZLE!")
            cutscene:wait(function() return self.dazzletimer >= 30 end)
            self.dazzle = false
            self.dazzletimer = 0
            self.dazzlebattler = nil
            if self.tired then
                self:addMercy(50)
                self:setTired(false)
            else
                self:addMercy(35)
            end
        end)
        return
    elseif name == "Embezzle" then
        Game.battle:startActCutscene(function(cutscene)
            local susie = Game.battle:getPartyBattler("susie")
            self.orig_battler_x = susie.x
            self.orig_battler_y = susie.y
            self.orig_battler_layer = susie.layer
            self.embezzle = true
            susie:setSprite("jump_back")
            susie.physics.speed_y = -40
            Assets.playSound("jump")
            cutscene:text("* Susie EMBEZZLED an item!")
            cutscene:wait(function() return susie.y == self.orig_battler_y end)
            self.embezzle = false
            self.orig_battler_x = nil
            self.orig_battler_y = nil
            self.orig_battler_layer = nil
            self.timer = 0
            cutscene:text(self.embezzle_result)
        end)
        return
    elseif name == "Nuzzle" then
        Game.battle:startActCutscene(function(cutscene)
            self.nuzzle = true
            cutscene:text("* Ralsei NUZZLEd MIZZLE!")
            cutscene:wait(function() return self.timer > 31 end)
            self.nuzzle = false
            self.timer = 0
            self:addMercy(35)
            if not self.tired then
                self:setTired(true)
                cutscene:text("* MIZZLE became TIRED!")
            end
        end)
        return
    elseif name == "LullabyX" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* Everyone sang a LULLABY!")
            self.lullaby = true
            cutscene:wait(function() return self.timer > 120 end)
            self.lullaby = false
            self.timer = 0
            Game.battle:getPartyBattler("susie"):setAnimation("battle/idle")
            Game.battle:getPartyBattler("ralsei"):setAnimation("battle/idle")
            local mizzles_asleep = 0
            for _,enemy in ipairs(Game.battle.enemies) do
                if enemy.id == "mizzle" and enemy.tired then
                    mizzles_asleep = mizzles_asleep + 1
                    enemy:setTired(false)
                    Assets.playSound("spellcast", 0.5, 1.2)
                    enemy:addMercy(50)
                else
                    enemy:addMercy(35)
                end
            end
            if mizzles_asleep == 1 then
                cutscene:text("* MIZZLE woke up!")
            elseif mizzles_asleep > 1 then
                cutscene:text("* MIZZLEs woke up!")
            end
        end)
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(20)
            local text = {
                "* Susie gargles loudly!",
                "* Susie breaks a wet floor sign!",
                "* Susie snores while awake!"
            }
            return TableUtils.pick(text)
        elseif battler.chara.id == "ralsei" then
            self:addMercy(25)
            local text = {
                "* Ralsei sips politely!",
                "* Ralsei puts a wet floor sign!",
                "* Ralsei makes toothpaste!!!"
            }
            return TableUtils.pick(text)
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    return super.onAct(self, battler, name)
end

function Mizzle:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.tired then
        return ""
    end

    return TableUtils.pick(self.dialogue)
end

function Mizzle:spawnSpeechBubble(text, options)
    if self.tired then
        local bubble = ZSpeechBubble(self.x-94, self.y-56)
        self.bubble = bubble
        self:onBubbleSpawn(bubble)
        Game.battle:addChild(bubble)
        return bubble
    else
        return Battler.spawnSpeechBubble(self, text, options)
    end
end

function Mizzle:update()
    super.update(self)

    if self.dazzle then -- handles dazzle
        self.dazzletimer = self.dazzletimer + 1 * DTMULT
        if self.dazzletimer == 1 then
            Assets.playSound("bell_bounce_short")
        elseif self.dazzletimer == 11 then
            self.dazzlebattler:setAnimation("battle/act")
            Assets.playSound("bell_bounce_short", 1, 1.1)
        elseif self.dazzletimer == 21 then
            self.dazzlebattler:setAnimation("battle/act")
            Assets.playSound("bell_bounce_short", 1, 1.2)
        elseif self.dazzletimer == 23 then
            for i = 1, 6 do
                local x = self.dazzlebattler.x
                local y = self.dazzlebattler.y - self.dazzlebattler.height + MathUtils.randomInt(20)
                local particle = DazzleParticle(x, y)
                particle.layer = self.dazzlebattler.layer - 0.01
                Game.battle:addChild(particle)
            end
        end
    end

    if self.embezzle or self.nuzzle or self.lullaby then
        local susie = Game.battle:getPartyBattler("susie")
        local ralsei = Game.battle:getPartyBattler("ralsei")

        self.timer = self.timer + 1 * DTMULT

        if self.embezzle then -- handles embezzle
            if self.timer == 20 then
                susie.layer = self.layer + 0.1
                susie.x = self.x
                susie.y = -100
                susie.physics.speed_y = 30
            end
            if susie.y > self.y - 60 and susie.physics.speed_y > 0 and self.timer > 20 and self.timer < 40 then
                susie.physics.speed_y = 0
                susie:setSprite("kneel_heal_alt_right")
                self:shake()
                susie:shake()
                Assets.playSound("bump")
                if self.itemstolen then
                    Assets.playSound("ui_cant_select")
                    self.embezzle_result = "* But, there was nothing to steal!"
                elseif Game.inventory:isFull("items", true) then
                    Assets.playSound("ui_cant_select")
                    self.embezzle_result = "* But, your items are full!"
                elseif not self.tired and MathUtils.randomInt(100) < 50 then
                    Assets.playSound("ui_cant_select")
                    self.embezzle_result = "* But, she failed!"
                else
                    Assets.playSound("item")
                    self.itemstolen = true
                    local rand = MathUtils.randomInt(100)
                    if rand <= 30 then
                        self.embezzle_result = "* Stole 100 Dark Dollars!"
                        Game.money = Game.money + 100
                    elseif rand > 30 and rand <= 60 then
                        self.embezzle_result = "* Stole Scarlixir!"
                        Game.inventory:addItem("scarlixir")
                    elseif rand > 60 and rand <= 90 then
                        self.embezzle_result = "* Stole Darker Candy!"
                        Game.inventory:addItem("dark_candy")
                    else
                        self.embezzle_result = "* Stole Revive Mint!"
                        Game.inventory:addItem("revivemint")
                    end
                end
                self:setTired(true)
                self:addMercy(35)
            end
            if self.timer == 40 then
                susie.physics.speed_y = -30
                susie:setSprite("jump_back")
                Assets.stopAndPlaySound("jump")
            end
            if self.timer == 50 then
                susie.x = self.orig_battler_x
                susie.physics.speed_y = 30
            end
            if self.timer > 50 and susie.y >= self.orig_battler_y and susie.physics.speed_y > 0 then
                susie.physics.speed_y = 0
                susie.y = self.orig_battler_y -- just in case
                susie.layer = self.orig_battler_layer
                susie:setAnimation("battle/idle")
                susie:shake()
                Assets.playSound("bump")
            end
        end

        if self.nuzzle then -- handles nuzzle
            if self.timer == 1 then
                self.orig_battler_x = ralsei.x
                self.orig_battler_y = ralsei.y
                self.orig_battler_layer = ralsei.layer
                ralsei.layer = self.layer + 0.1
                ralsei:setPosition(self.x-66, self.y)
                ralsei:setAnimation("nuzzle")
                Assets.playSound("magicmarker")
            end
            if self.timer < 31 then
                ralsei.x = ralsei.x + 0.1 * DTMULT -- okay???
            end
            if self.timer > 31 then
                if self.orig_battler_x and self.orig_battler_y then
                    ralsei:setAnimation("battle/idle")
                    ralsei:setPosition(self.orig_battler_x, self.orig_battler_y)
                    ralsei.layer = self.orig_battler_layer
                    self.orig_battler_x = nil
                    self.orig_battler_y = nil
                    self.orig_battler_layer = nil
                end
            end
        end

        if self.lullaby then -- handles lullaby
            if self.timer == 1 then
                ralsei:setAnimation("sing")
                Assets.playSound("ralseising1")
            end
            if self.timer == 61 then
                susie:setAnimation("battle/sing")
                Assets.playSound("suslaugh")
            end
            if self.timer == 75 then
                ralsei:setSprite("battle/hurt")
                Assets.stopSound("ralseising1")
                ralsei:shake()
            end
        end
    end

    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.siner = self.siner + (1 / 6) * DTMULT
        self.y = self.init_y + (math.sin(self.siner * 0.5)) * 5
        if self.bubble then
            if self.tired then
                self.bubble.y = self.y-56
            else
                local spr = self.sprite or self
                local x, y = spr:getRelativePos(0, spr.height/2, Game.battle)
                self.bubble.y = y
            end
        end
    end
end

return Mizzle