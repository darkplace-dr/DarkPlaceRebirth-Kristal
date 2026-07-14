local Gtt, super = Class(Wave)

function Gtt:init()
    super.init(self)
    
    self.time = 11
    
    self:addChild(SpearRedChecker())
end

function Gtt:onStart()
    -- spawn transition bullet
    -- note: I didn't even know tuples existed in lua???
    -- Isn't everything being a table, like the main point in the first fucking place???
    -- why not add actual objects/classes or actual fucking arrays while we're at it?
    local attacker = self:getAttackers()[1]
    local ax, ay = attacker:getRelativePos(0, attacker.height/2)
    local arx, ary = Game.battle.arena:getCenter()
    local aangle = Utils.angle(ax, ay, arx, ary)
    
    -- force a slightly easier pattern on the first turn
    local is_first_turn = Game.battle.turn_count <= 1
    
    local bullet_no = 0
    local gtarrow = nil -- pre-declare gtarrow so we can access it in the callback
    gtarrow = self:spawnBullet("togreen_arrow", ax, ay, aangle, function()
        self.timer:every(1/2, function()
            if self.finished then
                gtarrow.remove_offscreen = true -- should be offscreen by now
                return false
            end
            
            local DIST = (SCREEN_WIDTH/2)+32
            local angle_step = math.rad(45)
            local num_angles = 8
            local speed = 12
            
            bullet_no = bullet_no + 1
            if is_first_turn then
                if bullet_no <= 10 then -- first few are cardinal, and slow
                    angle_step = math.rad(90)
                    num_angles = 4
                    speed = speed/2
                else -- ease into faster bullets
                    speed = Utils.ease(speed/2,speed,(bullet_no-10)/11,"in-quad")
                end
                if bullet_no > 10 and not Game.battle.soul.diagonal then
                    -- enable diagonal mode
                    Game.battle.soul:setDiagonal(true)
                end
            end
            
            local angle = math.random(0, num_angles-1)*angle_step
            if is_first_turn then
                if bullet_no <= 3 then
                    angle = math.rad(-90) -- first three are from the top
                elseif bullet_no == 9 then
                    angle = math.rad(45) -- force a diagonal one just before we switch to diagonal
                    DIST = DIST+32
                end
            end
            
            local bullet = self:spawnBullet("gerson_spear", angle, DIST, speed)
            
            -- set a custom variable to mark this bullet as special
            bullet.keep_wave_alive = true
            -- Don't remove the bullet offscreen, because we spawn it offscreen
            bullet.remove_offscreen = false
            self.timer:after(1, function()
                bullet.remove_offscreen = true
            end)
        end)
    end)
    gtarrow.new_soul:setDiagonal(not is_first_turn) -- start in cardinal mode instead of diagonal if on the first turn
end
function Gtt:canEnd() -- wait for our bullets to end
    for _,bullet in ipairs(self.bullets) do
        if bullet.keep_wave_alive and bullet:isFullyActive() then -- still active, so don't end
            return false
        end
    end
    return true
end

function Gtt:update()
    -- Code here gets called every frame

    super.update(self)
end

return Gtt