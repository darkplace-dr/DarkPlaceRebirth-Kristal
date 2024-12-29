local item, super = Class(Item, "oddstone")

function item:init()
    super.init(self)

    -- Display name
    self.name = "OddStone"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "odd"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Strange"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A strange, smooth dark grey stone, makes your\nhand numb touching it. Does... nothing?"

    -- Default shop price (sell price is halved)
    self.price = -math.huge
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
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

    -- Character reactions (key = party member id)
    self.reactions = {}
end

function item:canEquip(character, slot_type, slot_index)
    return true
end

function item:onWorldUse(target)
    return false
end

function item:onBattleSelect(user, target)
    return false
end

function item:getBattleText(user, target)
    return "* "..user.chara:getName().." stared at "..self:getUseName().."."
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        Game:setFlag("oddstone_tossed", true)
        cutscene:text("* You discarded the Odd Stone.")
        cutscene:text("* ... but despite throwing it away,[wait:5] oddly,[wait:5] you didn't feel its absence...")
        Game.inventory:removeItemFrom("oddities", 1)
    end)
    return false
end

function item:convertToLight(inventory)
    local marble = inventory:addItem("light/grey_marble")
    return true
end

return item
