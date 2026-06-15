local Footstep, super = Class(Event)
function Footstep:init(data)
	local properties = data and data.properties or nil
    local map = Game.world.map
    function map:onFootstep(chara, num)
		if properties and properties["player"] and not chara.is_player then return end
        if num == 1 then
            Assets.playSound("step1")
        elseif num == 2 then
            Assets.playSound("step2")
        end
    end
    super.init(self, data)
end
return Footstep