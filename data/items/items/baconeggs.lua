local item, super = Class(HealItem, "baconeggs")

function item:init()
    super.init(self)

    self.name = "BaconEggs"
    self.use_name = nil

    self.type = "item"

    self.effect = "Breakfast\nhealing"
    self.shop = "The Diner's\nclassic.\nHeals\naround 120HP"
    self.description = "A tray of the classic breakfast meal.\nCutlery included. Recovers around 120 HP."

    self.heal_amount = 120

    -- those depend on how much a character likes to have breakfast (and that meal)
    self.heal_amounts = {
        ["kris"] = 100,
        ["susie"] = 150,
        ["ralsei"] = 120,
        ["noelle"] = 80,
        ["dess"] = 80,
		["jamm"] = 120,
        ["calypso"] = 120,
        ["ceroba"] = 110,
    }

    self.price = 260
    self.can_sell = true

    self.target = "ally"
    self.usable_in = "all"
    self.result_item = nil
    self.instant = false

    self.reactions = {
        susie = "Hey, it's kinda good!",
        ralsei = "I never tried that before...",
        noelle = "Um... I'll leave the bacon...",
        dess = "ew meat in MY tray",
        jamm = "Just as good as homemade!",
        calypso = "Aye, a good start to me day!",
        ceroba = "Not MY usual breakfast meal.",
    }
end

return item
