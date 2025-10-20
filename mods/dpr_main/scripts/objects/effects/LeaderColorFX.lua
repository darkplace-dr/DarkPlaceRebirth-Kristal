local LeaderColorFX, super = Class(RecolorFX)

function LeaderColorFX:draw(texture)
    Draw.setColor(Game.party[1].color)
    Draw.drawCanvas(texture)
end

function LeaderColorFX:getColor()
    if Game.party[1] then
        return Game.party[1]:getColor()
    end
    return super.getColor(self)
end

return LeaderColorFX