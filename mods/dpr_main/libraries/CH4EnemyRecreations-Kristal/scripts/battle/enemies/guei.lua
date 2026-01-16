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
    self.experience = 0
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

    self:getAct("Check").description = "Useless\nanalysis"
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
    for _,v in ipairs(Game.battle.enemies) do
		if v.tired then
			if Game.tension >= 16 then
				if Game:hasPartyMember("jamm") then
					return "* Guei looks [color:blue]TIRED[color:reset]. Try using Ralsei's [color:blue]PACIFY[color:reset] or Jamm's [color:blue]NUMBSHOT[color:reset]!"
				else
					return "* Guei looks [color:blue]TIRED[color:reset]. Perhaps Ralsei's MAGIC, [color:blue]PACIFY[color:reset] would be effective..."
				end
			else
				if Game:hasPartyMember("jamm") then
					return "* Guei looks [color:blue]TIRED[color:reset]. [color:yellow]DEFEND[color:reset] to gain [color:yellow]TP[color:reset], then try Ralsei's [color:blue]PACIFY[color:reset] or Jamm's [color:blue]NUMBSHOT[color:reset]...!"
				else
					return "* Guei looks [color:blue]TIRED[color:reset]. [color:yellow]DEFEND[color:reset] to gain [color:yellow]TP[color:reset], then try Ralsei's MAGIC, [color:blue]PACIFY[color:reset]...!"
				end
			end
		end
	end
    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif self.spareable_text and self:canSpare() then
        return self.spareable_text
    end
	if love.math.random(0, 100) < 3 then
		return "* Smells like teens.\n* Smells like spirits."
	else
		local text = super.getEncounterText(self)
		return text
	end
end

function Guei:spawnSpeechBubble(...)
    if self.excerism then
        self.balloon_type = 7
    else
        self.balloon_type = TableUtils.pick{1, 2, 3, 4, 5, 6}
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