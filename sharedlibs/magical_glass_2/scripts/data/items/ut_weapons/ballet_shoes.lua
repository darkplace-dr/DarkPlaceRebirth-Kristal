local ballet_shoes, super = Class(LightEquipItem, "mg_item/ballet_shoes")

function ballet_shoes:init()
    super.init(self)

    -- Display name
    self.name = "Ballet Shoes"
    -- Name displayed in the normal item select menu
    self.short_name = "BallShoes"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Shoes"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop sell price
    self.sell_price = 80
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "These used shoes make you feel extra dangerous."

    -- Light world check text
    self.check = "Weapon AT 7\n* These used shoes make you feel\nextra dangerous."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 7
    }

    -- The amount of bolts spawned when attacking.
    -- Having more than 1 changes point calculation.
    self.bolt_count = 3

    -- How fast this item's bolts move
    self.bolt_speed = 10
    -- A random bonus added to this item's bolt speed.
    -- For example, if bolt_speed is 11, setting this to 2 would result
    -- in the speed being a floating point number anywhere between 11-13. 
    self.bolt_speed_variance = nil

    -- An offset to where this item's bolt spawns.
    -- If it's a table, a random value will be picked from said table.
    self.bolt_start = -90

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "right"

    -- A table of numbers or tables that determine where bolts spawned after
    -- the first bolt should spawn.
    -- Number entries always place a bolt in a certain positions, table entries
    -- will get a random value picked from them.
    self.multibolt_variance = {{0, 25, 50}, {100, 125, 150}}

    -- The sound played when attacking.
    self.attack_sound = "punchstrong"
end

function ballet_shoes:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " equipped Ballet Shoes.")
end

function ballet_shoes:getLightBattleText(user, target)
    return "* " .. target.chara:getNameOrYou() .. " equipped Ballet Shoes."
end

function ballet_shoes:onLightBattleAttack(battler, enemy, damage, stretch, attack, crit)
    local after_func = function()
        Game.battle:finishActionBy(battler)
    end

    local color = COLORS.white
    if crit then
        color = {1, 1, 130/255, 1}
    end

    local x, y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
    local anim = HyperAttackAnim(x, y, nil, {sound = self:getAttackSound(), crit = crit, after = after_func, color = color})
    Game.battle:addChild(anim)

    return false
end

return ballet_shoes