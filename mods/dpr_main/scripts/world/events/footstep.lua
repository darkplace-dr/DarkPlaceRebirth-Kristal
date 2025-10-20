local Footstep, super = Class(Event)
function Footstep:init(data)
    local map = Game.world.map
    function map:onFootstep(chara, num)
        if num == 1 then
            Assets.playSound("step1")
        elseif num == 2 then
            Assets.playSound("step2")
        end
    end
    super.init(self, data)
end
return Footstep