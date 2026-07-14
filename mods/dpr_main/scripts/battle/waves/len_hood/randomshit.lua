local RandomBullshitGo, super = Class(Wave)

function RandomBullshitGo:init()
    super.init(self)
    
    self.time = 5
    
    self:addChild(SpearRedChecker())
end

function RandomBullshitGo:onStart()
    local DIST = (SCREEN_WIDTH/2)+32
    local prev_angle = math.rad(90)
    local keep_spawning = true
    
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
    local speed_multiplier = 1 - ((num_tired / num_attackers)*0.5) -- make bullets half speed when enemies are tired
    local delay_multiplier = 1 + ((num_tired / num_attackers)*0.5) -- increase delay by 50% when enemies are tired
    
    self.timer:script(function(wait)
        while not self.finished do
            local angle_step = math.rad(45)
            local num_angles = 8
            if not Game.battle.soul.diagonal then
                angle_step = math.rad(90)
                num_angles = 4
            end
            
            local angle = math.random(0, num_angles-1)*angle_step
            local speed = math.random(4,8)
            if math.random() < 0.25 then -- donut
                local bull = PolarBullet(angle, DIST, "bullets/smallbullet")
                bull.physics.speed = speed
                self:spawnBullet(bull)
            else -- normal spear
                local bull = self:spawnBullet("gerson_spear", angle, DIST, speed)
            end
            
            wait(1/math.random(3,6)) -- wait
        end
    end)
end

function RandomBullshitGo:canEnd()
    for _,bullet in ipairs(self.bullets) do
        if bullet:isFullyActive() then -- still active, so don't end
            return false
        end
    end
    return true
end

function RandomBullshitGo:update()
    -- Code here gets called every frame

    super.update(self)
end

return RandomBullshitGo