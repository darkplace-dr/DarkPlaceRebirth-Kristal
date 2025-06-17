---@class CodeBlock.wide : CodeBlock
local block, super = Class(CodeBlock, "wide")

function block:init()
    super.init(self)
    self.text = "Widen"
    self.description = "Makes the APM a little wider."
end

function block:run(scope)
	local battler
	for k,v in pairs(Game.battle.party) do
		if v.chara.id == "apm" then
			battler = v
			break
		end
	end
	battler:setScale(battler.scale_x + 0.05, battler.scale_y)
    return {"SKIP", nil, nil, nil}
end

return block

-- Look, SDM, I did your request!