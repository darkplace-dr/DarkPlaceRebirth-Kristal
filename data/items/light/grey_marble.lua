local item, super = Class(Item, "light/grey_marble")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Grey Marble"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A cloudy, opaque, grey marble."

    -- Light world check text
    self.check = "A cloudy, opaque, grey marble."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Default dark item conversion for this item
    self.dark_item = "oddstone"
end

function item:onWorldUse()
    Game.world:showText("* It's just an average grey marble.")
    return false
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        Game:setFlag("oddstone_tossed", true)
        cutscene:text("* You left behind the Grey Marble.")
    end)
    return true
end

return item