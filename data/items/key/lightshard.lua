local item, super = Class(Item, "lightshard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "LightShard"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A gemstone made of piercing white light."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "world"
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

function item:getCollected()
    return Game:getFlag("light_shards", 0)
end

function item:getDescription()
    local desc = super.getDescription(self)
    if self:getCollected() > 0 then
        desc = desc .. "\nYou have collected [" .. self:getCollected() .. "]."
    end
    return desc
end

function item:onWorldUse()
    if Game:getFlag("last_got_light_shard") then
		local location = Game:getFlag("last_got_light_shard")
        Game.world:showText({
            "* You held the gemstone up to your eye.",
            "* In a flash of light, you remember the " .. location .. "..."
        })
        self:setFlag("last_got_light_shard", nil)
    else
        Game.world:showText({
            "* You held the gemstone up to your eye.",
            "* But nothing happened..."
        })
    end
end

function item:convertToLight(inventory)
    local glass = inventory:addItem("light/sglass")
    glass.flags = self.flags
    return true
end

return item