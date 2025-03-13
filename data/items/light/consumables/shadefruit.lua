local item, super = Class(HealItem, "consumables/shadefruit")

function item:init()
    super.init(self)

    self.name = "Shadefruit"
    self.short_name = "Shadefruit"

    self.type = "item"
    self.light = true

    self.heal_amount = 15

    self.shop = ""
    self.price = 40
    self.sell_price = 20
    self.can_sell = true

    self.description = "A fruit native to Evershade Forest. Hopefully not poisonous."

    self.check = "Heals 15 HP\n* A fruit native to Evershade Forest. Hopefully not poisonous."

    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.use_method = "eat"
    self.use_method_other = "eats"
    
end

return item