---@class PunchOutHitbox : Object
local PunchOutWheel, super = Class(Sprite)

function PunchOutWheel:init(x, y)
    super.init(self, "minigames/punch_out/wheel_octagon", x, y)
    self:setScale(0.5, 0.5)
    self:setOrigin(0.5, 0.5)
    self.layer = Game.minigame.rectbg.layer-1
    self.physics.speed_x = 14
    self.graphics.spin = math.rad(20)
end

function PunchOutWheel:update()
    super.update(self)
    if self.wheel_hitbox then
        self.wheel_hitbox.x = self.x
        self.wheel_hitbox.y = self.y
    end
    if self.x >= 1000 or self.x <= -300 then
        self:remove()
    end
end

function PunchOutWheel:onRemove(parent)
    Game.minigame.boxing_queen:onWheelRemove()
    super.onRemove(self, parent)
end

return PunchOutWheel