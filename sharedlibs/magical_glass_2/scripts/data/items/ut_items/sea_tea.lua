local item, super = Class(LightHealItem, "mg_item/sea_tea")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Sea Tea"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "drink"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "drinks"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 10

    -- The sound that plays when this item is used
    self.use_sound = "speedup"

    -- Shop description
    self.shop = "Heals 10HP\nSPEED\nup in\nbattle."
    -- Default shop price (sell price is halved)
    self.price = 18
    -- Default shop sell price
    self.sell_price = 5
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Made from glowing marshwater."

    -- Light world check text
    self.check = "Heals 10 HP\n* Made from glowing marshwater.\n* Increases SPEED for one battle."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getLightBattleText(user, target)
    if target.chara.you then
        return super.getLightBattleText(self, user, target) .. "\n* Your SPEED boosts!"
    else
        return super.getLightBattleText(self, user, target) .. "\n* " .. target.chara:getName() .. "'s SPEED boosts!"
    end
end

function item:onLightBattleUse(user, target)
    if Game.battle.soul.speed < 8 then
        Game.battle.soul.speed = Game.battle.soul.speed + 1
    end
    super.onLightBattleUse(self, user, target)
end

return item