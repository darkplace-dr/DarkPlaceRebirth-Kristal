local item, super = Class(Item, "white_ribbon")

function item:init()
    super.init(self)

    -- Display name
    self.name = "White Ribbon"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A crinkly hair ribbon that slightly\nincreases your defense."

    -- Default shop price (sell price is halved)
    self.price = 90
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
        defense = 2
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Cuteness"
    self.bonus_icon = "ui/menu/icon/up"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        dess = false,
    }

    -- Character reactions
    if Game.chapter == 2 then
        self.reactions = {
            susie = "Cool. A fist wrap.",
            ralsei = "It's nice being dressed up...",
            noelle = "... feels familiar.",
        }
        self.susie_rejection = "I said NO! C'mon already!"
    else
        self.reactions = {
            susie = "Cool. A fist wrap.",
            ralsei = "Um... D-do I look cute...?",
            noelle = "... feels familiar.",
        }
        self.susie_rejection = "Nope. Not in 1st grade anymore."
    end
    TableUtils.merge(self.reactions, {
        hero = "Whatever.",
        dess = "ew i hate cute things",
        jamm = "How adorable!",
        ["jamm+marcy"] = "It looks great on you, Marcy!",
        calypso = "It'll look good in me hair.",
        noel = "I'm so FANCY",
        ceroba = "Makes me feel nostalgic.",
        len = "(White... suck a nice color.)",
    })
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

return item
