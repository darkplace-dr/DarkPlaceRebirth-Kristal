---@class Border.glow: Border
local Glow, super = Class(Border)

function Glow:init()
    super.init(self)
end

function Glow:draw()
    love.graphics.setColor(0, 0, 0, BORDER_ALPHA)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    local offset = (Kristal.getTime() * 30)
    for i = 1, 8 do
        local width = (1 + math.sin(offset / 30)) * i * 8

        love.graphics.setLineWidth(width)
        love.graphics.setColor(0.5, 0.5, 0.5, 0.1 * BORDER_ALPHA)

        local left = 160 - width / 2
        local top = 30 - width / 2

        love.graphics.rectangle("line", left, top, 640 + width, 480 + width)
    end
end

return Glow