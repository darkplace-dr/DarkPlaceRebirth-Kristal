local Zapper, super = Class(EnemyBattler)

function Zapper:init()
    super.init(self)

    self.name = "Zapper"
    self:setActor("zapper_b")

    self.max_health = 421
    self.health = 421
    self.attack = 11
    self.defense = 0
    self.money = 80

    self.experience = 10

    self.spare_points = 10

    self.waves = {
        "zapper/cannon",		
        "zapper/laser"
    }

    self.dialogue = {
        "Hoofah\ndoofah.",
        "Yeah, yeah,\nMr. Tenna's\norders.",
        "Yeah, yeah,\nshow your ID!",
        "Deez buttons\nain't for\nshow, twerps."
    }
    self.dialogue_loud = {
        "CAN SOMEONE\nTURN THAT\nBACK DOWN?",
        "WHAT? I CAN'T\nHEAR YOU!!!",
        "TURN IT UP??\nOKAY, YOU DA BOSS!"
    }

    self.check = "\"Hoofer\",\n\"Clicker-Clacker\", any name,\nit'll do the work."

    self.text = {
        "* Zapper clicks and clacks, zip\nand zaps.",
        "* Zapper quickly presses the\nbuttons on its chest.",
        "* Zapper keeps just popping all\nnight long.",
        "* Zapper checks if Tenna is\nwatching."
    }
    self.low_health_text = "* Zapper's buttons feel mushy."
    self.tired_text = "* Zapper's seeing visions of\nLanino."
	self.spareable_text = "* Zapper blushes in infrared,\ntoo."

    self:registerAct("VolumeUp", "Bullets\ngive big\nTP...")
    self:registerAct("Mute", "Tire\nenemies", nil, 32)
    self:registerAct("OffButton", "Turn\nit off", "all", 100)

    self.killable = true

    self.volumeturnups = 0

    self.used_s_action = false
    self.changecolorcon = 0
    self.changecolorcount = 0
    self.changecolortimer = 0

    self.colortarget = COLORS.white
    self.colortarget2 = COLORS.white

    self.fountain_snd = Assets.getSound("fountain_make")
    self.soundtimer = 0
    self.pitchtarget = 0
    self.pitchtarget2 = 0
    self.pitch = 0

    self.closedcaptioncon = 0
    self.closedcaptioncon2 = 0
    self.closedcaptiontimer = 0
	
	self.muted = false
	self.displayvolumetimer = 0
	self.volumecounttimer = 0
	self.volumecount = 10
	self.volumecountdestination = 10
    self.volume_text_tex = Assets.getTexture("battle/enemies/zapper/volume_text")
    self.caption2_tex = Assets.getTexture("battle/enemies/zapper/caption2")
    self.volume_on_tex = Assets.getTexture("battle/enemies/zapper/volume_on")
    self.volume_off_tex = Assets.getTexture("battle/enemies/zapper/volume_off")
end

function Zapper:getNextWaves()
    if self.wave_override then
        return super.getNextWaves(self)
    end

    local enemies = Game.battle:getActiveEnemies()
    for _, enemy in ipairs(enemies) do
		if enemy.id == "shuttah" then
			return {"zapper/laser"}
		end
		if enemy.id == "shadowguy" and Game.battle.encounter.volume_up then
			return {"zapper/cannon"}
		end
		if enemy.id == "pippins" and Game.battle.encounter.volume_up then
			return {"zapper/cannon"}
		end
	end
    return super.getNextWaves(self)
end

function Zapper:update()
    super.update(self)

    -- S-Action-related code
    if self.used_s_action then
        if not self.fountain_snd:isPlaying() then
            self.fountain_snd:play()
        end

        if self.changecolorcon == 0 then
            self.colortarget2 = {ColorUtils.HSVToRGB(MathUtils.randomInt(0, 255)/255, 250/255, 255/255)}

            if self.changecolorcount == 5 then
                self.colortarget2 = COLORS.white
            end

            self.pitchtarget2 = 1 + MathUtils.random(2)
            self.changecolorcon = 1
        end
        if self.changecolorcon == 1 then
            self.changecolortimer = self.changecolortimer + (1 * DTMULT)
            self:setColor(ColorUtils.mergeColor(self.colortarget, self.colortarget2, self.changecolortimer / 3))
            self.pitch = MathUtils.lerp(self.pitchtarget, self.pitchtarget2, self.changecolortimer / 3)
            self.fountain_snd:setPitch(self.pitch)

            if self.changecolortimer >= 3 then
                self.colortarget = self.colortarget2
                self.pitchtarget = self.pitchtarget2
                self.changecolorcount = self.changecolorcount + 1
                self.changecolorcon = 0
                self.changecolortimer = 0
            end
        end

        if self.changecolorcount == 6 then
            self.fountain_snd:stop()
            self:setColor(COLORS.white)
            self.changecolorcount = 0
            self.used_s_action = false
        end
    end
end

function Zapper:onAct(battler, name)
    if name == "VolumeUp" then
        Game.battle:startActCutscene(function(cutscene)
            self:addMercy(25)
            if self.volumeturnups == 0 then
                cutscene:text("* You turned up the volume!")
				self.volumecountdestination = 15
				self.displayvolumetimer = 60
				self.volumecounttimer = (self.displayvolumetimer - 2) % 3
				Game.battle.music:setVolume(1.4)
                cutscene:text("* ...")
                cutscene:text("* The bullets increased in\nvolume, too...!\n(But, they'll give more TP!)")
            else
				self.volumecountdestination = 15
				self.displayvolumetimer = 60
				self.volumecounttimer = (self.displayvolumetimer - 2) % 3
				Game.battle.music:setVolume(1.4)
                cutscene:text("* The bullets increased in\nvolume! Try getting close to\ngather TP!")
            end
			Game.battle.encounter.volume_up = true
			if not self.muted then
				self.dialogue_override = TableUtils.pick(self.dialogue_loud)
			end
            self.volumeturnups = self.volumeturnups + 1
        end)
        return
    elseif name == "Mute" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* You hit the MUTE button!")
			self.muted = true
			self.volumecountdestination = 0
			self.displayvolumetimer = 60
			Game.battle.music:setVolume(0)
            cutscene:text("* ...")
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:setTired(true)
            end
            self:addMercy(75)
            cutscene:text("* All foes became TIRED!")
            self.dialogue_override = "       "
        end)
        return
    elseif name == "OffButton" then
        Game.battle:startActCutscene(function(cutscene)
            cutscene:text("* You hit the OFF button!")
            Game.battle:addChild(TVTurnOff({type=1}))
            cutscene:wait(1.5)
            for _, enemy in ipairs(Game.battle.enemies) do
                enemy:spare()
            end
            cutscene:after(function() Game.battle:setState("VICTORY") end)
        end)
        return
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(25)
			if not self.muted then
				self.dialogue_override = "D-don't touch\nthat, you's!"
			end

            Assets.playSound("damage")
            self:hurt(0, nil, nil, nil, false)
            self:onHurt(0, nil)
            self.hurt_timer = 1
            self.used_s_action = true

            return "* Susie mashed random buttons!"
        elseif battler.chara.id == "ralsei" then
			Game.battle:startActCutscene(function(cutscene)
				self:addMercy(25)
				if not self.muted then
					self.dialogue_override = "Hey, I can\nsee da music.!"
				end
				cutscene:text("* Ralsei enabled captions!")
				if not self.muted then
					self.closedcaptioncon = 1
					cutscene:wait(70/30)
				end
				self.closedcaptioncon = 0
			end)
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    return super.onAct(self, battler, name)
end

function Zapper:onTurnEnd()
	if self.volumecountdestination > 10 then
		self.volumecountdestination = 10
		self.displayvolumetimer = 20
		Game.battle.music:setVolume(1)
	end
	self.muted = false
	Game.battle.encounter.volume_up = false
end

function Zapper:draw()
	super.draw(self)
	love.graphics.push()
	love.graphics.origin()
	Draw.setColor(1,1,1,1)
	if self.displayvolumetimer > 0 then
		self.displayvolumetimer = self.displayvolumetimer - DTMULT
		self.volumecounttimer = self.volumecounttimer + DTMULT
		if self.volumecounttimer >= 2 and self.volumecount < self.volumecountdestination then
			self.volumecount = self.volumecount + 1
			self.volumecounttimer = 0
		elseif self.volumecounttimer >= 1 and self.volumecount > self.volumecountdestination then
			self.volumecount = self.volumecount - 1
			self.volumecounttimer = 0
		end
		Draw.draw(self.volume_text_tex, 186 - 4 + 12, 290 - 12, 0, 1, 1, 0, 24)
		for a = 0, 20 do
			if a <= self.volumecount then
				Draw.draw(self.volume_on_tex, 186 + (a * 12), 290, 0, 1.6, 1, 2, 11)
			else
				Draw.draw(self.volume_off_tex, 186 + (a * 12), 290, 0, 1, 1, 2, 11)		
			end
		end
	end
	if self.closedcaptioncon == 1 then
		Draw.draw(self.caption2_tex, 320, 60, 0, 1, 1, 152, 20)
	end
	love.graphics.pop()
end

return Zapper