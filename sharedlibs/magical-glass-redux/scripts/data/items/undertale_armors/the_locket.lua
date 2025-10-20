local item, super = Class(LightEquipItem, "undertale/the_locket")

function item:init()
    super.init(self)

    -- Display name
    self.name = "The Locket"
    self.short_name = "TheLocket"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 500
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "You can feel it beating."

    -- Light world check text
    self.check = "Armor DF 99\n* You can feel it beating."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        defense = 99
    }
end

function item:showEquipText()
    Game.world:showText("* Right where it belongs.")
end

function item:getLightBattleText(user, target)
    local text = "* Right where it belongs."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave the "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. text
    end
    return text
end

function item:getBattleText(user, target)
    if self:canEquip(target.chara) then
        local text = "* Right where it belongs."
        if user ~= target then
            text = "* "..user.chara:getName().." gave the "..self:getUseName().." to "..target.chara:getName().."!\n" .. text
        end
        return text
    else
        return super.getBattleText(self, user, target)
    end
end

return item