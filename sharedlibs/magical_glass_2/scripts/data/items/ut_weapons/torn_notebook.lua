local torn_notebook, super = Class(LightEquipItem, "mg_item/torn_notebook")

function torn_notebook:init()
    super.init(self)

    -- Display name
    self.name = "Torn Notebook"
    -- Name displayed in the normal item select menu
    self.short_name = "TorNotbo"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Notebook"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "Invincible\nlonger"
    -- Default shop price (sell price is halved)
    self.price = 55
    -- Default shop sell price
    self.sell_price = 50
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Contains illegible scrawls."

    -- Light world check text
    self.check = {
        "Weapon AT 2\n* Contains illegible scrawls.\n* Increases INV by 6.",
        "* (After you get hurt by an\nattack,[wait:10] you stay invulnerable\nfor longer.)" -- doesn't show up in UT???
    }

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 2,
        inv = 15/30
    }

    -- The amount of bolts spawned when attacking.
    -- Having more than 1 changes point calculation.
    self.bolt_count = 2

    -- How fast this item's bolts move
    self.bolt_speed = 10
    -- A random bonus added to this item's bolt speed.
    -- For example, if bolt_speed is 11, setting this to 2 would result
    -- in the speed being a floating point number anywhere between 11-13. 
    self.bolt_speed_variance = nil

    -- An offset to where this item's bolt spawns.
    -- If it's a table, a random value will be picked from said table.
    self.bolt_start = {-50, -25} 

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "left"
    -- A table of numbers or tables that determine where bolts spawned after
    -- the first bolt should spawn.
    -- Number entries always place a bolt in a certain positions, table entries
    -- will get a random value picked from them.
    self.multibolt_variance = {{0, 25, 50}}

    -- The sound played when attacking.
    self.attack_sound = "bookspin"
    -- The pitch of this item's attack sound.
    self.attack_pitch = 0.9
end

function torn_notebook:onLightBattleAttack(battler, enemy, damage, stretch, attack, crit)
    local after_func = function()
        Game.battle:finishActionBy(battler)
    end

    local color = COLORS.white
    if crit then
        color = {1, 1, 130/255, 1}
    end

    local x, y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
    local anim = TornNotebookAnim(x, y, crit, {sound = self:getAttackSound(), after = after_func, color = color})
    Game.battle:addChild(anim)

    return false
end

return torn_notebook