local MikeBoss, super = Class(Encounter)

function MikeBoss:init()
    super.init(self)

    self.music = "deltarune/mike"
    self.text = "* It's Mike!"

	self.mike_battle = true

    -- Add the dummy enemy to the encounter
    self.mike_a = self:addEnemy("mike")
	self.mic = Mod.mic_controller
    self.mike_con = nil
	
	self.flee = false

    self.boss_rush = false
	
    if Game:getFlag("mike_defeated") == true then
        self.boss_rush = true
    end
end

function MikeBoss:onBattleStart()
    self.mike_con = Game.battle:addChild(MikeController(0, 0))
end

function MikeBoss:petBattler(battler)
	local battler = battler or nil
	if battler then
		Game.battle:startCutscene(function(cutscene)
			Game.battle.battle_ui.encounter_text.text.mike_mode = true
			Game.battle.battle_ui.encounter_text.text.mike_advance_time = 60
			Game.battle.battle_ui.encounter_text.text.mike_extra_time = 0

			if battler.id == "kris" or battler.id == "hero" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* The Maus offered you a Fruit Bonus!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* It was crunchy, and not very fruit like!")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* It was sort of effective!")
				else
					cutscene:text("* It was effective!")
				end

			elseif battler.id == "susie" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* The Maus was bitten!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* ...", "", "susie")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* Lay off, idiot!", "", "susie")
				else
					cutscene:text("* Touch me and you'll lose a finger, dumb ass!", "", "susie")
				end

			elseif battler.id == "ralsei" then
				self.party_heals[battler.id] = self.party_heals[battler.id] + 1
				cutscene:text("* Ralsei got pet!")
				if self.party_heals[battler.id] >= 3 then
					cutscene:text("* ... petting overdose!", "", "ralsei")
				elseif self.party_heals[battler.id] == 2 then
					cutscene:text("* Haha, i-is it okay to receive this much attention!?", "", "ralsei")
				else
					cutscene:text("* Ahahah! That tickles!", "", "ralsei")
				end
			else
				cutscene:text("* Mike got pet!")
			end
			
			Game.battle.battle_ui.encounter_text.text.mike_mode = false
			cutscene:endCutscene()
			
			Game.battle.timer:after(1/30, function()
				Game.battle:startCutscene("mike.enemy_dialogue")
				Game.battle:setState("MIKEENEMYDIALOGUE") 
			end)
		end)
	end
end

function MikeBoss:onStateChange(old,new)
    super.onStateChange(self, old, new)

    if self.mike_con then
        if self.mike_con.hand then
            self.mike_con.hand_x = self.mike_con.arena_x
            self.mike_con.hand_y = self.mike_con.arena_y
            self.mike_con.hand.mouse_x = self.mike_con.hand_x
            self.mike_con.hand.mouse_y = self.mike_con.hand_y
        end

        if new == "ACTIONSELECT" then
            Game.battle:setSelectedParty(0)
            Game.battle:setState("MIKEPARTYTURN")

            if self.mike_con.mic.right_click_mic == 0 then
                self.mike_con.allow_sensitivity_adjust = true
            end

            self.mike_con.hand.visible = true
            self.mike_con.display_fake_arena = true

        elseif new == "MIKEENEMYDIALOGUE" then
            self.mike_con.hand.visible = false
            self.mike_con.display_fake_arena = false
        end
    end
end

return MikeBoss
