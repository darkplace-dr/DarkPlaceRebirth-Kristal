local item, super = Class(Item, "brave_ax")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Brave Ax"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Heroic &\nCool"
    -- Menu description
    self.description = "A glossy ax from a block warrior.\nSuitable for heroes."

    -- Default shop price (sell price is halved)
    self.price = 150
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
        attack = 2,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Guts Up"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Well, if I have to.",
        ralsei = "It's a bit too heavy...",
        noelle = "(W-wow, what presence...)",
		dess = "ffs no",
        jamm = "Too shiny. Don't want to dirty it.",
        calypso = "It be heavy...",
        ceroba = "Good fit for a hero. But not me.",
        noel = "Flashy yet Fleeting...",
        len = "*uf* this is... heavy!",
    }
    
    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 50 then
            return "Powerful."
        elseif len_axe_progress > 27 then
            return "Powerful... but still heavy."
        elseif len_axe_progress > 14 then
            return "Heavy."
        elseif len_axe_progress > 7 then
            return "Still heavy..."
        elseif len_axe_progress > 3 then
            return "Not getting any lighter..."
        end
    end
    return super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_black_knife_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 20 / (1 + len_black_knife_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
    end
    super.onAttackHit(self, battler, enemy, damage)
end

return item
