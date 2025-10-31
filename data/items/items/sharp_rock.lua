local item, super = Class(Item, "sharp_stone")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Sharp Stone"
    -- Name displayed when used in battle (optional)
    self.use_name = "SHARP STONE"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Throw at\nenemies."
    -- Shop description
    self.shop = "Petrified stone."
    -- Menu description
    self.description = "A strange rock shaped like a weapon. Its handle is broken but it can still be thrown at enemies."

    -- Default shop price (sell price is halved)
    self.price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "battle"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Based on either how good they are at weilding a sword or how strong they can yeet something
    -- Swordsplay is better than the latter, hence Hero and Kris being better than Susie
    self.hurt_values = {
        hero =  120,
        kris =  120,
        susie = 100,
        dess = 70,
        noelle = 40,
        jamm = 70
    }
end

function item:onBattleSelect(user, target)
    Game.battle.timer:after(1, function()
        local value = self.hurt_values[user.id] or 60
        target:hurt(value)
    end)
    return true
end

function item:getBattleText(user, target)
    return "* "..user.chara:getName().." throws the "..self:getUseName().."!"
end

return item
