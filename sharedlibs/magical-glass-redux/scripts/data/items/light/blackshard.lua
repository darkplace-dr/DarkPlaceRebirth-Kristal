local item, super = Class("light/blackshard", true)

function item:init()
    super.init(self)
    
    -- Display name
    self.short_name = "BlkShard"
    
    self.can_sell = false
    
    self.light_bolt_direction = "random"
    self.light_bolt_speed_multiplier = 1.5
    self.light_attack_crit_multiplier = 2.8
end

function item:onToss()
    if Game:getConfig("canTossLightWeapons") then
        Game.world:showText({
            "* (You didn't quite understand\nwhy...)",
            "* (But, the thought of discarding\nit felt very wrong.)"
        })
        return false
    else
        return super.onToss(self)
    end
end

function item:onLightAttack(battler, enemy, damage, stretch, crit)
    if crit then
        local sprite = self:startLightAttackAnimation(battler, enemy, damage, stretch, crit, {sprite = "effects/lightattack/blackshard", color = COLORS.red,
         speed = 6/30, shake = 1, scale = 1, loop = true, sound = "bigcut", trigger_dodge = false})
         
        Game.battle.timer:tween(3, sprite, {alpha = 0}, "out-quart", function()
            sprite:remove()
            TableUtils.removeValue(enemy.dmg_sprites, sprite)
        end)
    end
    
    return super.onLightAttack(self, battler, enemy, damage, stretch, crit)
end

function item:getAttackSprite(battler, enemy, points)
    return "effects/attack/shard"
end

return item