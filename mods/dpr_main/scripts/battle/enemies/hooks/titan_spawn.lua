local TitanSpawn, super = HookSystem.hookScript("titan_spawn")

function TitanSpawn:getXAction(battler)
	if Game:hasPartyMember("kris") then
		if battler.chara.id == "jamm" then
			return "RaiseKris"
		end
	end
    return super.getXAction(self, battler)
end

function TitanSpawn:onAct(battler, name)
	if name == "RaiseKris" then
        Game.battle:startActCutscene(function(cutscene)
            local kris = Game.battle:getPartyBattler("kris")
			self.wake_kris_count = self.wake_kris_count + 1
            cutscene:text("* "..battler.chara:getName().." used Raise Up!")
			kris:shake()
			cutscene:wait(0.5)
			battler:setAnimation("battle/idle")
			if kris then
				local kris_member = Game:getPartyMember("kris")
				if kris_member.health <= 0 then
					local reviveamt = math.abs(kris_member.health) + 50
					kris:heal(reviveamt)
				else
					cutscene:text("* (But, Kris wasn't DOWNed...)")
				end
			end
        end)
        return
    end
    return super.onAct(self, battler, name)
end

return TitanSpawn