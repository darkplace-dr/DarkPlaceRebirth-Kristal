local wave, super = Class(Wave)

function wave:init()
    super.init(self)

    self.interval = 35
    -- self.start_time = 40
    self.start_time = 20 -- It's 40 but the code below is inaccurate
    self.segment = MathUtils.randomInt(5)
    self.first_segment = self.segment
    self.second_segment = self.segment
    -- self.creator_id = -1
    self.difficulty = 0
    self.pop = 1
    self.bar_surface = -1
    self.only_bars = false
    -- Set depth to arena - 1
end

function wave:onStart()
    self.interval = 16 + #self:getAttackers() * 4

    -- The code isnt like this but Idk what the alarm[0] = start_time/interval/whatever stuff is
    self.timer:after(self.start_time / 30, function ()
        self.timer:everyInstant(self.interval / 30, function ()
            self:alarm()
        end)
    end)
end

-- function wave:update()
--     -- Code here gets called every frame
--     super.update(self)
-- end

function wave:alarm()
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

        self:spawnBullet("organikk/pillar", x, y)
        if a == 0 then
            self.timer:after(13/30, function ()
                -- Assets.playSound(289, 1, 2)
            end)
        end
    end
end

return wave