local Lib = {}

function Lib:init()
    if Kristal.getLibConfig("questline", "print_console_intro") ~= false then
    	print("Loaded the Questline library by AcousticJamm.")
	end
end

function Lib:onKeyPressed(key)
    if Game.world and Game.world.state == "GAMEPLAY" and Input.is("quest", key) and not Game.battle and not Game.shop then
		Game.world:openMenu(QuestMenu())
	end
end

function Lib:postInit(new_file)
	if Game:getFlag("quest_menu_ever_opened") == nil then
		Game:setFlag("quest_menu_ever_opened", false)
	end
end

return Lib
