local item, super = Class(LightEquipItem, "light/old_clip")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Old Clip"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Whether this item is for the light world
    self.light = true

    self.price = 100

    -- Item description text (unused by light items outside of debug menu)
    self.description = "An old, wooden hairclip of a peculiar form.\nHas various flowers painted on it."

    -- Light world check text
    self.check = {
        "Armor 4 DF\n* An old,[wait:5] wooden hairclip of a peculiar form.",
        "* Has various flowers painted on it."
    }

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 3
    }

    -- Default dark item conversion for this item
    self.dark_item = "flowerclip"
end

function item:showEquipText(target)
    if target.id == "ceroba" then
        Game.world:showText("* Ceroba equipped her clip.")
    elseif target.id == Game.party[1].id then
        Game.world:showText("* You equipped Old Clip.")
    else
        Game.world:showText("* " .. target:getName() .. " equipped Old Clip.")
    end
end

function item:getLightBattleText(user, target)
    if target.chara.id == "ceroba" then
        return "* Ceroba equipped her clip."
    elseif target.chara.id == Game.battle.party[1].chara.id then
        return "* You equipped Old Clip."
    else
        return "* " .. target.chara:getName() .. " equipped Old Clip."
    end
end

return item