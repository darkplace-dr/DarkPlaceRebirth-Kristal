local item, super = Class(Item, "twinribbon2")

function item:init()
    super.init(self)

    -- Display name
    self.name = "TwinRibbon2"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Two ribbons branded after a certain\ncold drink."

    -- Default shop price (sell price is halved)
    self.price = 400
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
        defense = 5,
        magic = 2
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Heal+"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
		jamm = false,
        dess = false
    }

    -- Character reactions
    self.reactions = {
        hero = "Fits, surprisingly.",
        susie = "Fine. NOT in the hair though.",
        ralsei = "Around my horns goes well!",
        noelle = "Hey, are we advertising something!?",
        dess = "ew I hate pepsi",
        jamm = "I won't be tricked by the slushie colors.",
        ["jamm+marcy"] = "It won't work, sorry...",
        calypso = "Me hair be tied twice...",
        noel = "Two DIFFERENT bracelets?",
        ceroba = "The colors go well together.",
    }
    self.susie_rejection = "... those got worse too, huh."
end

function item:canEquip(character, slot_type, slot_index)
    if character.id == "susie" and not character:getFlag("can_wear_ribbons", false) then
        return false
    end

    return super.canEquip(self, character, slot_type, slot_index)
end

function item:getReaction(user_id, reactor_id)
    if user_id == "susie" and reactor_id == "susie" then
        local susie = Game:getPartyMember("susie")

        if not susie:getFlag("can_wear_ribbons", false) then
            return self.susie_rejection
        end
    end

    return super.getReaction(self, user_id, reactor_id)
end

function item:calculateBattleHeal(heal, base_heal, caster, target)
    -- Increase heal by 1/6 of the base heal for each equipped on the healer
    local heal_add = math.ceil(base_heal / 6)

    if caster ~= nil then
        local _, amount = caster:checkArmor(self.id)
        heal_add = heal_add * amount
    end

    return heal + heal_add
end

function item:calculateBattleHealPriority()
    return -0.9
end

return item
