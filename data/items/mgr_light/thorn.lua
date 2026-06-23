local item, super = Class(LightEquipItem, "mg/thorn")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Thorn"
    
    self.can_sell = false

    -- Item type (item, key, weapon, armor)
    self.type = "weapon"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "Dissociative trance to Noelle.\nWearer takes damage from pain.\nReduces the TP cost of ice spells."

    -- Light world check text
    self.check = {"Weapon 20 AT 30 MG[wait:10]\n* ...[wait:20][color:red] Noelle becomes stronger.[color:reset]\n* Dissociative trance to Noelle.", "* Wearer takes damage from [color:red]pain[color:reset].\n* Reduces the TP cost of ice spells."}

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    
    self.shop_magic = true

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        attack = 20,
        magic = 30
    }
    
    -- Attack sprite (only used for simple animations)
    self.attack_sprite = "effects/lightattack/slap"
    self.attack_pitch = 1.5
    
    self.can_equip = {
        ["susie"] = false
    }
    
    self.light_bolt_direction = "random"
    
    -- Default dark item conversion for this item
    self.dark_item = "thornring"
end

function item:onToss()
    if Game:getConfig("canTossLightWeapons") then
        Game.world:showText({
            "* (You tried to throw away the thorn...)",
            "* (But, [wait:5]for some odd reason,\n[wait:5]you couldn't.)"
        })
        return false
    else
        return super.onToss(self)
    end
end

function item:onBattleUpdate(battler)
    battler.thorn_ring_timer = (battler.thorn_ring_timer or 0) + DTMULT

    if battler.thorn_ring_timer >= (6 * 4) then
        battler.thorn_ring_timer = battler.thorn_ring_timer - (6 * 4)

        if battler.chara:getHealth() > MathUtils.round(battler.chara:getStat("health") / 3) then
            battler.chara:setHealth(battler.chara:getHealth() - 1)
        end
    end
end

function item:onLightBattleUpdate(battler)
    self:onBattleUpdate(battler)
end

return item