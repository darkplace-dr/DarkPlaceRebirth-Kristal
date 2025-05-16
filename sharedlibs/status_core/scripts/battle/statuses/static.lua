local Static, super = Class("StatusCondition")

function Static:init()
	super.init(self)
	
	self.name = "Static"
	
	self.desc = "Any damage to any other party members will damage this party member for half the damage."
	
	self.default_turns = 3
	
	self.icon = "ui/status/static"
end

function Static:onOtherHurt(battler, other, amount)
	battler:hurt(amount/2, true)
end

return Static