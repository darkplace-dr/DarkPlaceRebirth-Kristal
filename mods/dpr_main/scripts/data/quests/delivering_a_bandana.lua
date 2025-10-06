---@class MyQuest : Quest
local MyQuest, super = Class(Quest, "delivering_a_bandana")

function MyQuest:init()
    super.init(self)
    self.name = "A Bandana Delivery"



    --self.description = [[[color:blue]Lazul[color:reset] has asked you to deliver a package to a [color:yellow]MAN[color:reset] at the [color:yellow]WARP HUB[color:reset].\nHe said the bin code was [color:yellow]00000000[color:reset].]]
    --if 
    self.description = {COLORS.dkgray, "Someone ", COLORS.white, "gave you this for you to deliver.\nyou may need to find where it belongs first.\nthere's a logo with a broken path going downards on itself"}
    --self.description = {COLORS.white, "White text, ", COLORS.red, "Red text"}
    self.progress_max = 0
end

function MyQuest:getDescription()
	if self:isCompleted() then
		return "Well done."
	end
	return self.description
end

return MyQuest
