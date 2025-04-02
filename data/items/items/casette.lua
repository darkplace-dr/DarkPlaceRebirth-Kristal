local item, super = Class(Item, "casette")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Casette"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Play\nMusic"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Changes the current music, has two sides:\nOne for in and one for outside battle."

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
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onWorldUse(target)
    Game.world.music:play("whereverwearenow")
    return false
end

function item:onBattleSelect(user, target)
    Game.battle.music:play("facedown")
    return false
end

function item:getBattleText(user, target)
    return "* "..user.chara:getName().." changes the beat with "..self:getUseName().."!"
end

return item