local item, super = Class(HealItem, "soda_georg")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Soda Georg"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Legally\nDistinct\nSoda"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A soda that was given to you."

    -- Amount healed (HealItem variable)
    self.heal_amount = 160

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
        jamm = "So what was up with that guy...?"
    }
end

function item:getDescription()
    local s = "A soda that was given to you.\nYou got it at "
    -- TODO: Figure out 100 places the Soda Georg guy can interrupt your gameplay.
    local locations = {
        [1] = "Cliffside",
        [2] = "",
        [3] = "",
        [4] = "",
        [5] = "",
        [6] = "",
        [7] = "",
        [8] = "",
        [9] = "",
        [10] = "",
        [11] = "",
        [12] = "",
        [13] = "",
        [14] = "Ania's dungeon",
        [15] = "",
        [16] = "",
        [17] = "",
        [18] = "",
        [19] = "",
        [20] = "",
        [21] = "",
        [22] = "",
        [23] = "",
        [24] = "",
        [25] = "",
        [26] = "",
        [27] = "",
        [28] = "",
        [29] = "",
        [30] = "",
        [31] = "",
        [32] = "",
        [33] = "",
        [34] = "",
        [35] = "",
        [36] = "",
        [37] = "",
        [38] = "",
        [39] = "",
        [40] = "",
        [41] = "",
        [42] = "",
        [43] = "",
        [44] = "",
        [45] = "",
        [46] = "",
        [47] = "",
        [48] = "",
        [49] = "",
        [50] = "",
        [51] = "",
        [52] = "",
        [53] = "",
        [54] = "",
        [55] = "",
        [56] = "",
        [57] = "",
        [58] = "",
        [59] = "",
        [60] = "",
        [61] = "",
        [62] = "",
        [63] = "",
        [64] = "",
        [65] = "",
        [66] = "",
        [67] = "",
        [68] = "",
        [69] = "",
        [70] = "",
        [71] = "",
        [72] = "",
        [73] = "",
        [74] = "",
        [75] = "",
        [76] = "",
        [77] = "",
        [78] = "",
        [79] = "",
        [80] = "",
        [81] = "",
        [82] = "",
        [83] = "",
        [84] = "",
        [85] = "",
        [86] = "",
        [87] = "",
        [88] = "",
        [89] = "",
        [90] = "",
        [91] = "",
        [92] = "",
        [93] = "",
        [94] = "",
        [95] = "",
        [96] = "",
        [97] = "",
        [98] = "",
        [99] = "",
        [100] = ""
    }
    return s .. locations[Game:getFlag("FUN", 1)] .. "."
end

return item
