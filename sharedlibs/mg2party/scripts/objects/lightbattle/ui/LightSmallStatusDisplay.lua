local LightSmallStatusDisplay, super = Class(Object, "LightSmallStatusDisplay")

function LightSmallStatusDisplay:init(x, y, battler, width)
    super.init(self, x, y, width or 180, 24)

    ---@type PartyBattler
    self.battler = battler
    self:setOrigin(.5,1)

    self.font = Assets.getFont("namelv", 16)
    self.hp_texture = Assets.getTexture("ui/lightbattle/hp")
    self.tp_texture = Assets.getTexture("ui/lightbattle/tp")

    -- "ALWAYS", "NEVER", "BATTLE"
    self.draw_tension = "BATTLE"
    self.selected = false

    -- self.debug_rect = {0, 0, SCREEN_WIDTH + 10, 24}
end

function LightSmallStatusDisplay:draw()
    love.graphics.push()
    Draw.setColor(COLORS.black)
    love.graphics.rectangle("fill", 0,0,self.width,self.height)
    love.graphics.setLineWidth(self.selected and 5 or 2)
    Draw.setColor(self.battler.chara.color)
    love.graphics.rectangle("line", 0,0,self.width,self.height)
    self:drawStatus()
    love.graphics.pop()

    super.draw(self)
end

function LightSmallStatusDisplay:drawStatus()
    self:drawHP(self.width, 5, 13)
    self:drawNameAndLV(6, 5)
end

function LightSmallStatusDisplay:drawNameAndLV(x, y)
    local name = self:getName()

    local level = Game:isLight() and self.battler.chara:getLightLV() or self.battler.chara:getLevel()
    love.graphics.setFont(self.font)
    Draw.setColor(COLORS.white)
    if Game.battle:hasAction(self.battler) then
        Draw.setColor(COLORS.yellow)
    end
    love.graphics.print(name, x, y)
    Draw.setColor(COLORS.black(.4))
    Draw.printAlign("LV"..level, x+self.font:getWidth(name)+5,y)
end

function LightSmallStatusDisplay:getName()
    local level = Game:isLight() and self.battler.chara:getLightLV() or self.battler.chara:getLevel()
    return self.battler.chara:getName()
end

function LightSmallStatusDisplay:drawHP(x, y, height)
    local current_health = self.battler.chara:getHealth()
    local max_health = self.battler.chara:getStat("health")


    love.graphics.setFont(self.font)
    local color = COLORS.white
    if not self.battler.is_down then
        if Game.battle:hasAction(self.battler) and Game.battle:getActionBy(self.battler).action == "DEFEND" then
            color = MagicalGlass.PALETTE["player_status_defend"]
        end
    else
        color = MagicalGlass.PALETTE["player_status_down"]
    end

    Draw.setColor(color)
    local health_txt = current_health .. "/" .. max_health
    Draw.printAlign(health_txt, (x) - 5, y, "right")

    Draw.setColor(COLORS.white)

    local max_width = (self.width - (self.font:getWidth(health_txt) + self.font:getWidth(self:getName())))
    max_width = max_width - 20
    local current_width = max_width
    current_width = current_width * (current_health / max_health)

    local right_x = x - self.font:getWidth(health_txt)
    right_x = right_x - 10
    Draw.setColor(MagicalGlass.PALETTE["player_health_back"])
    Draw.rectangle("fill", right_x, y, -max_width, height)
    if current_health > 0 then
        Draw.setColor(MagicalGlass.PALETTE["player_health"])
        Draw.rectangle("fill", right_x-max_width, y, current_width, height)
    end

    if max_health < 10 and max_health >= 0 then
        max_health = "0" .. tostring(max_health)
    end

    if current_health < 10 and current_health >= 0 then
        current_health = "0" .. tostring(current_health)
    end


end

function LightSmallStatusDisplay:drawTP()
    local x, y = 500, 0

    Draw.setColor(COLORS.white)
    Draw.draw(self.tp_texture, x, y + 5)

    if Game:getTension() < Game:getMaxTension() then
        local tp = math.floor(Game:getTension())

        if Game:getTension() < 10 then
            tp = "0" .. tp
        end

        if Game:getTension() > 0 then
            Draw.setColor(MagicalGlass.PALETTE["tension_fill"])
        else
            Draw.setColor(MagicalGlass.PALETTE["tension_back"])
        end
        love.graphics.print(tp, x + 32, y)
        Draw.setColor(COLORS.white)
        love.graphics.print("%", x + 64, y)
    else
        Draw.setColor(MagicalGlass.PALETTE["tension_maxtext"])
        love.graphics.print("MAX", x + 32, y)
    end
end

return LightSmallStatusDisplay