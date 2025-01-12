local bandage, super = Class(LightEquipItem, "mg_item/bandage")

function bandage:init()
    super.init(self)

    -- Display name
    self.name = "Bandage"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 150
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "It has already been used several times."

    -- Light world check text
    self.check = "Heals 10 HP\n* It has already been used\nseveral times."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Whether this item should be equipped when used in battles
    self.battle_swap_equip = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        flee = 100
    }
end

function bandage:onWorldUse(target)
    Assets.stopAndPlaySound("power")
    local heal_amount = self:applyWorldHealBonuses(10)
    Game.world:heal(target, heal_amount, "* "..target:getNameOrYou().." re-applied the bandage.", self)
    return true
end

function bandage:getLightBattleText(user, target, amount)
    return "* "..target.chara:getNameOrYou().." re-applied the bandage.\n" .. self:getLightBattleHealingText(user, target, amount)
end

function bandage:onLightBattleUse(user, target)
    Assets.stopAndPlaySound("power")
    local heal_amount = self:applyBattleHealBonuses(user, 10)
    target:heal(heal_amount)
    Game.battle:battleText(self:getLightBattleText(user, target, heal_amount))
end

function bandage:getLightBattleHealingText(user, target, amount)
    local maxed
    if target then
        maxed = target.chara:getHealth() >= target.chara:getStat("health")
    end

    if self.target == "ally" then
        if target.chara.you and maxed then
            return "* Your HP was maxed out."
        elseif maxed then
            return "* " .. target.chara:getName() .. "'s HP was maxed out."
        else
            return "* " .. target.chara:getNameOrYou() .. " recovered " .. amount .. " HP!"
        end
    end
end

return bandage