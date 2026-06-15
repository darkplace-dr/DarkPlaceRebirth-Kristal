local item, super = Class(LightEquipItem, "undertale/empty_gun")

function item:init()
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
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 12
    }

    self.light_bolt_count = 4
    self.light_bolt_speed = 15
    self.light_bolt_speed_variance = 0
    self.light_bolt_start = 120
    self.light_bolt_miss_threshold = 2
    self.light_multibolt_variance = {{180, 210, 240}, {300, 330, 360}, {400, 430, 460}}
    self.light_bolt_direction = "right"
    
    self.bolt_count = 4
    self.multibolt_variance = {{40, 60}}

    self.attack_sound = "gunshot"
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    local sprite = self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/gunshot_stab", color = true,
      crit_color = true, speed = 2/30, loop = true, scale = 2})

    Game.battle.timer:after(6/30, function()
        sprite:remove()
        TableUtils.removeValue(enemy.dmg_sprites, sprite)

        local stars = {}
        for i = 0, 7 do
            local star = self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/gunshot_stab", color = true,
              crit_color = true, speed = 4/30, loop = true, scale = 1, crit_sound = true, sound = false, trigger_dodge = false})
            star.siner = 45 * i
            star.star_sine_amt = 0
            star.star_speed = 16
            star.star_grav = -2
            star.star_ang = 20
            star.star_size = 0.5
            star.removable = false
            star.rotation = math.rad(20 * i)
            star.visible = false
            star.init_x = star.x
            star.init_y = star.y
            table.insert(stars, star)
        end

        Game.battle.timer:doWhile(function() return #stars > 0 end, function()
            for i, star in ipairs(stars) do
                star.visible = true
                star.siner = star.siner + 15 * DTMULT

                star.star_sine_amt = star.star_sine_amt + star.star_speed * DTMULT
                star.star_speed = star.star_speed + star.star_grav * DTMULT

                local a = math.rad(star.siner)
                star.rotation = star.rotation - math.rad(star.star_ang * DTMULT)
                star.x = star.init_x + math.sin(a) * star.star_sine_amt
                star.y = star.init_y + math.cos(a) * star.star_sine_amt
                if star.star_speed < 0 then
                    star.alpha = star.alpha - 0.07 * DTMULT
                end

                star.star_size = 1 + (star.star_speed / 20)
                if star.star_size < 0.2 then
                    star.star_size = 0
                end

                star:setScale(star.star_size)

                if star.star_sine_amt > 0.5 then
                    star.removable = true
                elseif star.removable then
                    star:remove()
                    TableUtils.removeValue(enemy.dmg_sprites, star)
                    stars[i] = nil
                end
            end
        end)

        local ring_opacity = 1
        Game.battle.timer:every(3/30, function()
            local ring = self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/gunshot_remnant", color = true,
              crit_color = true, speed = false, scale = 1, sound = false, trigger_dodge = false})
            local ring_form = false
            local ring_size = 1
            local ring_shots = 0
    
            Game.battle.timer:doWhile(function() return ring end, function()
                ring.alpha = ring_opacity
    
                if ring_form == false then
                    ring_size = ring_size + 0.5 * DTMULT
                end
        
                if ring_size > 3.5 then
                    ring_form = true
                end
        
                if ring_form == true then
                    ring_opacity = ring_opacity - 0.2 * DTMULT
                    ring_size = ring_size - 0.3 * DTMULT

                end
                
                ring:setScale(ring_size)
                
                if ring.alpha < 0.1 then
                    ring:remove()
                    TableUtils.removeValue(enemy.dmg_sprites, ring)
                    ring = nil
                end
            end)
        end, 4)
    end)
    
    Game.battle.timer:after(20/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)
    
    return false
end

return item