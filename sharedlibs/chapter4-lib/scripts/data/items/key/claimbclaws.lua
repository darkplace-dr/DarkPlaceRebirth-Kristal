---@class Item.claimbclaws : Item
local item, super = Class(Item, "claimbclaws")

function item:init()
    super.init(self)
    self.name = "ClaimbClaws"
    self.description = "Claws so small they conveniently can't be seen. Use them to climb up obvious walls."
    self.usable_in = "none"
    self.type = "key"
end

return item