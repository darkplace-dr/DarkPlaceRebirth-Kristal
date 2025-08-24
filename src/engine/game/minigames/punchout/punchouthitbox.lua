---@class PunchOutHitbox : Object
local PunchOutHitbox, super = Class(Object)

function PunchOutHitbox:init(x, y, w, h)
    super.init(self, x, y, w, h)
    
    self.collider = Hitbox(self, 0, 0, w, h)
    self.layer = Game.minigame.layer + 100
    self:setOrigin(0.5, 0.5)
    
    self.damage = damage
    self.hit_dodging = false
    self.hit_ducking = false
    self.hurt_length = 16
    self.invuln_length = self.hurt_length
    self.timer = 2.5
    self.hit_dir = 1
end

function PunchOutHitbox:update()
    super.update(self)
    self.timer = self.timer - DTMULT
    if self.timer <= 0 then
        self:remove()
    end
    local minigame = Game.minigame
    if minigame.state ~= "MAIN" then return end
    self:updateMainCollision()
end

function PunchOutHitbox:updateMainCollision()
    if self.collider and self.collider:collidesWith(Game.minigame.boxing_hero.janky_collider) then
        if Game.minigame.boxing_hero.dodging == 1 and self.hit_dodging == false then
            return
        end
        if Game.minigame.boxing_hero.ducking == 1 and self.hit_ducking == false then
            return
        end
        Game.minigame.boxing_hero:tryHurt(self.damage, self.hurt_length, self.invuln_length, self.hit_dir)
    end
end

function PunchOutHitbox:draw()
    super.draw(self)
    if DEBUG_RENDER then
        if self.collider then
            self.collider:draw(1,0,0,1)
        end
    end
end

return PunchOutHitbox