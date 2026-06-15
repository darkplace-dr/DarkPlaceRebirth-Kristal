local item, super = Class(LightEquipItem, "undertale/torn_notebook")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Torn Notebook"
    self.short_name = "TornNotbo"
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
        "* (After you get hurt by an\nattack,[wait:10] you stay invulnerable\nfor longer.)"
    }

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 2
    }

    self.light_bolt_count = 2
    self.light_bolt_speed = 10
    self.light_bolt_speed_variance = 0
    self.light_bolt_start = {-50, -25} 
    self.light_bolt_miss_threshold = 2
    self.light_bolt_direction = "left"
    self.light_multibolt_variance = {{0, 25, 50}}
    self.inv_bonus = 15 / 30
    
    self.bolt_count = 2
    self.multibolt_variance = {{40, 60}}

    self.attack_sound = "bookspin"
    self.attack_pitch = 0.9
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    local sprite = self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/notebook_attack", color = true,
      crit_color = true, speed = false, scale = 2})

    local impact = "effects/lightattack/impact"
    local siner = 0
    local timer = 0
    local hit = false
    
    Game.battle.timer:during(24/30, function()
        timer = timer + DTMULT
        
        if timer <= 14 then
            sprite.scale_x = (math.cos(siner / 2) * 2)
        else
            if not hit then
                sprite:setScale(0.5)
                Assets.stopAndPlaySound("punchstrong")
                if crit then
                    Assets.stopAndPlaySound("saber3")
                end
                sprite:setAnimation({impact, 1/30, true})
                hit = true
            else
                sprite.scale_x = sprite.scale_x + 0.5 * DTMULT
                sprite.scale_y = sprite.scale_y + 0.5 * DTMULT

                if sprite.scale_x > 3 then
                    sprite.alpha = sprite.alpha - 0.3 * DTMULT
                end

                if sprite.alpha < 0.1 then
                    sprite:remove()
                    TableUtils.removeValue(enemy.dmg_sprites, sprite)
                end
            end
        end
        siner = siner + DTMULT
    end,
    
    function(attack_sprite)
        sprite:remove()
        TableUtils.removeValue(enemy.dmg_sprites, attack_sprite)
    end)
    
    Game.battle.timer:after(24/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)
    
    return false
end

return item