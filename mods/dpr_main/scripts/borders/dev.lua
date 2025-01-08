---@class Border.cliffside : ImageBorder
local MyBorder, super = Class(ImageBorder)

function MyBorder:init()
    super.init(self, "dev")
    if not self.color then
        self.color = {0.3,0.19,1}
    end
end

function MyBorder:draw()
    if Game.world.map.id == "floor2/dev/party" then
        local newColor = Game.party[1].color
        for i, v in ipairs(self.color) do
            if v > newColor[i] then
                v = v - 0.1
            elseif v < newColor[i] then
                v = v + 0.1
            end
        end
    end
    Draw.setColor(self.color)
    super.draw(self)
end

function MyBorder:update()
    super.update(self)
end

return MyBorder