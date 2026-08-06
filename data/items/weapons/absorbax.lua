local item, super = Class(Item, "absorbax")

function item:init()
    super.init(self)

    -- Display name
    self.name = "AbsorbAx"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/axe"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A long, curved axe with an indent.\nScoop up HP when you attack."

    -- Default shop price (sell price is halved)
    self.price = 1234
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
    self.bonus_name = "Vampire"
    self.bonus_icon = "ui/menu/icon/demon"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        susie = true,
        len = true,
    }

    -- Character reactions
    self.reactions = {
        susie = "Scoopin' time.",
        ralsei = "Don't scoop me!",
        noelle = "That red... is that blood?",
        jamm = "Feels... vampiric.",
        calypso = "Aye, this feels wrong...",
        ceroba = "Don't even try it.", -- she's NOT getting scooped up
        len = "This is *uf* heavy...",
    }

    self.len_axe_progress_flag = "len_axe_handling"
end

function item:getReaction(user_id, reactor_id, miniparty)
    if reactor_id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        if len_axe_progress > 12 then
            return "Axe of the century."
        elseif len_axe_progress > 7 then
            return "Not... so heavy anymore?"
        elseif len_axe_progress > 3 then
            return "Still a bit heavy..."
        end
    end
    return super.getReaction(self, user_id, reactor_id, miniparty)
end

function item:onAttackHit(battler, enemy, damage)
    local heal_amount = math.ceil(battler.chara:getStat("health") * 0.1)

    if battler.chara.id == "len" then
        local len_axe_progress = Game:getFlag(self.len_axe_progress_flag, 0)
        local new_heal_amount = heal_amount * (len_axe_progress / 60)
        if new_heal_amount > heal_amount then
            new_heal_amount = heal_amount
        end
        Game:addFlag(len_axe_progress, 1)
    end

    battler:heal(heal_amount)
end

return item
