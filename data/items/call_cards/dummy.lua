local item, super = Class(CallCardItem, "dummy")

function item:init()
    super.init(self)
    
    self.recruit_id = "dummy"
end

return item
