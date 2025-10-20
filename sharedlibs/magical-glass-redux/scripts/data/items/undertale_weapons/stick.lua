local item, super = Class(LightEquipItem, "undertale/stick")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Stick"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 150

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Its bark is worse than its bite."

    -- Light world check text
    self.check = "Weapon AT 0\n* Its bark is worse than\nits bite."

    -- Consumable target mode ("ally", "party", "enemy", "enemies", or "none")
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
end

function item:onWorldUse(target)
    Game.world:showText("* You threw the stick away.\n* Then picked it back up.")
    return false
end

function item:onBattleSelect(user, target)
    return false
end

function item:onLightBattleUse(user, target)
    Game.battle:battleText(self:getLightBattleText(user, target))
end

function item:onBattleUse(user, target) end

function item:getLightBattleText(user, target)
    if Game.battle.encounter.onStickUse then
        return Game.battle.encounter:onStickUse(self, user, target)
    else
        return "* "..user.chara:getNameOrYou().." threw the stick away.\n* Then picked it back up."
    end
end

function item:getBattleText(user, target)
    if Game.battle.encounter.onStickUse then
        return Game.battle.encounter:onStickUse(self, user, target)
    else
        return "* "..user.chara:getName().." threw the stick away.\n* Then picked it back up."
    end
end


return item