local real_knife, super = Class(LightEquipItem, "mg_item/real_knife")

function real_knife:init()
    super.init(self)

    -- Display name
    self.name = "Real Knife"
    -- Name displayed in the normal item select menu
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

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 99
    }
    
    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "random"
end

function real_knife:showEquipText()
    Game.world:showText("* About time.")
end

function real_knife:getLightBattleText(user, target)
    return "* About time."
end

function real_knife:onLightBattleNextTurn(battler, turn)
    if turn == 1 then
        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
            enemy.mercy = 100
        end
    end
end

return real_knife