local item, super = Class(HealItem, "brutalist_candy_cane")

function item:init()
    super.init(self)

    -- Display name
    self.name = "B.CandyCane"
    --self.name = "BrutalistCandyCane"
    -- Name displayed when used in battle (optional)
    self.use_name = "BrutalistCandyCane"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    self.icon = nil

    self.effect = "???"
    --self.shop = ""
    -- Menu description
    self.description = "This is literally just an Allen Wrench...\nPlease add details..."

    self.heal_amount = -9999
    -- Amount this item heals for specific characters in the overworld (optional)
    self.world_heal_amounts = {
    }

    -- Default shop price (sell price is halved)
    self.price = 70
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
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
        noel = "I am fucking dead now.",
        jamm = "I... don't know what I was expecting.",
    }
end

return item
