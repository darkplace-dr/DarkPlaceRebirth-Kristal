local tough_glove, super = Class(LightEquipItem, "mg_item/tough_glove")

function tough_glove:init()
    super.init(self)

    -- Display name
    self.name = "Tough Glove"
    -- Name displayed in the normal item select menu
    self.short_name = "TuffGlove"
    -- Name displayed in the normal item select menu during a serious encounter
    self.serious_name = "Glove"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Shop description
    self.shop = "Slap 'em."
    -- Default shop price (sell price is halved)
    self.price = 50
    -- Default shop sell price
    self.sell_price = 50
    -- Whether the item can be sold
    self.can_sell = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A worn pink leather glove.\nFor five-fingered folk."

    -- Light world check text
    self.check = "Weapon AT 5\n* A worn pink leather glove.[wait:10]\nFor five-fingered folk."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 4
    }

    -- The direction this weapon's bolts travel.
    -- Currently, the multi-battler target object forces this to be left.
    self.bolt_direction = "random"

    -- A table of numbers or tables that determine where bolts spawned after
    -- the first bolt should spawn.
    -- Number entries always place a bolt in a certain positions, table entries
    -- will get a random value picked from them.
    self.multibolt_variance = {{15}, {50}, {85}}

    -- The sound played when attacking if onLightBattleAttack isn't overwritten.
    self.attack_sound = "punchstrong"

    self.tags = {"punch"}
end

function tough_glove:getBoltCount()
    if Game.battle.allow_party then
        return 1
    else
        return 4
    end
end

function tough_glove:getBoltSpeed()
    if Game.battle.allow_party then
        return self.bolt_speed * 1.2
    else
        return 12
    end
end

function tough_glove:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou() .." equipped Tough Glove.")
end

function tough_glove:getLightBattleText(user, target)
    return "* " .. target.chara:getNameOrYou() .. " equipped Tough Glove."
end

function tough_glove:onLightBattleBoltHit(battler, enemy, attack)
    if not Game.battle.allow_party and #attack.bolts >= 1 then
        Assets.playSound("punchweak")

        local x, y = enemy:getRelativePos(Utils.random(enemy.width), Utils.random(enemy.height))
        local punch = Sprite("effects/attack/regfist", x, y)
        punch:setOrigin(0.5)
        punch.layer = BATTLE_LAYERS["above_ui"] + 5
        Game.battle:addChild(punch)
        punch:play(2/30, false, function() punch:remove() end)
    end
end

function tough_glove:onLightBattleAttack(battler, enemy, damage, stretch, attack, crit)
    if Game.battle.allow_party then
        local tough_glove_attack = ToughGloveAttack(self, battler, enemy, damage)
        Game.battle:addChild(tough_glove_attack)

        return false, nil, true
    else
        local after_func = function()
            Game.battle:finishActionBy(battler)
        end
        
        local color = COLORS.white
        if crit then
            color = {1, 1, 130/255, 1}
        end
    
        local x, y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
        local finisher = HyperAttackAnim(x, y, {after = after_func, color = color, crit = crit})
        Game.battle:addChild(finisher)
    
        return false
    end
end

return tough_glove