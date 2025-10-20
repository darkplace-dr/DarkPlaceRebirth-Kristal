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
    self.light_bolt_miss_threshold = 3
    self.light_multibolt_variance = {{180, 210, 240}, {300, 330, 360}, {400, 430, 460}}
    self.light_bolt_direction = "right"
    
    self.bolt_count = 4
    self.multibolt_variance = {{40, 70}}

    self.attack_sound = "gunshot"
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    if damage <= 0 then
        enemy:onDodge(battler, true)
    end
    local src = Assets.stopAndPlaySound(self:getLightAttackSound() or "laz_c")
    src:setPitch(self:getLightAttackPitch() or 1)

    local sprite = Sprite("effects/lightattack/gunshot_stab")
    sprite.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
    table.insert(enemy.dmg_sprites, sprite)
    sprite:setScale(2)
    sprite:setOrigin(0.5)
    local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (Utils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
    sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
    sprite.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
    sprite.color = {battler.chara:getLightMultiboltAttackColor()}
    enemy.parent:addChild(sprite)
    sprite:play(2/30, true)

    if crit then
        if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
            sprite:setColor(Utils.lerp(COLORS.white, COLORS.yellow, 0.5))
        else
            sprite:setColor(Utils.lerp({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
        end
    end

    Game.battle.timer:after(6/30, function()
        sprite:remove()
        Utils.removeFromTable(enemy.dmg_sprites, sprite)

        local stars = {}
        for i = 0, 7 do
            local star = Sprite("effects/lightattack/gunshot_stab")
            star:setOrigin(0.5)
            star.siner = 45 * i
            star.star_sine_amt = 0
            star.star_speed = 16
            star.star_grav = -2
            star.star_ang = 20
            star.star_size = 0.5
            star.rotation = math.rad(20 * i)
            star.visible = false
            local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (Utils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
            star:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
            star.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
            star.init_x = star.x
            star.init_y = star.y
            star.color = {battler.chara:getLightMultiboltAttackColor()}
            if crit then
                if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
                    star:setColor(Utils.lerp(COLORS.white, COLORS.yellow, 0.5))
                else
                    star:setColor(Utils.lerp({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
                end
                Assets.stopAndPlaySound("saber3")
            end
            star.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
            table.insert(enemy.dmg_sprites, star)
            table.insert(stars, star)
            enemy.parent:addChild(star)
            star:play(4/30, true)
        end

        Game.battle.timer:during(1, function()
            for _,star in ipairs(stars) do
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

                if star.star_sine_amt <= 0.5 then
                    star:remove()
                    Utils.removeFromTable(enemy.dmg_sprites, star)
                end
            end
        end)

        local ring_opacity = 1
        Game.battle.timer:every(3/30, function()
            local ring = Sprite("effects/lightattack/gunshot_remnant")
            ring.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
            table.insert(enemy.dmg_sprites, ring)
            local ring_form = false
            local ring_size = 1
            local ring_shots = 0
            ring:setScale(1)
            ring:setOrigin(0.5)
            local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (Utils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
            ring:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
            ring.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
            ring.color = {battler.chara:getLightMultiboltAttackColor()}
            enemy.parent:addChild(ring)
    
            if crit then
                if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
                    ring:setColor(Utils.lerp(COLORS.white, COLORS.yellow, 0.5))
                else
                    ring:setColor(Utils.lerp({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
                end
            end
    
            Game.battle.timer:during(1, function()
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
                    if ring.alpha < 0.1 then
                        ring:remove()
                        Utils.removeFromTable(enemy.dmg_sprites, ring)
                    end
                end
    
                ring:setScale(ring_size)
            end)
        end, 4)
    end)
    
    Game.battle.timer:after(20/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)
    
    return false
end

return item