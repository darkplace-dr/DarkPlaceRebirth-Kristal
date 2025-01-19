local empty_gun, super = Class(LightEquipItem, "mg_item/empty_gun")

function empty_gun:init()
    super.init(self)

    -- Display name
    self.name = "Empty Gun"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "Bullets NOT\nincluded."
    -- Default shop price (sell price is halved)
    self.price = 350
    -- Default shop sell price
    self.sell_price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "An antique revolver.\nIt has no ammo."

    -- Light world check text
    self.check = {
        "Weapon AT 12\n* An antique revolver.[wait:10]\n* It has no ammo.",
        "* Must be used precisely, or\ndamage will be low."
    }

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 12
    }

    -- The amount of bolts spawned when attacking.
    -- Having more than 1 changes point calculation.
    self.bolt_count = 4

    -- How fast this item's bolts move
    self.bolt_speed = 15
    -- A random bonus added to this item's bolt speed.
    -- For example, if bolt_speed is 11, setting this to 2 would result
    -- in the speed being a floating point number anywhere between 11-13. 
    self.bolt_speed_variance = nil

    -- An offset to where this item's bolt spawns.
    -- If it's a table, a random value will be picked from said table.
    self.bolt_start = 120

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "right"

    -- A table of numbers or tables that determine where bolts spawned after
    -- the first bolt should spawn.
    -- Number entries always place a bolt in a certain positions, table entries
    -- will get a random value picked from them.
    self.multibolt_variance = {{180, 210, 240}, {300, 330, 360}, {400, 430, 460}}

    -- The sound played when attacking.
    self.attack_sound = "gunshot"
end

function empty_gun:onLightBattleAttack(battler, enemy, damage, stretch, attack, crit)
    local after_func = function()
        Game.battle:finishActionBy(battler)
    end

    local color = COLORS.white
    if crit then
        color = {1, 1, 130/255, 1}
    end

    local x, y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
    local anim = EmptyGunAnim(x, y, crit, {sound = self:getAttackSound(), after = after_func, color = color})
    Game.battle:addChild(anim)

    return false
end

return empty_gun