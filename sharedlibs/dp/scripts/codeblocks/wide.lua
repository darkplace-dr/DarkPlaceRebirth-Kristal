---@class CodeBlock.wide : CodeBlock
local block, super = Class(CodeBlock, "wide")

function block:init()
    super.init(self)
    self.text = "Widen"
    self.description = "Makes the APM a little wider."
end

function block:run(scope)
	local battler = Game.battle:getPartyBattler("apm")
	battler:setScale(battler.scale_x + 0.05, battler.scale_y)
    return {"SKIP", nil, nil, nil}
end

return block

-- Look, SDM, I did your request!