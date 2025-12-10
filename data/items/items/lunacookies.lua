local item, super = Class(HealItem, "lunacookies")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Luna Cookies"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Raises\nTP&HP\n25 4 All"
    -- Shop description
    self.shop = "4 Cookies\nRaises TP\n25% and\neveryone 25 HP"
    -- Menu description
    self.description = "Motherly cookies for her daughter and friends.\nRaises TP and HP by 25 for all in battle."

    -- Amount of TP this item gives (TensionItem variable)
    self.heal_amount = 25

    self.heal_amounts = {
        ["susie"] = 50
    }

    self.world_heal_amounts = {
        ["susie"] = 50
    }

    self.tp_amount = 25

    -- Default shop price (sell price is halved)
    self.price = 150
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "party"
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
    self.reactions = {
        susie = "There's one extra for me! Sweet!",
        ralsei = "Delicious!",
        noelle = "I'm glad you like it Susie!",
        jamm = "Huh. Tastes neat.",
    }
end

function item:onBattleSelect(user, target)
    self.tension_given = Game:giveTension(self.tp_amount)

    user:flash()

    local sound = Assets.newSound("cardrive")
    sound:setPitch(1.4)
    sound:setVolume(0.8)
    sound:play()

    user:sparkle(1, 0.625, 0.25)
end

function item:onBattleDeselect(user, target)
    Game:removeTension(self.tension_given or 0)
end

function item:onWorldUse(target)
    -- Heal all party members
    for _,party_member in ipairs(target) do
        local amount = self:getWorldHealAmount(party_member.id)
        Game.world:heal(party_member, amount)
    end
    return true
end

return item
