local item, super = Class(Item, "binariband")

function item:init()
    super.init(self)

    -- Display name
    self.name = "BinariBand"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A headband that glows with 1s and 0s. Perfect for those who understand."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 2
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
	}

    -- Character reactions
    self.reactions = {
        susie = "What's with all the numbers!?",
        ralsei = "It... doesn't feel right...",
        noelle = "I don't understand...",
		jamm = "Nice! This looks great!",
    }
end

function item:onEquip(character, replacement)
    if Utils.containsValue({"jamm", "brenda", "bor", "ddelta", "nell"}, character.id) then
        character:increaseStat("attack", 4)
        self.bonus_name = "Coded"
        self.bonus_icon = "ui/menu/icon/magic"
    end
    return true
end

function item:onUnequip(character, replacement)
    if Utils.containsValue({"jamm", "brenda", "bor", "ddelta", "nell"}, character.id) then
        character:increaseStat("attack", -4)
        self.bonus_name = nil
        self.bonus_icon = nil
    end
    return true
end

return item
