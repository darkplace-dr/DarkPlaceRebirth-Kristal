local Shadowguy, super = Class(EnemyBattler)

function Shadowguy:init()
    super.init(self)
	
    self.name = "Shadowguy"
    self:setActor("shadowguy")

    self.waves = {
		"shadowguy/sax",
		"shadowguy/tommygun",
	}
	
	self.check = "AT[image:ui/sharp_note_symbol, 9,-3] DF[image:ui/flat_note_symbol, 12,-1]\n* Battling's just a side gig. Playing on stage is the dream!"
	
	self.prev_wave = nil
	
	self.spare_points = 10
	self.attack = 11
	self.health = 421
	self.max_health = self.health
	self.gold = 75
	self.experience = 15
	
    self.text = {
        "* Shadowguy plays the blues, blues, blues.",
        "* Shadowguy snaps their fingers rhythmically.",
        "* Shadowguy rolls up their socks... secretly.",
        "* Shadowguy's got the moves and the groove"
    }
	
	self.low_health_text = "* Shadowguy's blues look bluer and bluer."
	self.tired_text = "* Shadowguy is on the midnight \ntrain to Dreamsville."
	self.spareable_text = "* Shadowguy look seriously jazzed."
	
	self:registerAct("Boogie", "Dance,\ndon't\nget hit!")
    self:registerAct("Sharpshoot", "Light\n'em up", "all")
	
	self.sharpshootmercy = 0
	self.sharpshoot_spared = false
	
	self.fsiner = 0
	self.shoot_target = "HATS"
	
	self.gainmercyovertime = false
	self.gainmercytimer = 0
	self.boogietarget = nil
	self.showtempmercy = false
	self.savepartyhp = {}
end

function Shadowguy:update()
	super.update(self)
	self.fsiner = self.fsiner + DTMULT
	if Game.battle.state == "DEFENDINGEND" and self.gainmercyovertime == true then
		self.gainmercyovertime = false
		self.gainmercytimer = 0
		Game.battle.timer:after(15/30, function() self.showtempmercy = false end)
		self.boogietarget:toggleOverlay(false) -- removes dance animation
		self.boogietarget = nil
	end
	if self.gainmercyovertime == true and (Game.battle.state == "DEFENDINGBEGIN" or Game.battle.state == "DEFENDING") then
		for i,battler in ipairs(Game.battle.party) do
			if self.savepartyhp[i] > battler.chara:getHealth() then
				self.gainmercyovertime = false
				self.gainmercytimer = 0
				Game.battle.timer:after(50/30, function() self.showtempmercy = false end)
				self.boogietarget = nil
			end
		end
		self.gainmercytimer = self.gainmercytimer + DTMULT
		if self.gainmercytimer >= 30 then
			self:addTemporaryMercy(1, true, {0, 100}, (function() return self.showtempmercy == false end))
			self.gainmercytimer = 29
		end
	end
end

function Shadowguy:getTarget()
	if self.gainmercyovertime == true then
		return self.boogietarget or Game.battle:randomTarget()
	else
		return Game.battle:randomTarget()
	end
end

function Shadowguy:onAct(battler, name)
    if name == "Boogie" then
		self:setAnimation("sax_b")
		battler:toggleOverlay(true) -- dance animation needs to stay through the enemy's turn
		battler.overlay_sprite:setAnimation("dance")
		battler:flash()
		local afterimage1 = AfterImage(battler, 0.6)
		local afterimage2 = AfterImage(battler, 1)
		afterimage1.physics.speed_x = 5
		afterimage2.physics.speed_x = 2.5
		battler.parent:addChild(afterimage1)
		battler.parent:addChild(afterimage2)
		self.gainmercyovertime = true
		self.showtempmercy = true
		self.boogietarget = battler
		for i,battler in ipairs(Game.battle.party) do
			self.savepartyhp[i] = battler.chara:getHealth()
		end
        self:addTemporaryMercy(5, true, {0, 100}, (function() return self.showtempmercy == false end))
        return string.format("* %s boogies past bullets!\n* SHADOWGUY gains mercy until you get hit!", battler.chara:getName())
	elseif name == "Standard" then
        if battler.chara.id == "jamm" and Game:getFlag("dungeonkiller") then
            return "* Jamm didn't feel like doing anything."
        end
		self:setAnimation("sax_b")
		battler:setAnimation("dance")
		battler:flash()
		local afterimage1 = AfterImage(battler, 0.6)
		local afterimage2 = AfterImage(battler, 1)
		afterimage1.physics.speed_x = 5
		afterimage2.physics.speed_x = 2.5
		battler.parent:addChild(afterimage1)
		battler.parent:addChild(afterimage2)
        self:addMercy(30)
		self:setTired(true)
		if battler.chara.id == "brenda" and Game:hasPartyMember("dess") and not Game:getFlag("shadowguy_bd") then
			Game.battle:startActCutscene("shadowguy", "bd_dance")
			return
		end
		if battler.chara.id == "jamm" and Game:hasPartyMember("dess") and not Game:getFlag("shadowguy_jd") then
			Game.battle:startActCutscene("shadowguy", "jd_dance")
			return
		end
        return "* " .. battler.chara:getName() .. " danced!"
    elseif name == "Sharpshoot" then
        Game.battle:addChild(ShadowguySharpshootAct(self.shoot_target))
        return
	end
	return super.onAct(self, battler, name)
end

function Shadowguy:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "jamm" and Game:getFlag("dungeonkiller") then
            return "* Jamm didn't feel like doing anything."
        end
		self:setAnimation("sax_b")
		battler:setAnimation("dance")
		battler:flash()
		local afterimage1 = AfterImage(battler, 0.6)
		local afterimage2 = AfterImage(battler, 1)
		afterimage1.physics.speed_x = 5
		afterimage2.physics.speed_x = 2.5
		battler.parent:addChild(afterimage1)
		battler.parent:addChild(afterimage2)
        self:addMercy(30)
		self:setTired(true)
        return "* " .. battler.chara:getName() .. " danced!"
    end
    return nil
end

function Shadowguy:isXActionShort(battler)
	if battler.chara.id == "brenda" and Game:hasPartyMember("dess") and not Game:getFlag("shadowguy_bd") then
		return false
	end
	if battler.chara.id == "jamm" and Game:hasPartyMember("dess") and not Game:getFlag("shadowguy_jd") and not Game:getFlag("dungeonkiller") then
		return false
	end
    return true
end

function Shadowguy:getEnemyDialogue()
    return false
end

function Shadowguy:onDefeat()
    super.onDefeat(self)
	
    local random_scream = love.math.random(1, 100)

    if random_scream > 3 and random_scream <= 12 then
        Assets.playSound("wilhelm", 0.8)
    elseif random_scream > 1 and random_scream <= 3 then
        Assets.playSound("tom_scream")
    elseif random_scream == 1 then
        Assets.playSound("go_alert2")
    else
        Assets.playSound("shadowguy_scream")
    end
end

function Shadowguy:getEncounterText()
	if love.math.random(0, 100) < 4 then
		return "* Smells like old saxophone reeds."
	else
		return super.getEncounterText(self)
	end
end

function Shadowguy:getNextWaves()
    if Game.battle.turn_count > 4 and love.math.random(0,200) < 2 then
        return {"shadowguy/censoredbulletpattern"}
    elseif #Game.battle:getActiveEnemies() == 1 then
        return {"shadowguy/tommygun"}
	end

    return super.getNextWaves(self)
end

return Shadowguy
