---@class Border.spinnysquarealt: Border
local SpinnySquareAlt, super = Class(Border)

function SpinnySquareAlt:init()
    super.init(self)
end

function SpinnySquareAlt:drawRect(max_depth, white)
    if max_depth < 0 then return end
    love.graphics.push("all")
    if white then
        Draw.setColor(.92,.92,.92)
    else
        Draw.setColor(0.2,0.2,0.2)
    end
    love.graphics.scale(
        Utils.clampMap(
            math.sin(Kristal.getTime()),
            -1, 1, 0.6, 0.93
        )
    )
    love.graphics.rotate(math.rad(20))
    love.graphics.rectangle("fill", -1000*BORDER_SCALE, -1000*BORDER_SCALE, 1000*2*BORDER_SCALE, 1000*2*BORDER_SCALE)
    self:drawRect(max_depth - 1, not white)
    love.graphics.pop()
end

function SpinnySquareAlt:draw()
    love.graphics.push("all")
    love.graphics.translate(1920*0.5*BORDER_SCALE, 1080*0.5*BORDER_SCALE)
    love.graphics.scale(2)
    love.graphics.push("all")
    love.graphics.rotate(math.rad(Kristal.getTime() * 20))

    self:drawRect(20, true)
    love.graphics.pop()
    love.graphics.scale(BORDER_SCALE)
    local thickness = 10
    local offset = thickness
    love.graphics.setLineWidth(thickness)
    offset = offset * math.sin(Kristal.getTime() * math.pi)
    offset = offset + (thickness * 2)
    local w,h = SCREEN_WIDTH+offset, SCREEN_HEIGHT+offset
    love.graphics.setColor(COLORS.lime)
    love.graphics.rectangle("line", -w/2,-h/2,w, h)
    love.graphics.pop()

    -- TODO: find a better way to add the fading
    Draw.setColor(COLORS.black, 1-BORDER_ALPHA)
    love.graphics.rectangle("fill", -love.graphics.getWidth(), -love.graphics.getHeight(), love.graphics.getWidth()*2, love.graphics.getHeight()*2)
end

return SpinnySquareAlt