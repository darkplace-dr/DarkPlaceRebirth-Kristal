---@class RimshotBall : Bullet
---@overload fun(...) : RimshotBall
local RimshotBall, super = Class(Bullet, "tenna/rimshot_ball")

function RimshotBall:init(x, y)
    super.init(self, x, y, "battle/bullets/tenna/ball_small")

    self:setScale(1)
    self.tp = 0.8
    self.damage = 80
    self.alpha = 0
    self.destroy_on_hit = false

    self.laugh_timer = 0
end

function RimshotBall:draw()
    super.draw(self)

    local laugh = Assets.getFrames("battle/bullets/tenna/allstars_laugh")
    local frame = math.floor(self.laugh_timer) % #laugh + 1

    Draw.draw(laugh[frame], 8, 8, 0, 1/3, 1/3, 24, 24)
end

return RimshotBall