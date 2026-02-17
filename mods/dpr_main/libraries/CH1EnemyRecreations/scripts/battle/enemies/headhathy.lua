local HeadHathy, super = Class(EnemyBattler)

function HeadHathy:init()
    super.init(self)

    self.name = "Head Hathy"
    self:setActor("headhathy")

    self.max_health = 190
    self.health = 190
    self.attack = 8
    self.defense = 0
    self.money = 40
    self.spare_points = 10
    self.check = "AT 8 DF 0\n* It learned to hide its feelings...[wait:5] is that strength?"

    self.dialogue = {"..."}
    self.dialogue_offset = {36, -48}

    self.text = {
        "* Head Hathy's body moves silently.",
        "* Head Hathy showed no emotion at all.",
        "* Head Hathy whispered something unhearable.",
        "* Head Hathy's mind is an enigma.",
        "* Smells like a lonely kiss."
    }
    self.low_health_text = "* Head Hathy's beat seems to stutter."
    self.spareable_text = "* Head Hathy is skipping beats."

    self:registerAct("Flirt")
    self:registerAct("X-Flirt", "", {"susie"})

    self.flirted = false
    self.x_flirted = false
end

function HeadHathy:onAct(battler, name)
    if name == "Flirt" then
        self:addMercy(100)
        self.flirted = true
        return "* You flirted with Head Hathy.[wait:5]\n* It was highly effective."

    elseif name == "X-Flirt" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.name == "Hathy" then
                enemy.x_flirted = true
            end
        end
        Game.battle:startActCutscene("headhathy", "x_flirt")
        return 

    elseif name == "Standard" then
        self:addMercy(50)
        return "* "..battler.chara:getName().." smiled at Head Hathy."
    end

    return super.onAct(self, battler, name)
end

function HeadHathy:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    return Utils.pick(self.dialogue)
end

function HeadHathy:getNextWaves()
    if self.wave_override then
        return super.getNextWaves(self)
    end

    local enemies = Game.battle:getActiveEnemies()
    if #enemies >= 2 then
        return {"headhathy/heartshaper"}
    else
        return {"headhathy/spinheart"}
    end
end

function HeadHathy:spawnSpeechBubble(...)
    if self.flirted then
        self.balloon_type = "smallheart"
    elseif self.x_flirted then
        self.balloon_type = "smallhearts"
    else
        self.balloon_type = TableUtils.pick{ "heartchomp_alt", "heartbreak" }
    end

    local x, y = self.sprite:getRelativePos(0, self.sprite.height/2, Game.battle)
    if self.dialogue_offset then
        x, y = x + self.dialogue_offset[1], y + self.dialogue_offset[2]
    end
    local textbox = HathySpeechBubble(x, y, self.balloon_type)
    Game.battle:addChild(textbox)
    return textbox
end

function HeadHathy:onTurnEnd()
    if self.flirted then
        self.flirted = false
    end
    if self.x_flirted then
        self.x_flirted = false
    end
end

return HeadHathy