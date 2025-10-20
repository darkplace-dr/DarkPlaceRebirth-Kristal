local item, super = Class(Item, "light/starsticker")

function item:init()
    super.init(self)

    -- Display name
    self.name = "StarSticker"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A sticker in the shape of a star."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
end

function item:onWorldUse()
    Game.world:showText({
        "* You looked to the sticker.",
        "* For a brief moment, it seems to glow."
    })
end

function item:onCheck()
    Game.world:showText({
        "* It's a star-shaped sticker, nothing much."
    })
end

function item:onToss()
    Game.world:showText({
        "* (You feel you shouldn't do this...)"
    })
    return false
end

function item:convertToDark(inventory)
    local star_bit = inventory:addItem("starbit")
    star_bit.flags = self.flags
    return true
end

return item