---@class Item.testdog : Item
local item,super = Class(Item)

function item:init()
    super.init(self)
    self.name = "Dark Rock"
    self.saved_item = nil
    self.usable_in = "none"
	
	-- Battle description
    self.effect = "Gone\nfor now"
    -- Shop description
    self.shop = "Musical food\nwith a\ncrunch\nHeals 80HP"
    -- Menu description
    self.description = "A dark stone that lost its original form.\nLooking closely, you see... more rock."
	
	self.can_sell = false
	
	self.description = "A dark stone that lost its original form.\nLooking closely, you see... more rock."
end

function item:getDescription()
	if self.saved_item then
		return "A dark stone that lost its original form.\nLooking closely, you see the label \"" .. self.saved_item .. "\"."
	end
	return self.description
end

function item:onLoad(data)
    self.saved_item = data.id
end

function item:onSave(data)
    data.id = self.saved_item
end

return item