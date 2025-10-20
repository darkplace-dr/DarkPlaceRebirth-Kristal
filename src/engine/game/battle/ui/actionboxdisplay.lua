---@class ActionBoxDisplay : Object
---@overload fun(...) : ActionBoxDisplay
local ActionBoxDisplay, super = Class(Object)

function ActionBoxDisplay:init(actbox, x, y)
    super.init(self, x, y)

    self.font = Assets.getFont("smallnumbers")

    self.actbox = actbox
end

function ActionBoxDisplay:draw()
    if Game.battle.current_selecting == self.actbox.index then
        Draw.setColor(self.actbox.battler.chara:getColor())
    else
        Draw.setColor(PALETTE["action_strip"], 1)
    end

    love.graphics.setLineWidth(2)
    love.graphics.line(0  , Game:getConfig("oldUIPositions") and 2 or 1, 213, Game:getConfig("oldUIPositions") and 2 or 1)

    love.graphics.setLineWidth(2)
    if Game.battle.current_selecting == self.actbox.index then
        love.graphics.line(1  , 2, 1,   36)
        love.graphics.line(212, 2, 212, 36)
    end

    Draw.setColor(PALETTE["action_fill"])
    love.graphics.rectangle("fill", 2, Game:getConfig("oldUIPositions") and 3 or 2, 209, Game:getConfig("oldUIPositions") and 34 or 35)
    
    local mhp_perc = (self.actbox.battler.chara:getStat("health") / self.actbox.battler.chara:getStat("health_def")) or 1
    local health = (self.actbox.battler.chara:getHealth() / self.actbox.battler.chara:getStat("health")) * (mhp_perc * 76)
   
    Draw.setColor(COLORS.dkgray)
    love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, 76, 9)
 
    if mhp_perc > 0 then
        Draw.setColor(self.actbox.battler.chara.health_bg_color or PALETTE["action_health_bg"])
        love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.ceil(mhp_perc * 76), 9)

        if health > 0 then
            Draw.setColor(self.actbox.battler.chara:getColor())
            love.graphics.rectangle("fill", 128, 22 - self.actbox.data_offset, math.ceil(health), 9)
        end
        
        Draw.setColor(self.actbox.battler.chara.shield_color or {128/255, 128/255, 128/255})
        love.graphics.rectangle("fill", 128, 27 - self.actbox.data_offset, math.ceil((self.actbox.battler.shield / self.actbox.battler.chara:getMaxShield()) * 76), 4)
    end
    local color = PALETTE["action_health_text"]
    if health <= 0 then
        color = PALETTE["action_health_text_down"]
    elseif (self.actbox.battler.chara:getHealth() <= (self.actbox.battler.chara:getStat("health") / 4))
    or (self.actbox.battler.chara:getStat("health") <= (self.actbox.battler.chara:getStat("health_def") / 4)) then
        color = PALETTE["action_health_text_low"]
    else
        color = PALETTE["action_health_text"]
    end


    local health_offset = 0
    health_offset = (#tostring(self.actbox.battler.chara:getHealth()) - 1) * 8

    Draw.setColor(color)
    love.graphics.setFont(self.font)
    if mhp_perc <= 0 then
        health_offset = 6 * 8
        Draw.setColor(PALETTE["action_health_text_down"])
        love.graphics.print("faLLEn", 205 - health_offset, 9 - self.actbox.data_offset)
    else
        love.graphics.print(self.actbox.battler.chara:getHealth(), 152 - health_offset, 9 - self.actbox.data_offset)
        Draw.setColor(PALETTE["action_health_text"])
        love.graphics.print("/", 161, 9 - self.actbox.data_offset)
        local string_width = self.font:getWidth(tostring(self.actbox.battler.chara:getStat("health")))
        Draw.setColor(color)
        love.graphics.print(self.actbox.battler.chara:getStat("health"), 205 - string_width, 9 - self.actbox.data_offset)
    end
    super.draw(self)
end

return ActionBoxDisplay