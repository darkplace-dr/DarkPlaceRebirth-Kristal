---@class Map : Map
local Map, super = Utils.hookScript(Map)

function Map:onEnter()
    Noel:checkNoel()
end

function Map:onFootstep(char, num)
    local date = os.date("*t")
    if date.month == 3 and date.day == 14 and not Game:getFlag("disable_spongestep") then
        if num == 1 then
            Assets.playSound("spongestep_1")
        elseif num == 2 then
            Assets.playSound("spongestep_2")
        end
	end
end

return Map