local item, super = Class(Item, "lightaxe")

function item:init()
    super.init(self)

    -- Display name
    self.name = "LightAxe"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = "Deals extra\nto Undead."
    -- Menu description
    self.description = "Deals extra damage to undead.\nThere are no undead enemies."

    -- Default shop price (sell price is halved)
    self.price = 750
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
        attack = 8,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "LightDamage"
    self.bonus_icon = "ui/menu/icon/magic"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "I have the power!",
        ralsei = "I'm the Dark Prince...",
        noelle = "It's so bright it hurts my eyes!",
		dess = "no",
        brenda = "Die monster, you don't belong in this world!",
		jamm = "A light weapon? In a dark world? Sketchy...",
        calypso = "Yer ax be blinding me eyes!",
        ceroba = "What is this, divine light?",
        len = "So *uf* bright... and heavy!",
    }
    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 12 then
            return "Lets bring them back from the dead."
        elseif len_axe_progress > 7 then
            return "Feeling their demise on this thing..."
        elseif len_axe_progress > 3 then
            return "The undead are really heavy, huh?"
        end
    end
    super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local backslash = 30 / (1 + len_axe_progress / 20)
        if backslash > 0 then
            battler:hurt(backslash, true)
        end
        Game:addFlag(len_axe_progress, 1)
    end
end

return item
