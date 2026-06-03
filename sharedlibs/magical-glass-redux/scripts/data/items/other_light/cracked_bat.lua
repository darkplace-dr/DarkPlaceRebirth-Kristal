local item, super = Class(LightEquipItem, "mg/cracked_bat")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Cracked Bat"
    self.short_name = "CrackedBat"
    self.serious_name = "Bat"

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Default shop price (sell price is halved)
    self.price = 150
    self.sell_price = 10

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A light, wooden bat with a noticable crack on it."

    -- Light world check text
    self.check = "Weapon AT 8\n* A light, wooden bat with a noticable crack on it."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    
    self.bonuses = {
        attack = 8
    }
    
    self.attack_sprite = "effects/lightattack/bash"
    
    self.light_bolt_direction = "random"
    self.light_bolt_speed_variance = 0
    self.light_bolt_acceleration = 9
    
    self.bolt_acceleration = 6
end

function item:onLightAttackHurt(battler, enemy, damage, stretch, crit, finish)
    if damage > 0 then
        Assets.playSound("impact", 0.8)
        Game.battle:shake(true)
    end
    
    super.onLightAttackHurt(self, battler, enemy, damage, stretch, crit, finish)
end

return item