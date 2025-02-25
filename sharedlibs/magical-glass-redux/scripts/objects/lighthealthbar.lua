local LightHealthBar, super = Class(Object, "LightHealthBar")

function LightHealthBar:init()
    super.init(self, 0, 415)

    self:setParallax(0, 0)
    
    self.animation_done = false
    self.animation_timer = 0
    self.animate_out = false
    self.animation_y = -70
    
    local x = 237
    local width = 167
    if #Game.party == 2 then
        x = 119
        width = 403
    elseif #Game.party == 3 then
        x = 41
        width = 559
    end
    self.box = UIBox(x, 19, width, 4)
    self.box.layer = -1
    self:addChild(self.box)
    
    self.auto_hide_timer = 0
end

function LightHealthBar:draw()
    super.draw(self)
    
    for index,party in ipairs(Game.party) do
        local x, y = 31 + (3 - #Game.party - (#Game.party == 2 and 0.2 or 0)) * 98 + (index - 1) * 98 * 2 * (#Game.party == 2 and (1 + 0.2) or 1), 10
        
        local name = party:getShortName()
        
        local current = party:getHealth()
        local max = party:getStat("health")
        
        love.graphics.setFont(Assets.getFont("namelv", 24))
        love.graphics.setColor(PALETTE["world_text"])
        love.graphics.print(name, x, y)
        
        local small = false
        for _,target in ipairs(Game.party) do
            if target:getStat("health") >= 100 then
                small = true
            end
        end
        
        love.graphics.setColor(MG_PALETTE["player_health_bg"])
        love.graphics.rectangle("fill", x + 92, y, (small and 20 or 32) * 1.2 + 1, 21)
        if current > 0 then
            love.graphics.setColor(MG_PALETTE["player_health"])
            love.graphics.rectangle("fill", x + 92, y, math.ceil((Utils.clamp(current, 0, max) / max) * (small and 20 or 32)) * 1.2 + 1, 21)
        end
        
        love.graphics.setFont(Assets.getFont("namelv", 16))
        if max < 10 and max >= 0 then
            max = "0" .. tostring(max)
        end

        if current < 10 and current >= 0 then
            current = "0" .. tostring(current)
        end
        
        love.graphics.setColor(PALETTE["world_text"])
        Draw.printAlign(current .. "/" .. max, x + 189, y + 3, "right")
    end
end

function LightHealthBar:transitionIn()
    if self.animate_out then
        self.animate_out = false
        self.animation_timer = 0
        self.animation_done = false
    end
end

function LightHealthBar:transitionOut()
    if not self.animate_out then
        self.animate_out = true
        self.animation_timer = 0
        self.animation_done = false
    end
end

function LightHealthBar:update()
    self.animation_timer = self.animation_timer + DTMULT
    self.auto_hide_timer = self.auto_hide_timer + DTMULT
    
    -- Game.world.menu -- If we're in an overworld battle, or the menu is open, we don't want the health bar to disappear
    if Game.world:inBattle() then
        -- If we're in an overworld battle, we don't want the health bar to disappear
        self.auto_hide_timer = 0
    end

    if self.auto_hide_timer > 60 then -- After two seconds outside of a battle, we hide the health bar
        self:transitionOut()
    end

    local max_time = self.animate_out and 3 or 8

    if self.animation_timer > max_time + 1 then
        self.animation_done = true
        self.animation_timer = max_time + 1
        if self.animate_out then
            Game.world.healthbar = nil
            self:remove()
            return
        end
    end

    if not self.animate_out then
        if self.animation_y < 0 then
            if self.animation_y > -47 then
                self.animation_y = self.animation_y + math.ceil(-self.animation_y / 2.5) * DTMULT
            else
                self.animation_y = self.animation_y + 30 * DTMULT
            end
        else
            self.animation_y = 0
        end
    else
        if self.animation_y > -70 then
            if self.animation_y > 0 then
                self.animation_y = self.animation_y - math.floor(self.animation_y / 2.5) * DTMULT
            else
                self.animation_y = self.animation_y - 30 * DTMULT
            end
        else
            self.animation_y = -70
        end
    end

    self.y = 480 - (self.animation_y + 65)

    super.update(self)
end

return LightHealthBar