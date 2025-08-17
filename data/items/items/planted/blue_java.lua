local item, super = Class(HealItem, "blue_java")

function item:init()
    super.init(self)
    self.name = "Blue Java"
    self.use_name = "Blue Java Banana"
    self.type = "item"
    self.icon = nil
    self.effect = "Heals\n110HP"
    self.shop = "Healthy\nsnack\nheals 110HP"
    self.description = "A blue java banana, tastes a bit like vanilla\nice cream.  +110HP"
    self.heal_amount = 100
    self.world_heal_amounts = {
        ["susie"] = 60
    }
    self.price = 2000
    self.can_sell = true
    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false
    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil
    self.can_equip = {}

    self.reactions = {
    }
end

return item