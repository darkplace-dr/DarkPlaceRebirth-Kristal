local Final, super = Class(Wave)

function Final:init()
    super.init(self)
    
    self.time = 5
    
    -- move arena down to mimic gerson fight
    self:setArenaOffset(0, 71)
    -- we use spears, so we need a red checker
    self:addChild(SpearRedChecker())
end

function Final:onStart()
    self.hood = Game.battle:getEnemyBattler("len_hood")
    -- send spears
    local SPEAR_DIST = (SCREEN_WIDTH/2) +32
    self.spear_speed = 12
    local speardir = 0
    local spear_count = 0
    local sendspears = true
    local lastspear = nil
    self.part_3_finished = false
    self.timer:every(1/3, function()
        if not sendspears or self.part_3_finished then
            return false
        end
        spear_count = spear_count + 1
        
        if math.random() < 0.5 then
            speardir = speardir + math.rad(180)
        end
        
        local bullet = self:spawnBullet("gerson_spear", speardir, SPEAR_DIST, self.spear_speed)
        bullet.remove_offscreen = false
        
        lastspear = bullet
    end)

    local arena = Game.battle.arena
    
    -- send slow hammer from above
    if not self.part_3_finished then
        self:spawnBullet("tored_hammer_slow", math.rad(-90), Game.battle.arena.y + 44, nil, 122, function(hammer)
            self.timer:tween(0.2, hammer, {scale_x = hammer.scale_x + 3})
            self.timer:tween(0.2, hammer, {scale_y = hammer.scale_y + 3})
            sendspears = false
            -- wait until all spears are gone
            self.timer:every(1/30, function()
                if self.part_3_finished then return end
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

                        local t = 0.7
                        local s = 46
                        self.timer:tween(t, arena, {y = arena.y - 35})
                        
                        -- fire side bullets when ready
                        self.timer:after(10/30, function()
                            for _,bull in ipairs(side_bullets) do
                                bull.physics.speed = 6
                            end
                        end)
                        
                        -- second half of the pattern
                        self.timer:after(0.2, function()
                            self.spear_speed = self.spear_speed - 8
                            self.timer:tween(t, arena, {
                                width = s,
                                height = s * 3.5
                        })
                            sendspears = true
                            self.timer:every(1/3, function()
                                if sendspears then
                                    if math.random() < 0.5 then
                                        speardir = speardir + math.rad(180)
                                    end
                                    
                                    local bullet = self:spawnBullet("gerson_spear", speardir, SPEAR_DIST, 14)
                                    bullet.y = Game.battle.soul.y
                                    bullet.remove_offscreen = false
                                end
                            end)

                            self.timer:after(1, function()
                                Assets.playSound("wing")
                                self.hood:setAnimation("battle/attackready")
                                local sendhammers = true
                                ---@type Bullet[]
                                local hammers = {}
                                local times_trown = 0
                                local max_trown_times = 3
                                local last_hammer
                                local throw_speed = 0.4
                                self.timer:every(throw_speed, function()
                                    if self.part_3_finished then return end
                                    if sendhammers then
                                        -- Get the attacker's center position
                                        local x, y = self.hood:getRelativePos(self.hood.width/2, self.hood.height/2)

                                        -- Get the angle between the bullet position and the soul's position
                                        local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
                                        
                                        if times_trown <= max_trown_times then
                                            hammer = self:spawnBullet("tored_hammer_slow", angle, Game.battle.soul.y + 44, nil, 225)
                                            if times_trown > max_trown_times then
                                                hammer.dont_create_after_images = true
                                            end
                                            table.insert(hammers, hammer)
                                            Assets.playSound("scytheburst")
                                            self.hood:setAnimation("battle/attack")
                                        end
                                        if times_trown > max_trown_times then
                                            Assets.playSound("explosion")
                                            for i,hammer in ipairs(hammers) do
                                                self.timer:after(0.02 * i, function()
                                                    hammer:explode(nil, nil, nil, {play_sound = false})
                                                end)
                                            end
                                            
                                            
                                            throw_speed = 0.3
                                            self.part_3_finished = true
                                            local center_x, center_y = arena:getCenter()
                                            self.timer:tween(0.3, self.hood, {
                                                x = arena:getRight() + 40,
                                                y = center_y
                                            })
                                            self.timer:after(0.3, function()
                                                self.hood:setAnimation("battle/attack")
                                                arena:shake(16, 4)
                                                Assets.playSound("smash_homerun")
                                                self.timer:after(0.5, function()
                                                    arena.width = SCREEN_WIDTH
                                                    arena.height = SCREEN_HEIGHT
                                                    arena.alpha = 0
                                                    self.timer:tween(0.4, arena, {alpha = 0})
                                                    arena:explode(nil, nil, true, {play_sound = false})
                                                    Assets.playSound("explosion")
                                                end)
                                            end)
                                        end
                                    end
                                end)

                                self.timer:every(3, function()
                                    if self.part_3_finished then return end
                                    if times_trown < max_trown_times then
                                        sendspears = false
                                        sendhammers = false
                                    end
                                    Assets.playSound("wing")
                                    self.timer:after(0.4, function()
                                        times_trown = times_trown + 1
                                        for i,hammer in ipairs(hammers) do
                                            self.timer:after(0.05 * i, function()
                                                hammer:throw()
                                                self.timer:after(2, function()
                                                    if hammer ~= last_hammer then
                                                        hammer:remove()
                                                    end
                                                end)
                                            end)
                                        end
                                        Assets.playSound("scytheburst")
                                        self.hood:setAnimation("battle/attack")
                                        self.timer:after(0.8, function()
                                            sendhammers = true
                                            if times_trown < max_trown_times then
                                                self.timer:after(0.3, function()
                                                    sendspears = true
                                                end)
                                            end
                                        end)
                                    end)
                                end)
                            end)
                        end)
                    end
                    
                    return false
                end
            end)
        end)
    else
        Game.battle:swapSoul(Soul())
        arena:explode()
        arena.width = SCREEN_WIDTH
        arena.height = SCREEN_HEIGHT
    end
    self.final_final_attack = false
    local t = 0.3
    self.timer:afterCond(function() return self.part_3_finished end, function()
        if self.final_final_attack then return end
        local y = 0 - 80
        self.timer:after(0.3, function()
            Assets.playSound("shakerbreaker")
            self.hood:setAnimation("battle/idle")
            self.timer:tween(t, self.hood, {
                x = Game.battle.soul.x,
                y = y,
                alpha = 0
            }, "in-cubic", function()
                local positions = {}
                local start_x = 20
                local spacing = 60
                local amount = 12
                local repeats = 3
                local time = 0.06
                for r = 1, repeats do
                    for i = 1,amount do
                        table.insert(positions, start_x + spacing * (i - 1))
                    end

                    for i = 1,amount do
                        i = amount -i
                        table.insert(positions, start_x - 30 + spacing * (i - 1))
                    end
                end

                local pattern = {
                    delay = 0.4
                }
                for i = 1,amount / 2 do
                    table.insert(pattern, start_x + (spacing * (i - 1)) * 2)
                end
                table.insert(positions, pattern)

                local pattern2 = {
                    delay = 0.8
                }
                for i = 1,amount / 2 do
                    table.insert(pattern2, start_x + 40 + (spacing * (i - 1)) * 2)
                end
                table.insert(positions, pattern2)

                local pattern3 = {
                    delay = 1.2,
                    unpack(pattern)
                }
                table.insert(positions, pattern3)

                local pattern4 = {
                    delay = 1.6,
                    unpack(pattern2)
                }
                table.insert(positions, pattern4)

                local space = 0.2
                local first = false
                for i = 1,24 do
                    local pat
                    if first then
                        pat = TableUtils.copy(pattern3)
                    else
                        pat = TableUtils.copy(pattern4)
                    end
                    first = not first
                    for pi,x in ipairs(pat) do
                        pat[pi] = x + MathUtils.random(-18, 18)
                    end
                    pat.delay = 2 + space * (i - 1)
                    table.insert(positions, pat)
                end

                local space = 0.1
                local first = false
                for i = 1,40 do
                    local pat
                    if first then
                        pat = TableUtils.copy(pattern3)
                    else
                        pat = TableUtils.copy(pattern4)
                    end
                    first = not first
                    for pi,x in ipairs(pat) do
                        pat[pi] = x + MathUtils.random(-24, 24)
                    end
                    pat.delay = 7 + space * (i - 1)
                    table.insert(positions, pat)
                end

                local space = 0.08
                local first = false
                for i = 1,42 do
                    local pat
                    if first then
                        pat = TableUtils.copy(pattern3)
                    else
                        pat = TableUtils.copy(pattern4)
                    end
                    first = not first
                    for pi,x in ipairs(pat) do
                        pat[pi] = x + MathUtils.random(-20, 20)
                    end
                    pat.delay = 11 + space * (i - 1)
                    table.insert(positions, pat)
                end

                local space = 0.03
                local first = false
                for i = 1,46 do
                    local pat
                    if first then
                        pat = TableUtils.copy(pattern3)
                    else
                        pat = TableUtils.copy(pattern4)
                    end
                    first = not first
                    for pi,x in ipairs(pat) do
                        pat[pi] = x + MathUtils.random(-13, 13)
                    end
                    pat.delay = 14 + space * (i - 1)
                    pat.exp_chance = 3
                    table.insert(positions, pat)
                end

                local space = 0.01
                local first = false
                for i = 1,60 do
                    local pat
                    if first then
                        pat = TableUtils.copy(pattern3)
                    else
                        pat = TableUtils.copy(pattern4)
                    end
                    first = not first
                    for pi,x in ipairs(pat) do
                        pat[pi] = x + MathUtils.random(-64, 64)
                    end
                    pat.delay = 15 + space * (i - 1)
                    pat.exp_chance = 2
                    table.insert(positions, pat)
                end

                for i,x in ipairs(positions) do
                    if type(x) == "table" then
                        local delay = x.delay or 0
                        local exp_chance = x.exp_chance or 9
                        for i2,x in ipairs(x) do
                            self.timer:after(time * i + delay, function()
                                Assets.playSound("whip_throw_only", 0.2)
                                local bullet = self:spawnBullet("len_hoodie/redspear", x, y, math.rad(90), 21)
                                bullet.destroy_on_hit = false
                                bullet.remove_offscreen = false
                                bullet.rotation = math.rad(90)
                                if delay >= 9 then
                                    self.timer:after(MathUtils.random(0.6), function()
                                        if MathUtils.randomInt(1,exp_chance) == 1 then
                                            local exp = bullet:explode(nil, nil, false, {play_sound = false})
                                            if exp then
                                                exp:setScale(0.7, 1.2)
                                                if MathUtils.randomInt(1,5) == 1 then
                                                    Assets.playSound("badexplosion", 0.3)
                                                end
                                            end
                                        end
                                    end)
                                end
                                self.timer:after(2, function()
                                    if i == #positions then
                                        self.final_final_attack = true
                                    end
                                    bullet:remove()
                                end)
                            end)
                        end
                        x = false
                    end
                    if type(x) == "number" then
                        self.timer:after(time * i, function()
                            Assets.playSound("whip_throw_only", 0.5)
                            local bullet = self:spawnBullet("len_hoodie/redspear", x, y, 0, 21)
                            bullet.destroy_on_hit = false
                            bullet.remove_offscreen = false
                            bullet.rotation = math.rad(90)
                            self.timer:after(2, function()
                                bullet:remove()
                            end)
                        end)
                    end
                end
            end)
        end)
    end)

    self.timer:afterCond(function() return self.final_final_attack end, function()
        self.timer:after(1, function()
            Assets.playSound("spearappear", 2, 0.7)
            local big_bullet = self:spawnBullet("len_hoodie/redspear", SCREEN_WIDTH / 2, 0 - 2598, 0, 1.6)
            big_bullet.rotation = math.rad(90)
            big_bullet.remove_offscreen = false
            big_bullet.destroy_on_hit = false
            big_bullet.inv_frames = 0.2
            ---@param soul Soul
            function big_bullet:onDamage(soul)
                self.hit_big = true
                for _,battler in pairs(Game.battle.party) do
                    battler:hurt(1, true, nil, {all = true, swoon = true})
                end
                Assets.playSound("squeaky")
            end

            big_bullet:setScale(60, 50)
            self.timer:every(0.2, function()
                if not big_bullet then return end
                big_bullet:shake(0.1 + MathUtils.random())
            end)
            self.timer:after(2.9, function()
                local white = Rectangle()
                white:setSize(SCREEN_WIDTH, SCREEN_HEIGHT)
                white:setColor(COLORS.white)
                white.layer = Game.stage.layer + 1
                white.alpha = 0
                Game.stage:addChild(white)
                Assets.playSound("starhyper", 1, 0.7)
                white:fadeTo(1, 5, function()
                    Game.battle.timer:after(0.4, function()
                        white:fadeOutAndRemove(1)
                    end)
                    
                    self.leave_wave = true
                end)
            end)
        end)
    end)
end

function Final:canEnd()
    return self.leave_wave
end

function Final:update()
    self.spear_speed = self.spear_speed + DTMULT / 84

    super.update(self)
end

function Final:onEnd(death)
    self.hood:setPosition(self.hood.init_x, self.hood.init_y)
    self.hood:setAnimation("battle/idle")
    self.hood.alpha = 1
    if self.hit_big then return end
    Game.battle.timer:after(0.4, function()
        for _,battler in pairs(Game.battle.party) do
            battler:hurt(1, true, nil, {all = true})
        end
        Assets.playSound("squeaky")
    end)
end

return Final