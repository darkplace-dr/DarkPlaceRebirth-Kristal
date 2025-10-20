local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)

    if #Game:getFlag("_unlockedPartyMembers") > 5 then
    	Game.world.map:getTileLayer("layername").visible = false
    end

end

return map