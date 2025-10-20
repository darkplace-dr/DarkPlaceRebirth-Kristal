local item, super = Class(Item, "old_umbrella")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Old Umbrella"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/old_umbrella"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "* This is my umbrella.\n* I carry it with me everywhere."

    -- Default shop price (sell price is halved)
    self.price = 60
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

    --self.bolt_count = 10

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 0,
    }
    -- Bonus name and icon (displayed in equip menu)

        self.bonus_name = "  "
        --self.bonus_icon = "ui/missing_texture"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        noel = true,
    }

    -- Character reactions
    self.reactions = {
        noel = "What the FUCK?! Where did you get ANOTHER ONE?!",
        jamm = "I can take the rain.",
        ceroba = {
            ceroba = "This is anything but a weapon.",
            noel = "(Uh huh.)"
        }
    }
end

function item:convertToLightEquip(chara)
    return "light/old_umbrella"
end

return item