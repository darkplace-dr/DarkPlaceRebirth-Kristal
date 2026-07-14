local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)
    
    self.time = 6
    
    self:addChild(SpearRedChecker())
end

function Basic:onStart()
    local battlers = Game.battle:getBattlers()
    self.oldbattlershealth = {}
    for key,battler in pairs(battlers) do
        local chara = battler.chara
        if chara then
            local health = chara.health
            self.oldbattlershealth[key] = health
        end
    end

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
    local speed_multiplier = 1.5 - ((num_tired / num_attackers)*0.5) -- make bullets half speed when enemies are tired
    local delay_multiplier = 0.8 + ((num_tired / num_attackers)*0.5) -- increase delay by 50% when enemies are tired
    
    self.timer:script(function(wait)
        while not self.finished do
            local angle_step = math.rad(45)
            local num_angles = 8
            if not Game.battle.soul.diagonal then
                angle_step = math.rad(90)
                num_angles = 4
            end
            
            if math.random()<0.2 then -- re-use previous angle
                angle = prev_angle
            else -- wait a moment then pick new angle
                wait(1/5)
                angle = math.random(0, num_angles-1)*angle_step
                
                -- wait a little extra if new angle is a diagonal that isn't adjacent to the previous angle
                local epsilon = math.rad(5)
                if math.abs(angle%math.rad(90)) > epsilon and math.abs(prev_angle - angle) > math.rad(45) + epsilon then
                    wait(2/5)
                end
                
                -- all good
                prev_angle = angle
            end
            
            local bullet = self:spawnBullet("gerson_spear", angle, DIST, 12 * speed_multiplier)

            -- Don't remove the bullet offscreen, because we spawn it offscreen
            bullet.remove_offscreen = false
            self.timer:after(1, function()
                bullet.remove_offscreen = true
            end)
            
            -- and then wait a short time
            wait((1/10) * delay_multiplier)
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

function Basic:onEnd(death)
    if death then return end
    local battlers = Game.battle:getBattlers()
    for key,battler in pairs(battlers) do
        local chara = battler.chara
        if chara then
            local old_hp = self.oldbattlershealth[key]
            local health = chara.health
            if health < old_hp then
                return
            end
        end
    end

    Assets.playSound("crowd_cheer_single")
end

return Basic