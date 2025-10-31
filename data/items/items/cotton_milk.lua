local item, super = Class(HealItem, "cotton_milk")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Cotton Milk"
    -- Name displayed when used in battle (optional)
    --self.use_name = "TOPCAKE"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Heals\nteam\n40HP"
    -- Shop description
    self.shop = "Tasty Milk!\nHeals the\nTeam by 40 HP!"
    -- Menu description
    self.description = "Milk gotten from cows cuddled with love. Heals 40 HP to the team."

    -- Amount healed (HealItem variable)
    self.heal_amount = 40

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
        susie = "*Munch*",
        suzy = "*Munch*",
        ralsei = "Why, thank you!",
        noelle = "It's not liquid...",
        jamm = "I mean... Can't really complain."
    }
end

return item
