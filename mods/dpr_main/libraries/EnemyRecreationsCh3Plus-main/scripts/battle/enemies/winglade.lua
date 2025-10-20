local Winglade, super = Class(EnemyBattler)

function Winglade:init()
    super.init(self)

    self.name = "Winglade"
    self:setActor("winglade")

    self.max_health = 470
    self.health = 470
    self.attack = 14
    self.defense = 0
    self.money = 155
    self.spare_points = 10

    self.waves = {
        "winglade/circlearena",
        "winglade/aim"
    }

    self.dialogue = {
        "Halo, goodeye!        Halo, goodeye!",
        "Halo, are you listening?            ",
        "You oppose the revolution?          ",
        "Open your eyes        Open your eyes"
    }
    self.dialogue_mercy = {
        "Viva la revolution!  Viva la revolution!",
        "To spin, is to trust"
    }

    self.check = "A radical blade with\nfeathers at the hilt."

    self.text = {
        "* Winglade molts and revolts.",
        "* Winglade watches distrustfully.",
        "* Winglade draws flowers with its\nblade.",
        "* Winglade rotates aggressively."
    }

    self.spareable_text = "* Winglade flutters trustfully."
    self.low_health_text = "* Winglade sheds feathers heavily."
    self.tired_text = "* Winglade's eye flutters shut."

    self.low_health_percentage = 1/3

    self:registerAct("Spin", "Spin\n50%\nmercy")
    self:registerAct("SpinS", "60%\nMercy\nto all", {"susie"})
    self:registerAct("Whirl", "SPARE\nall!", {"susie", "ralsei"}, 64)
end

function Winglade:spawnSpeechBubble(text)
    self:shiftOrigin(0.5, 0.5)
    local bubble = WingladeSpeechBubble(text, self)
    self.bubble = bubble
    self:onBubbleSpawn(bubble)
    Game.battle:addChild(bubble)
    return bubble
end

function Winglade:isXActionShort(battler)
    return true
end

function Winglade:onAct(battler, name)
    if name == "Spin" then
        self:addMercy(50)
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy ~= self then enemy:addMercy(10) end
        end
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        battler:setAnimation('pirouette')
        return "* You spun masterfully!"
    elseif name == "SpinS" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.id == 'winglade' then enemy:addMercy(60) end
        end
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        battler:setAnimation('pirouette')
        Game.battle:getPartyBattler('susie'):setAnimation('pirouette')
        return "* You and Susie spun masterfully!"
    elseif name == "Whirl" then
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        Game.battle:getPartyBattler('kris'):setAnimation('pirouette')
        Game.battle:getPartyBattler('susie'):setAnimation('pirouette')
        Game.battle:getPartyBattler('ralsei'):setAnimation('pirouette')
        Game.battle:startActCutscene("wingladewhirl")
        return
    elseif name == "Standard" then
        -- Ok so like if you use SpinS + R-Action then despite being an XAction,
        -- R-Action still gets called here for some reason?????
        -- Why is it like that why
        -- Or am I tripping
        return self:onShortAct(battler, name)
    end

    return super.onAct(self, battler, name)
end

function Winglade:onShortAct(battler, name)
    if name == "Standard" then --X-Action
        Assets.stopAndPlaySound("pirouette", 0.7, 1.1)
        battler:setAnimation('pirouette')
        if battler.chara.id == "ralsei" then
            self:addMercy(50)
            for _, enemy in ipairs(Game.battle.enemies) do
                if enemy ~= self then enemy:addMercy(10) end
            end
            return "* Ralsei rotates like a gyro!"
        elseif battler.chara.id == "susie" then
            self:addMercy(40)
            return "* Susie wobbles like a top!"
        else
            self:addMercy(40)
            return "* "..battler.chara:getName().." wobbles like a top!"
        end
    end

    return super.onShortAct(self, battler, name)
end

function Winglade:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    if self.mercy >= 100 then
        return TableUtils.pick(self.dialogue_mercy)
    end

    return TableUtils.pick(self.dialogue)
end

function Winglade:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        return self.spareable_text
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif has_spareable_text then
        return self.spareable_text
    end

    if MathUtils.random(0, 100) < 3 then
        return "* Smells like old down pillow."
    end

    return TableUtils.pick(self.text)
end

return Winglade