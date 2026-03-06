---@class LoadingDog: Object
---@overload fun(x: integer, y:integer) : LoadingDog
---@field private progress number
---@overload fun() : LoadingDog
local LoadingDog, super = Class(Object, "LoadingDog")

function LoadingDog:init(x, y)
    super.init(self, x, y)
    self.progress = 0.0
    self.dog_frames = Assets.getFrames("kristal/loadingdog/dog_turn_full")
    self.border = 60
end

function LoadingDog:getVloc()
    return SCREEN_HEIGHT - (self.border + 20)
end

function LoadingDog:getRight()
    return SCREEN_WIDTH - (self.border * 2)
end

function LoadingDog:getLeft()
    return self.border
end

---@param progress number
function LoadingDog:setProgress(progress)
    self.progress = progress
end

function LoadingDog:getProgress()
    return self.progress
end

function LoadingDog:draw()
    local progress = self:getProgress()
    local yloc = -280 + (progress * 240)
    local animindex = MathUtils.wrap(math.floor(#self.dog_frames * progress) + 1, 1, #self.dog_frames)
    love.graphics.draw(self.dog_frames[animindex], 280, yloc - 28, 0, 4, 4)
    love.graphics.rectangle("fill", self:getLeft(), self:getVloc() - 20, self:getRight(), 20)
    Draw.setColor(COLORS.black)
    love.graphics.rectangle("fill", self:getLeft() + 2, (self:getVloc() - 20) + 2, self:getRight() - 4, 16);
    Draw.setColor(COLORS.white)
    love.graphics.rectangle("fill", self:getLeft() + 4, (self:getVloc() - 20) + 4, (self:getRight() - 8) * progress, 12)
end

return LoadingDog
