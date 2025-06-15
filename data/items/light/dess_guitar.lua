local item, super = Class(LightEquipItem, "dess_guitar")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Red Guitar"
    self.short_name = "RedGitar"
    self.serious_name = "Guitar"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A guitar that belongs to December Holiday."

    -- Light world check text
    self.check = {"Weapon AT 5\n* A guitar that belongs to December Holiday.", "* Upon closer inspection, there's a code taped to the inside."}

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 5,
    }
end

function item:convertToDarkEquip(chara)
    return "red_bat"
end

function item:showEquipTextFail(target)
    if target.id == "noelle" then
        Game.world:showText("* Better not let her know you stole her sister's guitar...")
    else
        Game.world:showText("* " .. target:getNameOrYou() .. " didn't want to equip Red Guitar.")
    end
end

function item:getLightBattleTextFail(user, target)
    local text = "* "..target.chara:getNameOrYou().." didn't want to equip "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." didn't want to equip it."
    end
    if target.chara.id == "noelle" then
        text = "* Not the best thing to do right now."
    end
    return text
end

function item:onManualEquip(target, replacement)
    local can_equip = true

    if target.id ~= "dess" then can_equip = false end
    if (not self:onEquip(target, replacement)) then can_equip = false end
    if replacement and (not replacement:onUnequip(target, self)) then can_equip = false end
    if (not target:onEquip(self, replacement)) then can_equip = false end
    if (not target:onUnequip(replacement, self)) then can_equip = false end
    if (not self:canEquip(target, self.type, 1)) then can_equip = false end

    -- If one of the functions returned false, the equipping will fail
    return can_equip
end

return item