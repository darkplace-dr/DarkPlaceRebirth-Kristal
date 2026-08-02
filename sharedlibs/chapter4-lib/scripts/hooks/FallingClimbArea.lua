---@class FallingClimbArea : FallingClimbArea
local FallingClimbArea, super = HookSystem.hookScript(FallingClimbArea)

function FallingClimbArea:draw()
    if Game.world.map.cyltower then
        local cyltower = Game.world.map.cyltower

        love.graphics.push()
        love.graphics.origin()
        love.graphics.translate(-(Game.world.camera.x - SCREEN_WIDTH/2), -(Game.world.camera.y - SCREEN_HEIGHT/2))

        local tilex = math.floor(self.x / cyltower.tile_width_fine) + 1
        if tilex >= cyltower.horizontaltilecount then
            tilex = tilex - cyltower.horizontaltilecount
        end
        if tilex <= 0 then
            tilex = tilex + cyltower.horizontaltilecount
        end
        local tile = cyltower.tile_data[cyltower.tm_tileset[1]][tilex]
        if tile.vis == 1 then
            Draw.setColor(tile.color)
            Draw.draw(self.sprite:getTexture(), cyltower.tower_x + tile.x, self.y + (cyltower.tile_height_fine / 4), 0, ((tile.xscale * 2) / cyltower.tile_width_fine), 2, 2, 2)
        end

        love.graphics.pop()
    else
        super.draw(self)
    end
end

return FallingClimbArea