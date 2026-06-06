local DeathLord, super = Class(EnemyBattler)

function DeathLord:init()
    super.init(self)
    self.name = "DEATH LORD"
    self:setActor("deathlord")
    self.max_health = 2000
    self.health = 2000
    self.attack = 9999
    self.defense = 3
    if Game:getFlag("deathlordsign_read") then
        self.money = 1500
    else
        self.money = 60
    end
    self.spare_points = 0
    self.waves = {
        "deathlord/gun"
    }
    self.dialogue = {
        "die lol",
		"die painfully",
		"any last words",
		"youll be six feet\nunderground soon",
		"pow haha"
    }
    self.check = "AT 9999 DF 3\n* The last enemy you see before you die."
    self.text = {
        "* the power of almost dying shines within you i think",
        "* bepis",
    }
    self.low_health_text = "* oh god hes is gonna die"
    self.spareable_text = "* oh god he doesnt really care\nanymore"
    self.tired_text = "* oh boy hes quite sleepy"
    self:registerAct("BegForMercy", "Induce\nTIRED")
    self:registerAct("GrazeChallenge", "Graze\nfor\nMERCY")
	self.begged = false
	self.did_graze_challenge = false
	self.graze_challenge = false
	self.showtempmercy = false
	self.boss = true
	self.tired_percentage_text = nil
end

function DeathLord:getEncounterText()
    if self.tired_percentage_text then
		local text = self.tired_percentage_text
		self.tired_percentage_text = nil
        return text

    elseif self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif self.spareable_text and self:canSpare() then
        return self.spareable_text
    end
	if MathUtils.randomInt(0, 100) < 3 then
		return "* Smells like gunpowder."
	else
		return super.getEncounterText(self)
	end
end

function DeathLord:update()
	super.update(self)
	if Game.battle.state == "DEFENDINGEND" and self.graze_challenge then
		self.graze_challenge = false
		Game.battle.timer:after(15/30, function() self.showtempmercy = false end)
	end	
end

function DeathLord:onDefeatRun(damage, battler)
    self.hurt_timer = -1
    self.defeated = true

	self.physics.speed_x = 12
	self.physics.speed_y = -4
	
    Game.battle.timer:after(1, function()
        self:remove()
    end)

    self:defeat("VIOLENCED", true)
end

function DeathLord:onAct(battler, name)
    if name == "BegForMercy" then
		local last_tired = self.tired
		self:addTired(16)
		if self.mercy >= 100 then		
			self.dialogue_override = "what are you\neven doing"
			return {
				"* You begged for mercy.[wait:5]\n* But...[wait:5] you can just [color:yellow]SPARE[color:reset] it already...",
			}
		elseif last_tired then
			self.dialogue_override = "(yawn)\ndie bozo..."
			return {
				"* You begged for mercy.\n* But DEATH LORD is already fully [color:blue]TIRED[color:reset]!",
			}
		elseif not self.begged then
			self.begged = true
			self.tired_percentage_text = "* DEATH LORD is [color:blue]"..math.floor(self.tiredness).."% TIRED[color:reset]!"
			if self.tired then
				self.dialogue_override = "(yawn)\ndie bozo..."
				return {
					"* You begged for mercy.\n* DEATH LORD became fully [color:blue]TIRED[color:reset]!"
				}
			else
				self.dialogue_override = "im on a\nno mercy playthrough"
				return {
					"* You begged for mercy.[wait:5]\n* But DEATH LORD showed none.",
					"* However, DEATH LORD became a little [color:blue]TIRED[color:reset]!"
				}
			end
		else
			self.tired_percentage_text = "* DEATH LORD is [color:blue]"..math.floor(self.tiredness).."% TIRED[color:reset]!"
			if self.tired then
				self.dialogue_override = "(yawn)\ndie bozo..."
				return {
					"* You begged for mercy.\n* DEATH LORD became fully [color:blue]TIRED[color:reset]!"
				}
			else
				self.dialogue_override = "no"
				return {
					"* You begged for mercy.\n* DEATH LORD became more [color:blue]TIRED[color:reset]!"
				}
			end
		end
	elseif name == "GrazeChallenge" then
		self.graze_challenge = true
		self.showtempmercy = true
        self:addTemporaryMercy(5, true, {0, 100}, (function() return self.showtempmercy == false end))
		if not self.did_graze_challenge then
			self.did_graze_challenge = true
			self.dialogue_override = "good luck lmao"
			return {
				"* You boasted about your ability to graze bullets.",
				"* DEATH LORD accepts your challenge!\n* DEATH LORD gains mercy for every bullet grazed!"
			}
		else
			self.dialogue_override = "graze this casual"
			return {
				"* You say you can graze every bullet!\n* DEATH LORD gains mercy for every bullet grazed!"
			}
		end
    elseif name == "Standard" then
		if battler.chara.id == "susie" then
			self:addMercy(12)
            return "* Susie gave DEATH LORD a thumbs up."
        else
			if battler.chara.id == "jamm" and Game:getFlag("marcy_joined") then
				return "* Jamm and Marcy couldn't think of anything."
			end
            return "* "..battler.chara:getName().." couldn't think of anything."
        end
    end
    return super.onAct(self, battler, name)
end

return DeathLord