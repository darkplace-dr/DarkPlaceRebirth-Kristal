local item, super = Class(Item, "light/special_spaghetti")

function item:init(inventory)
    super.init(self)

    -- Display name
    self.name = "Spaghetti"

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A strange plate of spaghetti. It's not yours to keep."

    -- Light world check text
    self.check = "It's not\nyours."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    
end

function item:onWorldUse()
    Game.world:startCutscene(function(cutscene)
        if Game.party[1].lw_health <= 5 then
            Game:gameOver(Game.world.player.x, Game.world.player.y)
            return true
        else
            Game.party[1].lw_health = Game.party[1].lw_health - 5
        end
        cutscene:text("* (You chewed on the spaghetti.\nYour face scrunches up.)")
    end)
    return true
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (The Spaghetti was\nthrown away like the\ntrash it is.)")
    end)
    return true
end

return item