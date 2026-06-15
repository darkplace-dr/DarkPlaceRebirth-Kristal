---@class Item.elixir: RegenItem    --sadge
local item, super = Class(RegenItem, "elixir")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Elixir"
    -- Name displayed when used in battle (optional)
    self.use_name = "MEGA-ELIXIR"

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Whether this item heals
    self.heals = true
    -- Whether this item regenerates mana
    --self.mana_regen_item = true

    -- Battle description
    self.effect = "+100HP\n+100MP"
    -- Shop description
    self.shop = "Mysterious\nflask\n+100HP and MP"
    -- Menu description
    self.description = "Mysterious flask with pretty colors. \nHeals 100HP and regenerates 100MP."

    -- Amount healed (HealItem variable)
    self.heal_amount = 100
    -- Amount healed (RegenItem variable)
    self.regen_amount = 100

    -- Default shop price (sell price is halved)
    self.price = 430
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "A bit spicy. I like it!",
        ralsei = self:getRalseiReaction(),
        noelle = "Oh wow... *cough* That's spicy."
    }
end

function item:getRalseiReaction()
    if Game:hasPartyMember("kris") then
        return "Oof. You like spicy stuff, Kris?"
    else
        return "Oof. That is spicy..."
    end
end

function item:onWorldUse(target)
    local consumed = super.onWorldUse(self, target)

    return consumed
end


return item