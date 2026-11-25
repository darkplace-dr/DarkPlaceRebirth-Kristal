---@class cloud : Sprite
---@overload fun(...) : cloud
local cloud, super = Class(Sprite)

function cloud:init(x, y, hexagon)
    super.init(self, hexagon and "effects/icespell/hexagon" or "world/clouds/clouds_1", x, y)
    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    

    self.physics.direction = 0
    self.physics.speed = 0
    self.siner = math.random(0,100)

    self.timer = 0
end

function cloud:postLoad()
    self.exists = MathUtils.randomInt(0,3)
        if self.exists == 1 then
        self:remove()
    end
    self.spritething = MathUtils.randomInt(1,3)
    if self.spritething == 1 then
    self:setSprite("world/clouds/clouds_1",0)
    end
    if self.spritething == 2 then
    self:setSprite("world/clouds/clouds_2",0)
    end
    if self.spritething == 3 then
    self:setSprite("world/clouds/clouds_3",0)
    end
end

function cloud:update()
    self.siner = self.siner + DT
        self.alpha = 0.6 + math.sin(self.siner/4)/3
        self.x = self.x + math.sin(self.siner/3)/8
        self.y = self.y + math.sin(self.siner/5)/10
    super.update(self)
end

return cloud