local item, super = Class(HealItem, "top_cake")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Top Cake"
    -- Name displayed when used in battle (optional)
    self.use_name = "TOPCAKE"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\nteam\n160HP"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "This cake will make your taste buds\nspin! Heals 160 HP to the team."

    -- Amount healed (HealItem variable)
    self.heal_amount = 160

    -- Default shop price (sell price is halved)
    self.price = 150
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "Mmm, seconds!",
        ralsei = "Whoops.",
        noelle = "Happy birthday! Haha!",
		dess = "happy easter",
        jamm = "That's a LOT of sugar.",
        ["jamm+marcy"] = "Here. We'll split it, Marcy.",
        ceroba = "Are we celebrating something?",
    }
end

return item