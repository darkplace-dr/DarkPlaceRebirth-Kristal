local LongNotes, super = Class(Wave)

function LongNotes:init()
    super.init(self)

    self.time = 220/30

    self.interval = 35
    self.start_time = 40
    -- self.start_time = 20 -- It's 40 but the code below is inaccurate
    self.segment = MathUtils.randomInt(5)
    self.first_segment = self.segment
    self.second_segment = self.segment
    -- self.creator_id = -1
    self.difficulty = 0
    self.pop = 1
    self.bar_surface = -1
    self.only_bars = false
    self.del = false
    -- Set depth to arena - 1
end

function LongNotes:onStart()
    for _, attacker in ipairs(self:getAttackers()) do
        if(attacker.harmonizing == true) then
            self.difficulty = 1
        end
    end

    local enemys = Game.battle:getActiveEnemies()

    if #enemys == 3 then
        self.interval = 36
    elseif #enemys == 2 then
        self.interval = 24
    elseif #enemys == 1 then
        self.interval = 40
        self.only_bars = true
    end

    if(self.difficulty == 1) then
        self.interval = 36
    end

    self.timer:after(self.start_time / 30, function ()
        self.timer:everyInstant(self.interval / 30, function ()
            self:alarm()
        end)
    end)
end

function LongNotes:onEnd()
    self.b:remove()
    self.del = true
    if self.b.charge_sfx then
        self.b.charge_sfx:stop()
        self.b.charge_sfx = nil
    end
    if self.b.highlight then
        self.b.highlight:remove()
    end
    Assets.stopSound("harmonize_act_b")
end

-- function LongNotes:update()
--     -- Code here gets called every frame
--     super.update(self)
-- end

function LongNotes:alarm()
    local same_attack = #self:getAttackers()
    for a = 0, same_attack - 1 do
        if a == 0 then
            local list = {0, 1, 2, 3, 4, 5}
            TableUtils.removeValue(list, self.first_segment)
            if same_attack == 1 then
                TableUtils.removeValue(list, self.second_segment)
            end
            -- list = TableUtils.shuffle(list)
            -- self.segment = list[0]
            self.segment = TableUtils.pick(list)
        else
            self.segment = self.segment + 2 + MathUtils.randomInt(2)
        end
        self.segment = self.segment % 6
        if a == 0 then
            self.first_segment = self.segment
        end
        if a == 1 then
            self.second_segment = self.segment
        end
        local x, y = 0, 0
        if self.difficulty > 0 then
            x = Game.battle.arena.x
            y = Game.battle.arena.top + 12.5 + (25 * self.segment)
        else
            x = Game.battle.arena.left + 12.5 + (25 * self.segment)
            y = Game.battle.arena.y
        end

        self.b = self:spawnBullet("organikk/pillar", x, y)
        if a == 0  and self.only_bars == true then
            self.timer:after(13/30, function ()
                local randoff = TableUtils.pick{12.5, 137.5}
                for i = 1, 6 do
                    self.bullet = self:spawnBullet("organikk/note", x, (y - 75) + (((25 * i) + randoff) % 150), 1, math.rad((i % 2) * 180), true)
                    self.bullet.go2 = true
                end
            end)
        end
    end
end

return LongNotes