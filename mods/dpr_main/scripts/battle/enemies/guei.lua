local Guei, super = Class(EnemyBattler)

function Guei:init()
    super.init(self)

    self.name = "Guei"
    self:setActor("guei")
    self:setAnimation("idle")

    self.max_health = 470
    self.health = 470
    self.attack = 13
    self.defense = 0
    self.money = 120
    self.experience = 10
    self.spare_points = 10

    self.waves = {
        "guei/holyfire",
        "guei/clawdrop"
    }

    self.dialogue = {"..."}
    self.dialogue_offset = {0, -48}

    self.check = "A strange spirit said to\nappear when the moon waxes."

    self.text = {
        "* Guei turns its head like a\nbird.",
        "* Guei rattles its claws.",
        "* Guei wags its tail.",
        "* Guei howls hauntingly."
    }
    self.low_health_text = "* Guei's flames flicker weakly."
	self.spareable_text = "* Guei looks satisfied in some\nodd way."

    self.low_health_percentage = 1/3

    self:registerAct("Exercism", "20% &\nDelayed\nTIRED")
    self:registerAct("Xercism", "60% &\nDelayed\nTIRED", {"ralsei"})
    --self:registerAct("OldMan", "I'm\nold!") -- yeahhh you're not here yet

    self.killable = true

    self.excerism = false
end

function Guei:isXActionShort(battler)
    return true
end

function Guei:onAct(battler, name)
    if name == "Exercism" then
        self.excerism = true
        self:addMercy(20)
        return "* You started the exercism!\n* You encouraged Guei to exercise!"
    elseif name == "Xercism" then
        self.excerism = true
        self:addMercy(60)
        return "* Everyone encouraged Guei to exercise!"
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            return  "* Susie told a story about the\nliving dead!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            return "* Ralsei told a family-friendly\nstory about a lovable yet\nlonely ghost!"
        else
            self:addMercy(40)
            local text = {
                "* "..battler.chara:getName().." lit an incense stick!",
                "* "..battler.chara:getName().." did something mysterious!",
                "* "..battler.chara:getName().." said a prayer!",
                "* "..battler.chara:getName().." made a ghastly sound!"
            }
            return TableUtils.pick(text)
        end
    end

    return super.onAct(self, battler, name)
end

function Guei:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(40)
            return  "* Susie told a ghost story!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(40)
            return "* Ralsei quoted a holy book!"
        else
            self:addMercy(40)
            local text = {
                "* "..battler.chara:getName().." lit an incense stick!",
                "* "..battler.chara:getName().." did something mysterious!",
                "* "..battler.chara:getName().." said a prayer!",
                "* "..battler.chara:getName().." made a ghastly sound!"
            }
            return TableUtils.pick(text)
        end
    end

    return super.onShortAct(self, battler, name)
end

function Guei:getEncounterText()
    local has_spareable_text = self.spareable_text and self:canSpare()

    local priority_spareable_text = Game:getConfig("prioritySpareableText")
    if priority_spareable_text and has_spareable_text then
        return self.spareable_text
    end

    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired then
        if Game.battle:getPartyBattler("ralsei") then
            if Game:getTension() < 16 then
                return "* Guei looks [color:blue]TIRED[color:reset]. [color:yellow]DEFEND[color:reset] to\ngain [color:yellow]TP[color:reset], then try Ralsei's\nMAGIC, [color:blue]PACIFY[color:reset]...!"
            else
                return "* Guei looks [color:blue]TIRED[color:reset]. Perhaps\nRalsei's MAGIC, [color:blue]PACIFY[color:reset] would be\neffective..."
            end
        end

    elseif has_spareable_text then
        return self.spareable_text
    end

    if MathUtils.randomInt(100) < 3 then
        return "* Smells like teens.\n* Smells like spirits."
    end

    return TableUtils.pick(self.text)
end

function Guei:spawnSpeechBubble(...)
    if self.excerism then
        self.balloon_type = 7
    else
        self.balloon_type = TableUtils.pick({1, 2, 3, 4, 5, 6})
    end

    local x, y = self.sprite:getRelativePos(0, self.sprite.height/2, Game.battle)
    if self.dialogue_offset then
        x, y = x + self.dialogue_offset[1], y + self.dialogue_offset[2]
    end
    local textbox = GueiTextbox(x, y, self.balloon_type)
    Game.battle:addChild(textbox)
    return textbox
end

function Guei:onTurnEnd()
    if self.excerism then
        self.excerism = false
		self:setTired(true)
    end
end

return Guei