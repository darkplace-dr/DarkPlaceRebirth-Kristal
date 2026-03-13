local item, super = Class(Item, "master_medallion")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Master Medal"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/demon"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Spiky\nmedal"
    -- Menu description
    self.description = "A golden, spiky medallion that doubles your attack power at a risk."

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

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
        defense = -math.huge
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Master"
    self.bonus_icon = "ui/menu/icon/demon"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {
        susie = "",
        ralsei = "",
        noelle = "",
        jamm = "I feel like a master!",
    }

    -- Character reactions to wearing two
    self.reactions_double = {
        susie = "",
        ralsei = "",
        noelle = "",
        jamm = "The ultimate daredevil!!!",
    }
end

function item:getReaction(user_id, reactor_id, miniparty)
    local pm = Game:getPartyMember(reactor_id)
    local success, amount = pm:checkArmor("master_medallion")
    
    if amount == 0 then
        if miniparty and self.reactions[reactor_id.."+"..miniparty] then
            return self.reactions[reactor_id.."+"..miniparty]
        end
        return self.reactions[reactor_id]
    else
        if miniparty and self.reactions_double[reactor_id.."+"..miniparty] then
            return self.reactions_double[reactor_id.."+"..miniparty]
        end
        return self.reactions_double[reactor_id]
    end
end

return item
