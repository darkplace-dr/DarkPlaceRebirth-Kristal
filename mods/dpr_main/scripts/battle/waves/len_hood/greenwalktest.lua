local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)
    
    self.time = 5
    
    self:addChild(SpearRedChecker())
end

function Basic:onStart()
    local DIST = (SCREEN_WIDTH/2)+32
    local angle = math.rad(90)
    local direction = 1
    if math.random() < 0.5 then
        direction = -direction
    end
    
    local num_attackers = 0
    local num_tired = 0
    for _, attacker in ipairs(self:getAttackers()) do
        num_attackers = num_attackers + 1
        if attacker.tired then
            num_tired = num_tired + 1
        end
    end
    if num_attackers == 0 then -- avoid division by zero
        num_attackers = 1
    end
    local speed_multiplier = 1 - ((num_tired / num_attackers)*0.25) -- make bullets .75 speed when enemies are tired
    local delay_multiplier = 1 + ((num_tired / num_attackers)*0.5) -- increase delay by 50% when enemies are tired
    
    self.timer:script(function(wait)
        while not self.finished do
            local angle_step = math.rad(45)
            if not Game.battle.soul.diagonal then
                angle_step = math.rad(90)
            end
            
            -- switch directions
            local switch_chance = 0.2 -- 20% (8way)
            if not Game.battle.soul.diagonal then -- 40% (4way)
                switch_chance = 0.4
            end
            if math.random() < switch_chance then
                direction = -direction
            end
            
            -- double-step
            local double_step_chance = 0.2 -- 20% (diagonals and/or 4way)
            if Game.battle.soul.diagonal and math.abs(angle%math.rad(90)) < math.rad(5) then
                double_step_chance = 0.5 -- 50% (cardinals in 8way)
            end
            if math.random() < double_step_chance then
                angle_step = angle_step * 2
            end
            
            -- do the maths
            angle = angle + (direction*angle_step)
            
            local bullet = self:spawnBullet("gerson_spear", angle, DIST, 12 * speed_multiplier)

            -- Don't remove the bullet offscreen, because we spawn it offscreen
            bullet.remove_offscreen = false
            self.timer:after(1, function()
                bullet.remove_offscreen = true
            end)
            
            -- and then wait a short time
            wait((4/10) * delay_multiplier)
        end
    end)
end

function Basic:canEnd()
    for _,bullet in ipairs(self.bullets) do
        if bullet:isFullyActive() then -- still active, so don't end
            return false
        end
    end
    return true
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic