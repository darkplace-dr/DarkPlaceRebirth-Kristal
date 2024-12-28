local item, super = Class(HealItem, "cheesepuffs")

function item:init()
    super.init(self)

    self.name = "CheesePuffs"
    self.use_name = nil

    self.type = "item"
    self.icon = nil

    self.effect = "Heals\nteam\n20HP"
    self.shop = "A bag of\ncheese puffs,\nto share.\nParty +20HP"
    self.description = "A bag of cheese puffs.\n+20 HP to all."

    self.heal_amount = 20

    self.price = 100
    self.can_sell = true

    self.target = "party"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.bonuses = {}
    self.bonus_name = nil
    self.bonus_icon = nil

    self.can_equip = {}

    self.reactions = {
        susie = "*Crunch* Mmm, tasty!",
        ralsei = "My fingers are all dusty now...",
        noelle = "H-hopefully this doesn't stain my teeth...",
        dess = "this is a certified cheetos classic",
        brenda = "(I'll just wipe my hands on my pants...)",
        jamm = "Isn't this dangerously cheesy???",
    }
end

return item