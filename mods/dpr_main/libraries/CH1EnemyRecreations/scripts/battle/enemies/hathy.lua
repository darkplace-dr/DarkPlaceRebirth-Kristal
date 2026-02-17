local Hathy, super = Class(EnemyBattler)

function Hathy:init()
    super.init(self)

    self.name = "Hathy"
    self:setActor("hathy")

    self.max_health = 150
    self.health = 150
    self.attack = 6
    self.defense = 0
    self.money = 28
    self.spare_points = 10

    self.check = "AT 7 DF 0\n* I am a [color:yellow]little kiss[color:reset]."

    self.dialogue = {"..."}
    self.dialogue_offset = {36, -48}

    self.text = {
        "* Hathy's body beats audibly.",
        "* Hathy smiled a darling smile.",
        "* Hathy is whispering a lovely spell.",
        "* Hathy has a little secret.",
        "* Smells like a soft kiss."
    }
    self.low_health_text = "* Hathy's beat seems to stutter."
    self.spareable_text = "* Hathy is skipping beats."

    self:registerAct("Flatter")
    self:registerAct("X-Flatter", "", {"ralsei"})
    self:registerAct("S-Flatter", "", {"susie"})

    self.flattered = false
    self.x_flattered = false
end

function Hathy:onAct(battler, name)
    if name == "Flatter" then
        self:addMercy(100)
        self.flattered = true
        local rnd = math.random(1,3)
        if rnd == 1 then
            return "* You told Hathy it has cool tentacles.[wait:10]\n* It began to think about this..."
        elseif rnd == 2 then
            return "* You called Hathy a sweetheart.[wait:10]\n* It began to think about this..."
        else
            return "* You told Hathy its teeth look like knives.[wait:10]\n* It began to think about this..."
        end
    elseif name == "X-Flatter" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.name == "Hathy" then
                enemy.x_flattered = true
            end
        end
        Game.battle:startActCutscene("hathy", "x_flatter")
        return
    elseif name == "S-Flatter" then
        for _, enemy in ipairs(Game.battle.enemies) do
            if enemy.name == "Hathy" then
                enemy.x_flattered = true
            end
        end
        Game.battle:startActCutscene("hathy", "s_flatter")
        return
    elseif name == "Standard" then
        self:addMercy(50)
        return "* "..battler.chara:getName().." smiled at Hathy."
    end

    return super.onAct(self, battler, name)
end

function Hathy:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    return TableUtils.pick(self.dialogue)
end

function Hathy:getNextWaves()
    if self.wave_override then
        return super.getNextWaves(self)
    end

    local enemies = Game.battle:getActiveEnemies()
    if #enemies >= 2 then
        return {"hathy/heartshaper"}
    else
        return {"hathy/spinheart"}
    end
end

function Hathy:spawnSpeechBubble(...)
    if self.flattered then
        self.balloon_type = "smallheart"
    elseif self.x_flattered then
        self.balloon_type = "smallhearts"
    else
        self.balloon_type = TableUtils.pick{ "heartchomp", "heartkiss" }
    end

    local x, y = self.sprite:getRelativePos(0, self.sprite.height/2, Game.battle)
    if self.dialogue_offset then
        x, y = x + self.dialogue_offset[1], y + self.dialogue_offset[2]
    end
    local textbox = HathySpeechBubble(x, y, self.balloon_type)
    Game.battle:addChild(textbox)
    return textbox
end

function Hathy:onTurnEnd()
    if self.flattered then
        self.flattered = false
    end
    if self.x_flattered then
        self.x_flattered = false
    end
end

return Hathy