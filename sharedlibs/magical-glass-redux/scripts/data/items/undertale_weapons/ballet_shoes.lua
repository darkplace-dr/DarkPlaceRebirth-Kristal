local item, super = Class(LightEquipItem, "undertale/ballet_shoes")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ballet Shoes"
    self.short_name = "BallShoes"
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
    self.description = "These used shoes make you feel incredibly dangerous."

    -- Light world check text
    self.check = "Weapon AT 7\n* These used shoes make you\nfeel incredibly dangerous."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

    self.bonuses = {
        attack = 7
    }

    self.light_bolt_count = 3
    self.light_bolt_speed = 10
    self.light_bolt_speed_variance = 0
    self.light_bolt_start = -90
    self.light_bolt_miss_threshold = 2
    self.light_bolt_direction = "right"
    self.light_multibolt_variance = {{0, 25, 50}, {100, 125, 150}}
    
    self.bolt_count = 3
    self.multibolt_variance = {{50, 75}}

    self.attack_sound = "punchstrong"
    
    self.can_equip = {
        ["susie"] = false
    }
end

function item:showEquipText(target)
    Game.world:showText("* " .. target:getNameOrYou().." equipped Ballet Shoes.")
end

function item:showEquipTextFail(target)
    Game.world:showText("* " .. target:getNameOrYou() .. " didn't want to equip Ballet Shoes.")
end

function item:getLightBattleText(user, target)
    local text = "* "..target.chara:getNameOrYou().." equipped "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave the "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." equipped it."
    end
    return text
end

function item:getLightBattleTextFail(user, target)
    local text = "* "..target.chara:getNameOrYou().." didn't want to equip "..self:getUseName().."."
    if user ~= target then
        text = "* "..user.chara:getNameOrYou().." gave "..self:getUseName().." to "..target.chara:getNameOrYou(true)..".\n" .. "* "..target.chara:getNameOrYou().." didn't want to equip it."
    end
    return text
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    if damage <= 0 then
        enemy:onDodge(battler, true)
    end
    local src = Assets.stopAndPlaySound(self:getLightAttackSound() or "laz_c")
    src:setPitch(self:getLightAttackPitch() or 1)

    local sprite = Sprite("effects/lightattack/hyperfoot")
    sprite.battler_id = battler and Game.battle:getPartyIndex(battler.chara.id) or nil
    table.insert(enemy.dmg_sprites, sprite)
    sprite:setOrigin(0.5)
    local relative_pos_x, relative_pos_y = enemy:getRelativePos((enemy.width / 2) - (#Game.battle.attackers - 1) * 5 / 2 + (Utils.getIndex(Game.battle.attackers, battler) - 1) * 5, (enemy.height / 2))
    sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
    sprite.layer = LIGHT_BATTLE_LAYERS["above_arena_border"]
    sprite.color = {battler.chara:getLightMultiboltAttackColor()}
    enemy.parent:addChild(sprite)
    Game.battle:shakeCamera(2, 2, 0.35)

    if crit then
        if Utils.equal({battler.chara:getLightMultiboltAttackColor()}, COLORS.white) then
            sprite:setColor(Utils.lerp(COLORS.white, COLORS.yellow, 0.5))
        else
            sprite:setColor(Utils.lerp({battler.chara:getLightMultiboltAttackColor()}, COLORS.white, 0.5))
        end
        Assets.stopAndPlaySound("saber3")
    end

    Game.battle:shakeAttackSprite(sprite)

    Game.battle.timer:after(10/30, function()
        self:onLightAttackHurt(battler, enemy, damage, stretch, crit)
    end)

    sprite:play(2/30, false, function(this) 
        this:remove()
        Utils.removeFromTable(enemy.dmg_sprites, this)
    end)

    return false
end

return item