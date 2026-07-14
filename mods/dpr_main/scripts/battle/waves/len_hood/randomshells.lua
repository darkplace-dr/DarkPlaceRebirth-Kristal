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
    
    self.timer:script(function(wait)
        local nshells = math.random(2,3)
        for i=1,nshells do
            local angle_step = math.rad(45)
            local num_angles = 8
            if not Game.battle.soul.diagonal then
                angle_step = math.rad(90)
                num_angles = 4
            end
            
            local angle = math.random(0, num_angles-1)*angle_step
            local hp = math.random(2,5)
            local shell = self:spawnBullet("gerson_shell", angle, DIST, hp)
            
            local size = shell.SIZE_NORMAL
            if math.random() < 0.2 then
                size = shell.SIZE_LARGE
            --elseif math.random() < 0.5 then
            --    shell.hp = 100
            --    size = shell.SIZE_LARGE
            end
            shell:setSize(size)
            
            shell.remove_offscreen = false
            
            wait(shell:getReboundDuration()/nshells) -- wait
            if large then
                wait(shell:getReboundDuration()/nshells) -- wait extra for large shells
            end
        end
        
        -- done spawning shells
        self.finished = true
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