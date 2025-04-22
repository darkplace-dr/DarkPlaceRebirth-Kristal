local item, super = Class(Item, "darkrock")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Dark Rock"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Gone\nfor now"
    -- Shop description
    self.shop = "Musical food\nwith a\ncrunch\nHeals 80HP"
    -- Menu description
    self.description = "A dark stone that lost its original form.\nLooking closely, you see... more rock."

    -- Default shop price (sell price is halved)
    self.price = nil
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "none"
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

    self.sounds = {}
end

function item:getDescription()
	if self:getFlag("item_id") then
		return "A dark stone that lost its original form.\nLooking closely, you see the label \"" .. self:getFlag("item_id") .. "\"."
	end
	return self.description
end

return item