local Rtt, super = Class(Wave)

function Rtt:init()
    super.init(self)
    
    self.time = 10
    
    -- move arena down to mimic gerson fight
    self:setArenaOffset(0, 71)
    -- we use spears, so we need a red checker
    self:addChild(SpearRedChecker())
end

function Rtt:onStart()
    -- send spears
    local SPEAR_DIST = (SCREEN_WIDTH/2) +32
    local SPEAR_SPEED = 12
    local speardir = 0
    local spear_count = 0
    local sendspears = true
    local lastspear = nil
    self.timer:every(1/3, function()
        if not sendspears then
            return false
        end
        spear_count = spear_count + 1
        
        if math.random() < 0.5 then
            speardir = speardir + math.rad(180)
        end
        
        local bullet = self:spawnBullet("gerson_spear", speardir, SPEAR_DIST, SPEAR_SPEED)
        bullet.remove_offscreen = false
        
        lastspear = bullet
    end)
    
    -- send slow hammer from above
    local hammer = nil
    hammer = self:spawnBullet("tored_hammer_slow", math.rad(-90), Game.battle.arena.y + 32, nil, 125, function()
        sendspears = false
        -- wait until all spears are gone
        self.timer:every(1/30, function()
            if lastspear == nil or not lastspear:isFullyActive() then
                -- spawn bullets at side of arena shortly before the hammer hits
                local side_bullets = {}
                local _,cy = Game.battle.arena:getCenter()
                for y=cy, Game.battle.arena.bottom, 16 do
                    local bullL = self:spawnBullet("smallbullet", Game.battle.arena.left  - 16, y, math.rad(0  ), 0)
                    table.insert(side_bullets, bullL)
                    local bullR = self:spawnBullet("smallbullet", Game.battle.arena.right + 16, y, math.rad(180), 0)
                    table.insert(side_bullets, bullR)
                end
                -- tween in the side bullets
                for _,bull in ipairs(side_bullets) do
                    bull.alpha = 0
                    self.timer:tween(20/30, bull, {alpha = 1}, "out-quad")
                end
                
                -- throw hammer
                hammer:throw()
                hammer.soul_change_callback = function()
                    -- callback after soul change.
                    
                    -- fire side bullets when ready
                    self.timer:after(10/30, function()
                        for _,bull in ipairs(side_bullets) do
                            bull.physics.speed = 6
                        end
                    end)
                    
                    -- second half of the pattern
                    self.timer:after(1.5, function()
                        self.finished = true
                    end)
                end
                
                return false
            end
        end)
    end)
end

function Rtt:update()
    -- Code here gets called every frame

    super.update(self)
end

return Rtt