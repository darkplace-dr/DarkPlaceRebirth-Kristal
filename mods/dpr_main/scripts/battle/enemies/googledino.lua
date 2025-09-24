local GoogleDino, super = Class(EnemyBattler)

function GoogleDino:init()
    super.init(self)

    self.name = "Google Dino"
    self:setActor("googledino")

    self.health = 980
    self.attack = 5
    self.defense = 2
    self.max_health = 980
    self.money = 98
    self.experience = 5

    self.spare_points = 10	
    self.tired_percentage = 0.25
	self.service_mercy = 5
    self.milestone = true
	self.boss = true


    self.waves = {
        "googledino/runner"
    }

    self.check = "AT 5 DF 2\nA dinosaur on a journey.\nIt seems you are in its way."

    self.text = {
        "* (Your internet has been disconnected.)",
        "* The dino stares ahead with \na blank expression on \nits face.",
        "* You thought you saw a \npterodactyl flying over \nhead.",
        "* You don't think you'll complete \nthe game.",
    }
    self.low_health_text = "* The servers are crashing."
    self.tired_text = "* The dino seems to be going into sleep mode."
    self.spareable_text = "* Seems like the Wi-Fi's \nback online."

    self:registerAct("Reboot", "10% Mercy\nAttacks\nget harder")
    self:registerAct("X-Reboot", "20% Mercy\nAttacks\nget harder", "all")

    self.difficulty = 1
    self.hp_ratio = 0
end

function GoogleDino:isXActionShort(battler)
    return true
end

function GoogleDino:onShortAct(battler, name)
    if name == "Standard" then
        self:addMercy(5)
        if battler.chara.id == "susie" then
            return "* Susie roared at the Dino!"
        elseif battler.chara.id == "ralsei" then
            return "* * Ralsei jumped as high as he could!"
        elseif battler.chara.id == "dess" then
            return "* Dess did absolutely nothing."
        elseif battler.chara.id == "brenda" then
            return "* Brenda did an epic noscope!"
        elseif battler.chara.id == "jamm" then
			if Game:getFlag("marcy_joined") then
				return "* Marcy jumped onto Jamm's head!"
			end
            return "* Jamm slinged a rock at a cactus!"
        elseif battler.chara.id == "mario" then
            return "* Mario jumped expertly!"
        elseif battler.chara.id == "ostarwalker" then
            return "* Starwalker did    something!"
        elseif battler.chara.id == "ceroba" then
            return "* Ceroba twirls her staff."
		else
			return "* "..battler.chara:getName().." did something!"
        end
    end
    return nil
end

function GoogleDino:onAct(battler, name)
    if name == "Reboot" then
        Assets.playSound(Utils.pick{
            "dialup_0",
            "dialup_1",
            "dialup_2",
            "dialup_3",
            "dialup_4",
            "dialup_5",
        })
        self:addMercy(10)
        self.difficulty = self.difficulty + 0.5

        return "* You attempted to reboot the internet...\n[wait:5]* Difficulty increased!"
    elseif name == "X-Reboot" then
        Assets.playSound(Utils.pick{
            "dialup_0",
            "dialup_1",
            "dialup_2",
            "dialup_3",
            "dialup_4",
            "dialup_5",
        })
        self:addMercy(20)
        self.difficulty = self.difficulty + 1
        
        return "* Everyone attempted to reboot the internet...\n[wait:5]* Difficulty increased!"
    elseif name == "Standard" then --X-Action
        -- Give the enemy 5% mercy
        if battler.chara.id == "ralsei" then
            -- R-Action text
            self:addMercy(5)
            return "* Ralsei jumped as high as he could. The Dino jumped back in response."
        elseif battler.chara.id == "susie" then
            --S-Action text
            self:addMercy(5)
            return "* Susie roared at the Dino.\n* It roared back. What an interesting conversation!"
		elseif battler.chara.id == "dess" then
            -- D-Action text
            self:setTired(true)
            return "* Dess did absolutely nothing. The Dino got bored and started feeling [color:blue]TIRED[color:reset]."
		elseif battler.chara.id == "brenda" then
            -- B-Action text
            return "* Brenda got up and did the dinosaur. The Dino wasn't sure what to make of this."
        elseif battler.chara.id == "jamm" then
            --S-Action text
            self:addMercy(5)
			if Game:getFlag("marcy_joined") then
				return "* Marcy jumped onto Jamm's head.\n* The Dino is encouraged!"
			end
            return "* Jamm slinged a rock at a distant cactus.\n* The Dino is grateful!"
        elseif battler.chara.id == "mario" then
            --S-Action text
            self:addMercy(5)
            return "* Mario showed off his excellent jumping skills.\n* The Dino is impressed!"
        elseif battler.chara.id == "ceroba" then
            --C-Action text
            self:addMercy(5)
            return "* Ceroba shows her epic magic skills.\n* The Dino is intimidated."
        else
            -- Text for any other character (like Noelle)
            self:addMercy(5)
            return "* "..battler.chara:getName().." talked to the Dino."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function GoogleDino:onHurt()
    self.hp_ratio = (self.health / self.max_health)
    
    if self.hp_ratio <= 0.8 and self.difficulty < 2 then
        self.difficulty = 2
    end
    if self.hp_ratio <= 0.6 and self.difficulty < 3 then
        self.difficulty = 3
    end
    if self.hp_ratio <= 0.4 and self.difficulty < 4 then
        self.difficulty = 4
    end
    if self.hp_ratio <= 0.2 and self.difficulty < 5 then
        self.difficulty = 5
    end

    Game.battle.timer:after(5/30, function()
        Assets.playSound("dino_die", 4)
    end)

    return super.onHurt(self)
end

function GoogleDino:getEncounterText()
    if self.low_health_text and self.health <= (self.max_health * self.low_health_percentage) then
        return self.low_health_text

    elseif self.tired_text and self.tired then
        return self.tired_text

    elseif self.spareable_text and self:canSpare() then
        return self.spareable_text
    end

	if love.math.random(0, 100) < 3 then
		return "* Smells like network diagnostics."
	else
		if love.math.random(0, 4) == 4 then
			return self.last_text
		else
			local text = super.getEncounterText(self)
			self.last_text = text
			return text
		end
	end
end

return GoogleDino