local item, super = Class(LightEquipItem, "undertale/burnt_pan")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Burnt Pan"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Damage is rather consistent.\nConsumable items heal 4 more HP."

    -- Light world check text
    self.check = "Weapon AT 10\n* Damage is rather consistent.\n* Consumable items heal 4 more HP."

    -- Default shop sell price
    self.sell_price = 100
    -- Whether the item can be sold
    self.can_sell = true

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 10
    }

    self.heal_bonus = 4

    self.light_bolt_count = 4
    self.light_bolt_speed = 10
    self.light_bolt_speed_variance = 0
    self.light_bolt_start = -80
    self.light_bolt_miss_threshold = 2
    self.light_multibolt_variance = {{0, 25, 50}, {100, 125, 150}, {200}}
    self.light_bolt_direction = "left"
    
    self.bolt_count = 4
    self.multibolt_variance = {{50, 75}}

    self.attack_sound = "frypan"
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    if damage <= 0 then
        enemy:onDodge(battler, true)
    end
    local src = Assets.stopAndPlaySound(self:getLightAttackSound() or "laz_c")
    src:setPitch(self:getLightAttackPitch() or 1)

    local sprite = Sprite("effects/lightattack/impact")
    sprite.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
    table.insert(enemy.dmg_sprites, sprite)
    local stars = {}
    local angle = 6 * TableUtils.pick({1, -1})
    local form = 0
    local size = 2
    sprite:setScale(2)
    sprite:setOrigin(0.5)
    local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (TableUtils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
    sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
    sprite.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
    sprite.color = {battler.chara:getLightMultiboltAttackColor()}
    enemy.parent:addChild(sprite)
    sprite:play(1/30, true)

    if crit then
        if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
            sprite:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.yellow, 0.5))
        else
            sprite:setColor(ColorUtils.mergeColor({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
        end
        Assets.stopAndPlaySound("saber3")
    end

    for i = 0, 8 do
        local star = Sprite("effects/lightattack/frypan_star")
        star:setOrigin(0.5)
        local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (TableUtils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
        star:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
        star.layer = LIGHT_BATTLE_LAYERS["above_arena_border"] - 0.5
        star.physics.direction = math.rad(360 * i) / 8
        star.physics.friction = 0.34
        star.physics.speed = 8
        star.ang = 12.25
        star.color = {battler.chara:getLightMultiboltAttackColor()}
        if crit then
            if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
                star:setColor(ColorUtils.mergeColor(COLORS.white, COLORS.yellow, 0.5))
            else
                star:setColor(ColorUtils.mergeColor({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
            end
        end
        enemy.parent:addChild(star)
        star.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
        table.insert(enemy.dmg_sprites, star)
        table.insert(stars, star)
    end

    Game.battle.timer:during(25/30, function()
        sprite.rotation = sprite.rotation + math.rad(angle) * DTMULT
        if form == 0 then
            size = size + 0.3 * DTMULT
        end

        if size > 2.8 then
            form = 1
        end

        if form == 1 then
            size = size - 0.6 * DTMULT
            sprite.alpha = sprite.alpha - 0.2 * DTMULT
        end

        sprite:setScale(size)

        for _,star in ipairs(stars) do
            if star.physics.speed < 6 then
                star.alpha = star.alpha - 0.05 * DTMULT 
                if star.ang > 1 then
                    star.ang = star.ang - 0.5 * DTMULT
                end
            end

            star.rotation = star.rotation - math.rad(star.ang) * DTMULT
            if star.alpha < 0.05 then
                star:remove()
            end
        end
    end,
    function()
        sprite:remove()
        TableUtils.removeValue(enemy.dmg_sprites, sprite)
        for _,star in ipairs(stars) do
            star:remove()
            TableUtils.removeValue(enemy.dmg_sprites, star)
        end
    end)
    
    Game.battle.timer:after(20/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)

    return false
end

return item