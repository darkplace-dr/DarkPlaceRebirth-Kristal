---@class ProphecyEchoFX: FXBase
local ProphecyEchoFX, super = Class(FXBase)

function ProphecyEchoFX:init(priority)
    super.init(self, priority)
end

function ProphecyEchoFX:draw(texture)
    local xsin = 0;
    local ysin = math.cos((Kristal.getTime()*30) / 12) * 6;
    xsin = ysin
    for i=3,1,-1 do
        Draw.setColor({0.8,0.8,0.8}, .2)
        Draw.drawCanvas(texture, xsin * i, ysin * i);
        
    end
    Draw.setColor(COLORS.white)
    -- Draw.drawCanvas(texture, xsin, ysin);
    -- Draw.drawCanvas(texture, xsin, ysin);

    super.draw(self, texture)
end

return ProphecyEchoFX