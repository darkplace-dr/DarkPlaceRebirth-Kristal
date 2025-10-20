---@class Border.battle : Border
local border,super = Class(Border)

function border:draw()
    love.graphics.setColor(0, 0, 0, BORDER_ALPHA)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)

    love.graphics.setLineStyle("rough")
    love.graphics.setLineWidth(2)

    local offset = (Kristal.getTime() * 30) % 100
    local overdraw = 350 * BORDER_SCALE
    for i = -12, 27 do
        love.graphics.setColor(66 / 255, 0, 66 / 255, BORDER_ALPHA / 2)
        love.graphics.line(-overdraw, -210 + (i * 50) + math.floor(offset / 2), BORDER_WIDTH * BORDER_SCALE + overdraw, -210 + (i * 50) + math.floor(offset / 2))
        love.graphics.line(-200 + (i * 50) + math.floor(offset / 2), 0, -200 + (i * 50) + math.floor(offset / 2), BORDER_HEIGHT * BORDER_SCALE)
    end

    for i = -12, 27 do
        love.graphics.setColor(66 / 255, 0, 66 / 255, BORDER_ALPHA)
        love.graphics.line(-overdraw, -100 + (i * 50) - math.floor(offset), BORDER_WIDTH * BORDER_SCALE + overdraw, -100 + (i * 50) - math.floor(offset))
        love.graphics.line(-100 + (i * 50) - math.floor(offset), 0, -100 + (i * 50) - math.floor(offset), BORDER_HEIGHT * BORDER_SCALE)
    end

    love.graphics.setColor(0, 1, 0, BORDER_ALPHA)

    local width = 5

    love.graphics.setLineWidth(width)

    local left = 160 - width / 2
    local top = 30 - width / 2

    love.graphics.rectangle("line", left, top, 640 + width, 480 + width)
end

return border