local OverworldActionBox, super = HookSystem.hookScript(OverworldActionBox)

function OverworldActionBox:draw() -- Fixes an issue with HP higher than normal
    if #Game.party > 3 then
        super.draw(self)
        return
    end

    -- Draw the line at the top
    if self.selected then
        Draw.setColor(self.chara:getColor())
    else
        Draw.setColor(PALETTE["action_strip"])
    end

    love.graphics.setLineWidth(2)
    love.graphics.line(0, 1, 213, 1)

    if Game:getConfig("oldUIPositions") then
        love.graphics.line(0, 2, 2, 2)
        love.graphics.line(211, 2, 213, 2)
    end

    -- Draw health
    Draw.setColor(PALETTE["action_health_bg"])
    love.graphics.rectangle("fill", 128, 24, 76, 9)

    local health = (self.chara:getHealth() / self.chara:getStat("health")) * 76

    if health > 0 then
        Draw.setColor(self.chara:getColor())
        love.graphics.rectangle("fill", 128, 24, math.min(math.ceil(health), 76), 9)
    end

    local color = PALETTE["action_health_text"]
    if health <= 0 then
        color = PALETTE["action_health_text_down"]
    elseif (self.chara:getHealth() <= (self.chara:getStat("health") / 4)) then
        color = PALETTE["action_health_text_low"]
    else
        color = PALETTE["action_health_text"]
    end

    local health_offset = 0
    health_offset = (#tostring(self.chara:getHealth()) - 1) * 8

    Draw.setColor(color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.chara:getHealth(), 152 - health_offset, 11)
    Draw.setColor(PALETTE["action_health_text"])
    love.graphics.print("/", 161, 11)
    local string_width = self.font:getWidth(tostring(self.chara:getStat("health")))
    Draw.setColor(color)
    love.graphics.print(self.chara:getStat("health"), 205 - string_width, 11)

    -- Draw name text if there's no sprite
    if not self.name_sprite then
        local font = Assets.getFont("name")
        love.graphics.setFont(font)
        Draw.setColor(1, 1, 1, 1)

        local name = self.chara:getName():upper()
        local spacing = 5 - StringUtils.len(name)

        local off = 0
        for i = 1, StringUtils.len(name) do
            local letter = StringUtils.sub(name, i, i)
            love.graphics.print(letter, 51 + off, 16 - 1)
            off = off + font:getWidth(letter) + spacing
        end
    end

    local reaction_x = -1

    if self.x == 0 then -- lazy check for leftmost party member
        reaction_x = 3
    end

    love.graphics.setFont(self.main_font)
    Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
    love.graphics.print(self.reaction_text, reaction_x, 43, 0, 0.5, 0.5)

    Object.draw(self)
end

return OverworldActionBox