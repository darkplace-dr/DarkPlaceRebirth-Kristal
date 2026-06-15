local BattleBackground, super = HookSystem.hookScript(BattleBackground)

function BattleBackground:init()
    super.init(self)
    
    if not Game:isLight() then
        self.background_color = {66 / 255, 0, 66 / 255}
    else
        self.background_color = {0, 66 / 255, 0}
    end
end

function BattleBackground:drawBackground()
    -- Draw the black background
    Draw.setColor(0, 0, 0, self.alpha)
    love.graphics.rectangle("fill", -10, -10, SCREEN_WIDTH + 20, SCREEN_HEIGHT + 20)

    -- Draw the background grid
    local background = Assets.getTexture("ui/battle/background")

    local r, g, b = TableUtils.unpack(self.background_color)
    
    Draw.setColor(r, g, b, self.alpha / 2)
    Draw.drawWrapped(background, true, true, MathUtils.round(-100 + self.position), MathUtils.round(-100 + self.position))
    Draw.setColor(r, g, b, self.alpha)
    Draw.drawWrapped(background, true, true, MathUtils.round(-200 - self.position2), MathUtils.round(-210 - self.position2))
end

return BattleBackground