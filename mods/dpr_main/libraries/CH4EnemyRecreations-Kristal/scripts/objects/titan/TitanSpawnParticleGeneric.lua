---@class TitanSpawnParticleGeneric : Object
---@overload fun(...) : TitanSpawnParticleGeneric
local TitanSpawnParticleGeneric, super = Class(Object)

function TitanSpawnParticleGeneric:init(x, y)
    super.init(self, x, y, 4, 4)
	
	self.sprite = Sprite("effects/titan/pixel_white")
    self:addChild(self.sprite)
	
    self.fade_rate = 0
    self.shrink_rate = 0
    self.acceleration_type = 0
    self.acceleration_rate = 0
    self.acceleration_goal = 0

    self:setScale(1,1)

    self:setColor({204/255, 77/255, 253/255})
end

function TitanSpawnParticleGeneric:update()
    super.update(self)
	
    self.alpha = MathUtils.approach(self.alpha, 0, self.fade_rate * DTMULT)
    self.scale_x = MathUtils.approach(self.scale_x, 0, self.shrink_rate * DTMULT)
    self.scale_y = MathUtils.approach(self.scale_y, 0, self.shrink_rate* DTMULT)

    if self.acceleration_rate ~= 0 then
        if self.acceleration_type == 0 then
            self.physics.speed = MathUtils.approach(self.physics.speed, self.acceleration_goal, self.acceleration_rate * DTMULT)
        elseif self.acceleration_type == 1 then
            self.physics.speed = self.physics.speed * (self.acceleration_rate * DTMULT)
        end
    end

    if self.scale_x == 0 or self.scale_y == 0 or self.alpha == 0 then
        self:remove()
    end    
	
	local size = self.width + self.height
    local x, y = self:getScreenPos()
    if x < -size or y < -size or x > SCREEN_WIDTH + size or y > SCREEN_HEIGHT + size then
        self:remove()
    end
end

return TitanSpawnParticleGeneric