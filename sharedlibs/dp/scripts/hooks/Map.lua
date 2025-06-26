---@class Map : Map
local Map, super = Utils.hookScript(Map)

function Map:onEnter()
    Noel:checkNoel()

	local can_kill = Game:getFlag("can_kill", false)	
    if Game.world.map.id:find("floortv/") and can_kill == true then
        self.tv_snow = Game.world:spawnObject(TVSnow())
        self.tv_snow.overlay = true
    end
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