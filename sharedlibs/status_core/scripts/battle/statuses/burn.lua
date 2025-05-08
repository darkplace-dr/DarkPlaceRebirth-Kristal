local Burn, super = Class(StatusCondition)

function Burn:init()
	super.init(self)
	
	self.name = "Burn"
	
	self.desc = "Damages you for 1/10 of your max HP each turn, but never kills."
	
	self.default_turns = 3
	
	self.icon = "ui/status/burn"
end

function Burn:onTurnStart(battler)
	local mhp = battler.chara.stats["health"]
	local damage = math.floor(mhp/10)
	if damage >= battler.chara.health then
		damage = battler.chara.health - 1
	end
	battler:hurt(damage, true)
end

return Burn