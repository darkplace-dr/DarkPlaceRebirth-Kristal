local item, super = Class(Item, "light/nazrin")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Page"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A page ripped from a doujinn featuring a manga mice."

    -- Light world check text
    self.check = "A page ripped from a doujinn featuring a manga mice."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
end

function item:onWorldUse()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* There is some text you can read.")
        cutscene:text("* Dianna, I'll always love you.")
        cutscene:text("* No one forced me and Kyouko to raise you.")
        cutscene:text("* You are the only one I am ready to die fighting for!")
        cutscene:text("* And besides, I did grow a bit obsessed, didn't I?")
        cutscene:text("* Let's make gold worthless again!")
    end)
    return false
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* Throwing it away doesn't feel right.")
        cutscene:text("* Do it anyway?")
        if cutscene:choicer({"Yes", "No"}) == 1 then
            Game.inventory:removeItem(self)
            Game:setFlag("nazrinpissed", true)
        else
            cutscene:text("* It feels right.")
        end
    end)
    return false
end

function item:convertToDark(inventory)
    return "nazrin_fumo"
end

return item