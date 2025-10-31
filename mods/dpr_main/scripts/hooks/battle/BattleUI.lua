---@class Battle : Battle
local BattleUI, super = Utils.hookScript(BattleUI)

function BattleUI:init()
    super.init(self)

	if Game.battle.encounter.is_jackenstein then
		self.draw_children_below = -100
		self.jackenstein_dancers = JackensteinDancers()
		self.jackenstein_dancers.layer = -100
		self:addChild(self.jackenstein_dancers)
	end
end

return BattleUI