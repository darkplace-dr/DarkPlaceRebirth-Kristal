local item, super = Class(LightHealItem, "ut_items/hush_puppy")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Hush Puppy"
    -- Name displayed in the normal item select menu
    self.short_name = "HushPupe"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "HushPuppy"

    -- How this item is used on you (ate, drank, eat, etc.)
    self.use_method = "eat"
    -- How this item is used on other party members (eats, etc.)
    self.use_method_other = "eats"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Amount this item heals
    self.heal_amount = 65

    -- Default shop sell price
    self.sell_price = 8
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "This wonderful spell will stop a dog from casting magic."

    -- Light world check text
    self.check = "Heals 65 HP\n* This wonderful spell will stop\na dog from casting magic."

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
end

function item:getWorldUseText(target)
    return "* "..target:getNameOrYou().." "..self:getUseMethod(target).." the Hush Puppy.\n* Dog-magic is neutralized."
end

function item:getLightBattleText(user, target)
    if not Game.battle.encounter.serious then
        return "* "..target.chara:getNameOrYou().." "..self:getUseMethod(target.chara).." the Hush Puppy.\n* Dog-magic is neutralized."
    else
        return super.getLightBattleText(self, user, target)
    end
end

return item