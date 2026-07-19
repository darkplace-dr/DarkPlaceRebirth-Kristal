local item, super = Class(Item, "quadribbon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "QuadRibbon"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Four ribbons of multiple colors.\nFor true ribbon lovers."

    -- Default shop price (sell price is halved)
    self.price = 2000
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
        defense = 8,
        magic = 2,

        graze_size = 0.25,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "GrArea&Heal+"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        hero = false,
        dess = false,
		jamm = false
    }

    -- Character reactions
    self.reactions = {
        hero = "It's... too much ribbons.",
        susie = "On the wrists. Only.",
        ralsei = "Um... Around my horns? Maybe?",
        noelle = "A mini ribbon festival, faha!",
        dess = "more like quadsucking ass",
        jamm = "...The hell do you think?",
        ["jamm+marcy"] = "I can't fit it, Marcy...",
        calypso = "Aye, it be a lot o' tying.",
        noel = "FOUR bracelets?",
        ceroba = "... I look childish now, don't I?",
    }
    self.susie_rejection = "THEY'RE ALL TOGETHER NOW???"
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
