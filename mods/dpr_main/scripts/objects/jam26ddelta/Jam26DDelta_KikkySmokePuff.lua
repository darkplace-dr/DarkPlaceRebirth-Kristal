---@class Jam26DDelta_KikkySmokePuff : Object
---@overload fun(...) : Jam26DDelta_KikkySmokePuff
local Jam26DDelta_KikkySmokePuff, super = Class(Object)

function Jam26DDelta_KikkySmokePuff:init(x, y)
    super.init(self, x, y)

    self.frames = Assets.getFrames("world/events/beans/smokepuff")
    self.frame = 1

    self.time = 0

    self.width = self.frames[1]:getWidth()
    self.height = self.frames[1]:getHeight()
    self:setOriginExact(8, 8)
    self:setScale(1)

    self.play_sound = true
end

function Jam26DDelta_KikkySmokePuff:update()
    self.time = self.time + (1 * DTMULT)

    self.frame = math.floor(Utils.ease(0, #self.frames, self.time / 8, "outCubic")) + 1
    if self.time >= 8 then
        self:remove()
    end

    super.update(self)
end

function Jam26DDelta_KikkySmokePuff:draw()
    Draw.draw(self.frames[self.frame])
    super.draw(self)
end

return Jam26DDelta_KikkySmokePuff