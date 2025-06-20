local item, super = Class(Item, "glowpiece")

function item:init()
    super.init(self)

    -- Display name
    self.name = "GlowPiece"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Sell\nat\nshops"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A shiny piece of something bigger.\nIts value increases for each quest completed."

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
    return false
end

function item:onBattleSelect(user, target)
    -- Do not consume (it will taste bad)
    return false
end

function item:getPrice()
    local completed_quests = 0
    if Game and Game.quests_data then
        for id,quest in pairs(Game.quests_data) do
            if quest:isCompleted() then
                completed_quests = completed_quests + 1
            end
        end
    end
    return 100 + (completed_quests * 150)
end

function item:getBattleText(user, target)
    --if Game.battle.encounter.onGlowshardUse then
    --    return Game.battle.encounter:onGlowshardUse(self, user)
    --end
    return {"* "..user.chara:getName().." used the "..self:getUseName().."!", "* But nothing happened..."}
end

return item