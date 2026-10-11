local Mizzle, super = Class(EnemyBattler)

function Mizzle:init()
    super.init(self)

    self.name = "Mizzle"
    self:setActor("mizzle")
    self:setAnimation("transition")

    self.max_health = 470
    self.health = 470
    self.attack = 13
    self.defense = 0
    self.money = 110
    self.experience = 0
    self.spare_points = 10

    if not Game:getFlag("mizzle_awoken", false) then
        Game:setFlag("mizzle_awoken", true)
        self:setTired(true, true)
    end

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

    self.low_health_percentage = 1 / 3

    self:registerAct("Dazzle", "35%\nMercy")
    self:registerAct("Embezzle", "TIRE,\nsteal\nitem", { "susie" })
    self:registerAct("Nuzzle", "TIRE by\nfluffy\nmove", { "ralsei" })
    self:registerAct("LullabyX", "Sing to\neveryone\n...?", { "susie", "ralsei" })

    self.transition_ended = false

    self.havestolenbefore = false

    self.siner = MathUtils.random(100)
end

function Mizzle:onAdd(parent)
    super.onAdd(self, parent)
    if self:isTired() then
        self.encounter.text = "* Mizzle is sleeping peacefully!"
    end
end

function Mizzle:onTired()
    self:setAnimation("idle")
end

function Mizzle:onAwake()
    self:setAnimation("alarm")
end

function Mizzle:onSpareable()
    self.actor.pink = true
    if self:isTired() then
        self:setAnimation("idle")
    else
        self:setAnimation("alarm")
    end
end

function Mizzle:onAct(battler, name)
    if name == "Dazzle" then
        Game.battle:startActCutscene(function(cutscene)
            local dazzled = false
            battler.sprite.anim_speed = 2
            battler:setAnimation("battle/act", function() -- absolutely horrid, darling
                battler:setAnimation("battle/act_end", function()
                    battler:setAnimation("battle/act", function()
                        battler:setAnimation("battle/act_end", function()
                            battler:setAnimation("battle/act", function()
                                battler:setAnimation("battle/act_end", function()
                                    battler.sprite.anim_speed = 1
                                    battler:setAnimation("battle/idle")
                                end)
                            end)
                        end)
                    end)
                end)
            end)
            Assets.playSound("bell_bounce_short", 1, 1)
            Game.battle.timer:after(10 / 30, function()
                Assets.playSound("bell_bounce_short", 1, 1.1)
            end)
            Game.battle.timer:after(20 / 30, function()
                Assets.playSound("bell_bounce_short", 1, 1.2)
            end)
            Game.battle.timer:after(22 / 30, function()
                for i = 1, 6 do
                    local x, y = battler:getRelativePos()
                    local particle = DazzleParticle(x + 40, y + 20 + MathUtils.randomInt(41))
                    particle.layer = battler.layer - 1
                    Game.battle:addChild(particle)
                end
            end)
            Game.battle.timer:after(29 / 30, function()
                battler.sprite.anim_speed = 1 -- extra measures
                if self:isTired() then
                    self:addMercy(50)
                    self:setTired(false)
                else
                    self:addMercy(35)
                end
                dazzled = true
            end)
            cutscene:text("* You DAZZLEd MIZZLE!")
            cutscene:wait(function() return dazzled end)
        end)
        return
    elseif name == "Embezzle" then
        Game.battle:startActCutscene(function(cutscene)
            local susie = Game.battle:getPartyBattler("susie")
            local embezzled = false
            local embezzle_result = ""
            local su_start_x, su_start_y, su_start_layer = susie.x, susie.y, susie.layer
            susie:setSprite("jump_back")
            susie.physics.speed_y = -40
            Assets.playSound("jump")
            Game.battle.timer:after(19 / 30, function()
                local x, y = self:getRelativePos()
                susie:setPosition(x + 20 + susie.width, -100 + susie.height * 2)
                susie.physics.speed_y = 0
                susie.layer = self.layer + 1
                susie:slideToSpeed(susie.x, y - 40 + susie.height * 2, 30, function()
                    Assets.playSound("bump")
                    susie:setSprite("kneel_heal_alt_right")
                    self:shake()
                    susie:shake()
                    embezzle_result = self:embezzle()
                    Game.battle.timer:after(19 / 30, function()
                        susie:setSprite("jump_back")
                        susie.physics.speed_y = -30
                        Assets.stopAndPlaySound("jump")
                    end)
                    Game.battle.timer:after(29 / 30, function()
                        susie.x = su_start_x
                        susie.layer = su_start_layer
                        susie.physics.speed_y = 0
                        susie:slideToSpeed(su_start_x, su_start_y, 30, function()
                            susie:setAnimation("battle/idle")
                            susie:shake()
                            Assets.playSound("bump")
                            embezzled = true
                        end)
                    end)
                end)
            end)
            cutscene:text("* Susie EMBEZZLED an item!")
            cutscene:wait(function() return embezzled end)
            cutscene:text(embezzle_result)
        end)
        return
    elseif name == "Nuzzle" then
        Game.battle:startActCutscene(function(cutscene)
            local ralsei = Game.battle:getPartyBattler("ralsei")
            local nuzzled = false
            local ra_start_x, ra_start_y, ra_start_layer = ralsei.x, ralsei.y, ralsei.layer
            local x, y = self:getRelativePos()
            ralsei:setPosition(x - 40 + ralsei.width, y + 20 + ralsei.height * 2)
            ralsei.layer = self.layer + 1
            ralsei:setAnimation("nuzzle")
            Assets.playSound("magicmarker", 1, 1)
            ralsei.physics.speed_x = 0.1
            Game.battle.timer:after(1, function()
                ralsei.physics.speed_x = 0
            end)
            Game.battle.timer:after(31 / 30, function()
                ralsei:setAnimation("battle/idle")
                ralsei.x = ra_start_x
                ralsei.y = ra_start_y
                ralsei.layer = ra_start_layer
                nuzzled = true
            end)
            cutscene:text("* Ralsei NUZZLEd MIZZLE!")
            cutscene:wait(function() return nuzzled end)
            self:addMercy(35)
            if not self:isTired() then
                self:setTired(true)
                cutscene:text("* MIZZLE became TIRED!")
            end
        end)
        return
    elseif name == "LullabyX" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* Everyone sang a LULLABY!")
            local susie = Game.battle:getPartyBattler("susie")
            local ralsei = Game.battle:getPartyBattler("ralsei")
            local lullabied = false
            ralsei:setAnimation("sing")
            Assets.playSound("ralseising1")
            Game.battle.timer:after(60 / 30, function()
                susie:setAnimation("sing")
                Assets.playSound("suslaugh")
            end)
            Game.battle.timer:after(74 / 30, function()
                ralsei:setSprite("battle/hurt")
                Assets.stopSound("ralseising1")
                ralsei:shake()
            end)
            Game.battle.timer:after(120 / 30, function()
                lullabied = true
            end)
            cutscene:wait(function() return lullabied end)
            susie:setAnimation("battle/idle")
            ralsei:setAnimation("battle/idle")
            local mizzles_asleep = 0
            for _, enemy in ipairs(Game.battle.enemies) do
                if enemy.tired then
                    if enemy.id == "mizzle" then
                        mizzles_asleep = mizzles_asleep + 1
                    end
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
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Mizzle:onShortAct(battler, name)
    if name == "Standard" then
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
            return "* " .. battler.chara:getName() .. " straightened the\ndummy's hat."
        end
    end
end

function Mizzle:isXActionShort(battler)
    return true
end

function Mizzle:embezzle(battler)
    local result = ""
    if self.havestolenbefore then
        Assets.playSound("ui_cant_select")
        result = "* But, there was nothing to steal!"
    elseif Game.inventory:isFull("items", true) then
        Assets.playSound("ui_cant_select")
        result = "* But, your items are full!"
    elseif not self:isTired() and MathUtils.randomInt(101) < 50 then
        Assets.playSound("ui_cant_select")
        result = "* But, she failed!"
    else
        Assets.playSound("item")
        self.havestolenbefore = true
        local rand = MathUtils.randomInt(101)
        if rand <= 30 then
            result = "* Stole 100 Dark Dollars!"
            Game.money = Game.money + 100
        elseif rand > 30 and rand <= 60 then
            result = "* Stole Scarlixir!"
            Game.inventory:addItem("scarlixir")
        elseif rand > 60 and rand <= 90 then
            result = "* Stole Darker Candy!"
            Game.inventory:addItem("dark_candy")
        else
            result = "* Stole Revive Mint!"
            Game.inventory:addItem("revivemint")
        end
    end
    self:setTired(true)
    self:addMercy(35)
    return result
end

function Mizzle:getNextWaves()
    if self:isTired() == false then
        return {"mizzle/spirals"}
    else
        return {"mizzle/spotlights"}
    end
end

function Mizzle:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self:isTired() then
        return ""
    end

    return TableUtils.pick(self.dialogue)
end

function Mizzle:spawnSpeechBubble(text, options)
    if self:isTired() then
        local bubble = ZSpeechBubble(self.x - 94, self.y - 56)
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

    if not self.transition_ended and Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.transition_ended = true
        if self:isTired() then
            self:setAnimation("idle")
        else
            self:setAnimation("alarm")
        end
    end

    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" then
        self.siner = self.siner + (1 / 6) * DTMULT
        self.sprite.y = self.sprite.init_y + math.sin(self.siner * 0.5) * 5 / 2
        if self.bubble then
            local spr = self.sprite or self
            local x, y = spr:getRelativePos(0, spr.height / 2, Game.battle)
            if self:isTired() then
                self.bubble.y = y - 8
            else
                self.bubble.y = y
            end
        end
    end
end

return Mizzle