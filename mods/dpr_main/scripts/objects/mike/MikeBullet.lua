---@class MikeBullet : Bullet
local MikeBullet, super = Class(Bullet)

function MikeBullet:init(x, y, texture)
    super.init(self, x, y, texture)

    self.pettable = false
    self.grabbable = false
    self.check_oob = true

    self.remove_offscreen = false
    self.wall_destroy = false
    self.offcamera = 32
end

local function lengthDirX(length, dir)
    return math.cos(dir) * length
end

local function lengthDirY(length, dir)
    return math.sin(dir) * length
end

function MikeBullet:isPettable()
    return self.pettable
end

function MikeBullet:isGrabbable()
    return self.grabbable
end

function MikeBullet:canCheckOutOfBounds()
    return self.check_oob
end

function MikeBullet:outsideCamera(offset)
    self._offcamera = false
    self.rightx = self.x + self.width
    self.bottomy = self.y + self.height
    
    if (self.x > (SCREEN_WIDTH + offset) or self.rightx < -offset) or (self.y > (SCREEN_HEIGHT + offset) or self.bottomy < -offset) then
        self._offcamera = true
    end
    
    return self._offcamera
end

function MikeBullet:createSparkles(x, y, num, dir, col)
    local _num = num or 8
    local _dir = dir or MathUtils.randomInt(360+1)
    
    for i = 1, num do
        local _ob = HeartSparkle(x + lengthDirX(16, _dir + ((i / _num) * 360)), y + lengthDirY(16, _dir + ((i / _num) * 360)))
        _ob:setSpeed(4)
        _ob.physics.direction = -math.rad((i / num) * 360)
        _ob:setColor(col or COLORS.white)
        Game.battle:addChild(_ob)
    end
end

function MikeBullet:update()
    if self:canCheckOutOfBounds() then
        if self.wall_destroy then
            if (self.x < -80 or self.x > 760) or (self.y < -80 or self.y > 580) then
                self:remove()
            end
        elseif not self:outsideCamera(self.offcamera) then
            self.wall_destroy = true
        end
    end

    super.update(self)
end

return MikeBullet