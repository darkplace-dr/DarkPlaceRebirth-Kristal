local LightArenaSprite, super = Class(ArenaSprite)

function LightArenaSprite:init(arena, x, y)
    super.init(self, arena, x, y)
    
    self.outline = true
end

function LightArenaSprite:draw()
    if self.background then
        Draw.setColor(self.arena:getBackgroundColor())
        self:drawBackground()
    end

    Object.draw(self)

    if self.outline then
        local r, g, b, a = self:getDrawColor()
        local arena_r,arena_g,arena_b,arena_a = self.arena:getDrawColor()

        Draw.setColor(r * arena_r, g * arena_g, b * arena_b, a * arena_a)
        love.graphics.setLineStyle("rough")
        love.graphics.setLineWidth(self.arena.line_width)
        love.graphics.line(TableUtils.unpack(self.arena.border_line))
    end
end

return LightArenaSprite