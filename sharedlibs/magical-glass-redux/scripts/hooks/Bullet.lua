local Bullet, super = HookSystem.hookScript(Bullet)

function Bullet:init(x, y, texture)
    super.init(self, x, y, texture)

    if Game:isLight() then
        -- Invulnerability timer to apply to the player when hit by this bullet
        self.inv_timer = Kristal.getLibConfig("magical-glass", "default_invuln_time") / 30
    end

    self.type = "white"
    self.heal_amount = nil
    self.karma = nil
    -- Whether to remove this bullet when it collides with the arena
    self.remove_on_arena_collision = false
    
    -- Green soul
    self.green_deflect_collider = nil
end

function Bullet:update()
    super.update(self)
    
    if self.remove_on_arena_collision then
        Object.uncache(self)
        Object.startCache()
        local collided, target = Game.battle:checkSolidCollision(self)
        Object.endCache()
        
        if collided then
            self:remove()
        end
    end
end

function Bullet:getType()
    return self.type
end

function Bullet:setType(type)
    self.type = type

    if self:getType() == "blue" then
        self:setColor(20/255, 169/255, 255/255)
    elseif self:getType() == "orange" then
        self:setColor(255/255, 160/255, 64/255)
    elseif self:getType() == "green" then
        self:setColor(0, 1, 0)
    else
        self:setColor(1, 1, 1)
    end
end

function Bullet:onCollide(soul)
    if self:getType() == "green" then
        self:onHeal(soul)
        self.destroy_on_hit = true
    end
    if self:getType() == "blue" and soul:isMoving() or self:getType() == "orange" and not soul:isMoving() or not TableUtils.contains({"blue", "orange"}, self:getType()) then
        if soul.inv_timer == 0 then
            self:onDamage(soul)
            if self.destroy_on_hit then
                self:remove()
            end
        elseif self.destroy_on_hit == true then
            self:remove()
        end
    end
end

function Bullet:getHealTarget()
    return "ANY"
end

function Bullet:getHealAmount()
    return self.heal_amount or 1
end

function Bullet:onHeal(soul)
    local target = self:getHealTarget()
    local battlers = Game.battle:heal(self:getHealAmount(), true, target)

    return battlers
end

function Bullet:canGraze()
    if self:getType() == "green" then
        return false
    else
        return super.canGraze(self)
    end
end

function Bullet:getKarma()
    return self.karma or 0
end

function Bullet:onDamage(soul)
    local battlers = super.onDamage(self, soul)

    if self:getDamage() > 0 then
        local best_amount
        for _, battler in ipairs(battlers) do
            battler:addKarma(self:getKarma())
            local equip_amount = 0
            for _, equip in ipairs(battler.chara:getEquipment()) do
                equip_amount = equip_amount + equip:getInvBonus()
            end
            if not best_amount or equip_amount > best_amount then
                best_amount = equip_amount
            end
        end
        soul.inv_timer = soul.inv_timer + (best_amount or 0)
    end

    return battlers
end

function Bullet:getDamage()
    if self:getType() == "green" then
        return 0
    elseif Game:isLight() then
        return self.damage or (self.attacker and self.attacker.attack) or 0
    else
        return super.getDamage(self)
    end
end

-- Green soul
function Bullet:onGreenDeflect(crit)
    if crit then
        Assets.playSound("bell_bounce_short")
    else
        Assets.playSound("bell")
    end
    
    -- remove bullet
    self:remove()
end

-- Yellow soul
function Bullet:onYellowShot(shot, damage) end

return Bullet