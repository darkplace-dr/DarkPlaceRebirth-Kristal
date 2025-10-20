local pre_ebott, super = Class(Map)

function pre_ebott:load()
	super.load(self)
end

function pre_ebott:init(world, data)
	super.init(self, world, data)
	if Game:getFlag("hometown_time", "day") == "night" then
		self.bg_color = Utils.hexToRgb("#0c1b2a")
	end
end

return pre_ebott