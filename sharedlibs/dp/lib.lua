local lib = {}

Registry.registerGlobal("DP", lib)
DP = lib

function lib:init()
    if MagicalGlassLib then
		Utils.hook(LightStatMenu, "draw", function(orig, self)
			orig(self)
			love.graphics.setFont(self.font)			
			local party = Game.party[self.party_selecting]
			if Game:getFlag("SHINY", {})[party.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
				Draw.setColor({235/255, 235/255, 130/255})
				love.graphics.print("\"" .. party:getName() .. "\"", 4, 8)
			end
			Draw.setColor(COLORS.white)
		end)
    end
end

function lib:onPause()
    if Game.tutorial then
        PauseLib.paused = false
        Assets.playSound("ui_cant_select",1.5)
    end
end

function lib:save(data)
    if not MagicalGlassLib then
        data.magical_glass = self.mg_data_preserve
    end
end

function lib:load(data)
    if not MagicalGlassLib then
        self.mg_data_preserve = data.magical_glass
    end
end

function lib:preDraw()
    Assets.getShader("palette"):send("debug",DEBUG_RENDER and ((RUNTIME/0.3)%1>.5))
end

return lib