local Organikk, super = HookSystem.hookScript("organikk")

function Organikk:init()
    super.init(self)

    self:registerAct("Harmonize", "Musical,\ntouch\nGREEN", {"jamm"})
	
	self.mus_scale = 1
end

function Organikk:onAct(battler, name)
	if name == "Standard" then
        if battler.chara.id == "jamm" then
			Game.battle:startActCutscene(function(cutscene)
                cutscene:text("* Jamm practices his scales!")
                Game.battle.music:pause()
				
				local notes = {"do", "re", "mi", "fa", "so", "la", "ti", "do_a"}
				
				if self.mus_scale%8 == 2 then
					notes = {"do_a", "ti", "la", "so", "fa", "mi", "re", "do"}
				elseif self.mus_scale%8 == 3 then
					notes = {"do", "mi", "so", "mi", "do"}
				elseif self.mus_scale%8 == 4 then
					notes = {"do", "fa", "la", "fa", "do"}
				elseif self.mus_scale%8 == 5 then
					notes = {"re", "fa", "la", "fa", "re"}
				elseif self.mus_scale%8 == 6 then
					notes = {"do", "mi", "so", "do_a", "so", "mi", "do"}
				elseif self.mus_scale%8 == 7 then
					notes = {"do", "mi", "re", "fa", "mi", "so", "fa", "la", "so", "ti", "la", "do_a"}
				elseif self.mus_scale%8 == 0 then
					notes = {"do_a", "la", "ti", "so", "la", "fa", "so", "mi", "fa", "re", "mi", "do"}
				end
				
				for _, note in pairs(notes) do
					Assets.playSound("organ/"..note, 0.5)
					cutscene:wait(0.25)
				end
				
                Game.battle.music:resume()
                self:addMercy(50)
				
				self.mus_scale = self.mus_scale + 1
            end)
            return
        end
    end

    return super.onAct(self, battler, name)
end

return Organikk