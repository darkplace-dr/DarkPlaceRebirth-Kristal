local Pippins, super = Class(EnemyBattler)

function Pippins:init()
    super.init(self)
	
    self.name = "Pippins"
    self:setActor("pippins")

    self.waves = {
		"pippins/dice"
	}
	
	self.check = "AT[image:ui/dice_6b, 6,0] DF[image:ui/dice_3, 6,0]\n* This crooked gambler from Card Castle always bets it all!"
	
	self.prev_wave = nil
	
	self.spare_points = 10
    if not Kristal.getLibConfig("pippins", "ch4_stats") then
	    self.attack = 11
    else
	    self.attack = 8
    end
    self.defense = 0
	self.health = 421
	self.max_health = self.health
    if not Kristal.getLibConfig("pippins", "ch4_stats") then
	    self.gold = 90
    else
	    self.gold = 30
    end
	self.experience = 20
	
    
    if(love.math.random(0,100) < 4) then
        self.text = {
            "* Smells like bad luck.",
        }
    else
        self.text = {
            "* Pippins attempts to engage you in a life or death rock paper scissors match.",
            "* Pippins bounces like popcorn.",
            "* Pippins' existence ambiently makes the scene become Rated T.",
            "* Pippins scratches off tickets made of toilet paper."
        }
    end
	
	self.low_health_text = "* Pippins seems down on its luck."
	self.tired_text = "* Pippins regrets mortgaging its 2 green houses."
	self.spareable_text = "* Pippins is betting the other enemies they'll lose."
	
	self:registerShortAct("Bet", "Touch\nGreen\n4 Mercy")
	self:registerAct("Cheat", "TIRE\nEnemies,\nbut...", {"susie"})
    if not Kristal.getLibConfig("pippins", "ch4_stats") then
	    self:registerAct("Bribe", "Give 80TP\nto SPARE", {"ralsei"}, 80)
    end

	self.bet = false
	self.cheat = false
    self.cheatcount = 0
	self.bribe = false
end

function Pippins:update()
	super.update(self)
	
end

function Pippins:onAct(battler, name)
    if name == "Bet" then
        --self:addMercy(Utils.round(50/#Game.battle.party))
		self.bet = true
        return "* You bet you could touch the Dice when it's a GREEN 4!"
	elseif name == "Cheat" then
        if(self.cheatcount == 0) then
            Game.battle:startActCutscene("pippins.cheat1")
        elseif(self.cheatcount == 1) then
            Game.battle:startActCutscene("pippins.cheat2")
        elseif(self.cheatcount == 2) then
            Game.battle:startActCutscene("pippins.cheat3")
        elseif(self.cheatcount == 3) then
            Game.battle:startActCutscene("pippins.cheat4")
        end
        return
	elseif name == "Bribe" then
        Game.battle:startActCutscene("pippins.bribe")
        return

    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(50)
			Assets.playSound("wing")
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
			self:shake(4)
            return "* Susie shook Pippins around! They kind of liked it!"

        elseif battler.chara.id == "ralsei" then
            self:addMercy(50)
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
            return "* Ralsei swore not to cheat!"

        end
	end

	return super.onAct(self, battler, name)
end

function Pippins:onShortAct(battler, name)
    if name == "Bet" then
        --self:addMercy(Utils.round(50/#Game.battle.party))
		self.bet = true
        return "* Bet: Touch the GREEN 4's!"
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(50)
			Assets.playSound("wing")
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
			self:shake(4)
            return "* Susie shook Pippins!!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(50)
			if(self.mercy >= 100) then
                self:setAnimation("spared")
            end
            return "* Ralsei swore not to cheat!"

        end
	end

    return super:onShortAct(self, battler, name)
end

function Pippins:isXActionShort(battler)
    return true
end

function Pippins:getEnemyDialogue()
    if self.dialogue_override then
        local dialogue = self.dialogue_override
        self.dialogue_override = nil
        return dialogue
    end

    local dialogue
    if self.bet then
        dialogue = {
            "YEAH! Touch\nthese 4's and\ntaste the THRILL!",
            "Put it all on\nGreen 4! Alright!!"
        }
    elseif self.cheated then
        dialogue = {
            "(You do know\nthat makes my\nattack stronger...)",
            "(This girl...\nshe boggles\nthe mind.)",
            "(What have you\ndone, you\nyatzy!?)"
        }
    elseif self.bribe then
        dialogue = {
            "Bribe, wow, is this legal?"
        }
    else
        if(love.math.random(0,100) < 4) then
            dialogue = {
                "Life is a numbers game...\nYou ever heard that?"
            }
        else
            dialogue = {
                "Will I win?\nOr will I win... BIG?",
                "Raise the stakes and\nROLL ROLL ROLL!",
                "Rock me, spill me,\nshock and thrill me!",
                "It's a lucky's world!\nDo or die!"
            }
        end
    end
    return dialogue[math.random(#dialogue)]
end

function Pippins:exitSpare()
    if self.exit_on_defeat then
        Game.battle.spare_sound:stop()
        Game.battle.spare_sound:play()

        local spare_flash = self:addFX(ColorMaskFX())
        spare_flash.amount = 0

        local sparkle_timer = 0
        local parent = self.parent

        Game.battle.timer:during(5/30, function()
            spare_flash.amount = spare_flash.amount + 0.2 * DTMULT
            sparkle_timer = sparkle_timer + DTMULT
            if sparkle_timer >= 0.5 then
                local x, y = Utils.random(0, self.width), Utils.random(0, self.height)
                local sparkle = SpareSparkle(self:getRelativePos(x, y))
                sparkle.layer = self.layer + 0.001
                parent:addChild(sparkle)
                sparkle_timer = sparkle_timer - 0.5
            end
        end, function()
			self.visible = false
            spare_flash.amount = 1
            local img1 = AfterImage(self, 0.7, (1/25) * 0.7)
            local img2 = AfterImage(self, 0.4, (1/30) * 0.4)
            img1:addFX(ColorMaskFX())
            img2:addFX(ColorMaskFX())
            img1.physics.speed_x = 4
            img2.physics.speed_x = 8
            parent:addChild(img1)
            parent:addChild(img2)
        end)
    end
end

function Pippins:onSpareable()
    --self:setAnimation("spared")
end

return Pippins