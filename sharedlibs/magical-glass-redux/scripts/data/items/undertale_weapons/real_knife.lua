local item, super = Class(LightEquipItem, "undertale/real_knife")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Real Knife"
    self.short_name = "RealKnife"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Here we are!"

    -- Light world check text
    self.check = "Weapon AT 99\n* Here we are!"

    -- Default shop sell price
    self.sell_price = 500
    -- Whether the item can be sold
    self.can_sell = true

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 99
    }

    self.light_bolt_direction = "random"
end

function item:showEquipText()
    Game.world:showText("* About time.")
end

function item:getLightBattleText(user, target)
    local text = "* About time."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave the "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. text
    end
    return text
end

function item:getBattleText(user, target)
    if self:canEquip(target.chara) then
        local text = "* About time."
        if user ~= target then
            text = "* "..user.chara:getName().." gave the "..self:getUseName().." to "..target.chara:getName().."!\n" .. text
        end
        return text
    else
        return super.getBattleText(self, user, target)
    end
end

return item