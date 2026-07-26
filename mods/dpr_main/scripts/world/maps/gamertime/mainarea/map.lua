local Mainarea, super = Class(Map)

function Mainarea:onEnter()
    super.onEnter(self)

    if not Game:getFlag("gamertime_intro") then
	    Game.world:startCutscene("gamertime", "start")
    end
end

return Mainarea
