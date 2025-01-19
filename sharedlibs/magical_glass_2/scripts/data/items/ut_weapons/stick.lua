local stick, super = Class(LightEquipItem, "mg_item/stick")

function stick:init()
    super.init(self)

    -- Display name
    self.name = "Stick"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"

    -- Default shop sell price
    self.sell_price = 150

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Its bark is worse than its bite."

    -- Light world check text
    -- self.check = "Weapon AT 0\n* Whoa-oh-oh-oh-oh-oh-oh-oh story of undertale"
    self.check = "Weapon AT 0\n* Its bark is worse than\nits bite."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Whether this item should be equipped when used in battles
    self.battle_swap_equip = false
end

function stick:onWorldUse(target)
    Game.world:showText("* You threw the stick away.\n* Then picked it back up.")
    return false
end

function stick:onLightBattleSelect(user, target)
    return false
end

function stick:onLightBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target))
end

function stick:getLightBattleText(user, target)
    if Game.battle.encounter.onStickUse then
        return Game.battle.encounter:onStickUse(self, user)
    end

    return "* " .. user.chara:getNameOrYou() .. " threw the stick away.\n* Then picked it back up."
end

return stick