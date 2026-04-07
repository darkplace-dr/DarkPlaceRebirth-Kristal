local Mizzle, super = HookSystem.hookScript("mizzle")

function Mizzle:init()
    super.init(self)

    self:registerAct("Sozzle", "TIRE by\nchance", {"jamm"})
end

function Mizzle:onAct(battler, name)
	if name == "Standard" then
		if battler.chara.id == "jamm" then
			self:addMercy(25)
			local text = {
				"* Jamm drinks cautiously!",
				"* Jamm accidentally spills a little!",
				"* Jamm flips his cup,[wait:5] but doesn't land it!"
			}
			return TableUtils.pick(text)
		end
	elseif name == "Sozzle" then
		Game.battle:startActCutscene(function(cutscene)
            local line1 = "* Jamm attempted to SOZZLE!"
            local madetired = 0
            for _,enemy in ipairs(Game.battle.enemies) do
                if not enemy.tired and love.math.random(1, 4) > 2 then
                    madetired = madetired + 1
                    enemy:setTired(true)
					enemy:addMercy(35)
                end
            end
            cutscene:text(line1.."\n* "..madetired.." fell for it!")
        end)
        return
    end

    return super.onAct(self, battler, name)
end

return Mizzle