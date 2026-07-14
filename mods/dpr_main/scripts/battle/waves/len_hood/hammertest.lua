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
    -- send ten spears, then the hammer
    local SPEAR_DIST = (SCREEN_WIDTH/2) +32
    local SPEAR_SPEED = 12
    local speardir = 0
    local spear_count = 0
    self.timer:every(1/3, function()
        if spear_count >= 10 then
            -- spawn bullets at side of arena shortly before the hammer hits
            local side_bullets = {}
            local spawn_t = ((SPEAR_DIST*1.5)/(SPEAR_SPEED*1.5)/30) - (10/30)
            self.timer:after(spawn_t, function()
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
            end)
            
            -- hammer from above
            self:spawnBullet("tored_hammer", math.rad(-90), SPEAR_DIST*1.5, SPEAR_SPEED*1.5, function()
                -- callback after soul change.
                
                -- fire side bullets when ready
                self.timer:after(10/30, function()
                    for _,bull in ipairs(side_bullets) do
                        bull.physics.speed = 6
                    end
                end)
                
                -- second half of the pattern
                local n = 0
                self.timer:every(10/30, function()
                    n = n + 1
                    if n%3 == 0 then -- skip every 3rd shot
                        return
                    end
                    
                    local side_bullets = {}
                    local side = n%2 == 0
                    
                    local VOLLEY_SIZE = 3 + math.floor(n/6)
                    local a1 = nil
                    local a2 = nil
                    local b = nil
                    local d1 = nil
                    local d2 = nil
                    if side then
                        b = Utils.random(Game.battle.arena.top, Game.battle.arena.bottom - (16*(VOLLEY_SIZE-1)))
                        a1 = Game.battle.arena.left - 16
                        d1 = math.rad(0)
                        a2 = Game.battle.arena.right + 16
                        d2 = math.rad(180)
                    else
                        b = Utils.random(Game.battle.arena.left, Game.battle.arena.right - (16*(VOLLEY_SIZE-1)))
                        a1 = Game.battle.arena.top - 16
                        d1 = math.rad(90)
                        a2 = Game.battle.arena.bottom + 16
                        d2 = math.rad(-90)
                    end
                    
                    for i=1,VOLLEY_SIZE do
                        local x1 = nil
                        local y1 = nil
                        local x2 = nil
                        local y2 = nil
                        if side then
                            y1 = b + 16*(i-1)
                            y2 = b + 16*(i-1)
                            x1 = a1
                            x2 = a2
                        else
                            x1 = b + 16*(i-1)
                            x2 = b + 16*(i-1)
                            y1 = a1
                            y2 = a2
                        end
                        
                        table.insert(side_bullets,self:spawnBullet("smallbullet", x1, y1, d1, 0))
                        table.insert(side_bullets,self:spawnBullet("smallbullet", x2, y2, d2, 0))
                    end
                    
                    for _,bull in ipairs(side_bullets) do
                        bull.alpha = 0
                        self.timer:tween(20/30, bull, {alpha = 1}, "out-quad")
                    end
                    self.timer:after(20/30, function()
                        for _,bull in ipairs(side_bullets) do
                            bull.physics.speed = 6
                        end
                    end)
                end)
                
                -- -- second half of the pattern
                -- local attackers = self:getAttackers()
                -- self.timer:every(1/4, function()
                --     if self.finished then
                --         return false
                --     end
                --     for _, attacker in ipairs(attackers) do
                --         local x, y = attacker:getRelativePos(attacker.width/2, Utils.random(0,attacker.height))
                --         local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
                --         self:spawnBullet("smallbullet", x, y, angle, 8)
                --     end
                -- end)
            end)
            
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
end

function Rtt:update()
    -- Code here gets called every frame

    super.update(self)
end

return Rtt