local Numb, super = Class("StatusCondition")

function Numb:init()
	super.init(self)
	
	self.name = "Numb"
	
	self.desc = "While this status effect is applied, the user won't take any damage. However, once it's cured, they'll take all of the damage they would've taken."
	
	self.default_turns = 3
	
	self.icon = "ui/status/numb"
end

function Numb:onStatus(battler)
	battler.numb = 0
	self.invincible = 0
end

function Numb:onHurt(battler, amount)
	battler.numb = battler.numb + amount
	return self.invincible * amount
end

function Numb:onCure(battler)
	self.invincible = 1
	battler:hurt(battler.numb, true)
end

return Numb