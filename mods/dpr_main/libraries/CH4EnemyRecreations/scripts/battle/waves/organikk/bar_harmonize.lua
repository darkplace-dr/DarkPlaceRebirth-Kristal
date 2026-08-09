local LongNotesOrganNote, super = Class(Wave)

function LongNotesOrganNote:init()
    super.init(self)

    ----------------------longnote init----------------------
    self.time = 220/30

    self.interval = 35
    self.start_time = 20 -- It's 40 but the code below is inaccurate
    self.segment = MathUtils.randomInt(5)
    self.first_segment = self.segment
    self.difficulty = 1
    self.pop = 1
    self.bar_surface = -1
    self.del = false

    ----------------------organnote init----------------------
    self.drawlength = 0;
    --alarm[0] = 8;
    self.sameattacker = 0;
    self.sameattack = 1;
    self.bullet_counter = 0;
    self.repeating = false;
    self.simulnotes = 0
    self.interval_org = 0
    self.origin_list = {}
    self.gap_list = {}
    self.bullet_list = {}
    self.v_pos = 0
    self.special = 0
    self.gap_value = 0
    self.i = 1
    self.image_index = 0
    self.played = 0
    self.atx = 0
    self.aty = 0

    self.alarm_0 = 8
    self.alarm_0_start = true
    self.alarm_1 = 0
    self.alarm_1_start = false
    self.alarm_2 = 0
    self.alarm_2_start = false
end

function LongNotesOrganNote:onStart()
    ----------------------longnote onStart----------------------
    self.interval = 36

    self.timer:after(self.start_time / 30, function ()
        self.timer:everyInstant(self.interval / 30, function ()
            self:alarm()
        end)
    end)

    ----------------------organnote onStart----------------------
    for _, attacker in ipairs(self:getAttackers()) do
        self.atx = attacker.x
        self.aty = attacker.y
    end

    self.gap_list = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    TableUtils.shuffle(self.gap_list)

    self.interval_org = 20

    local enemys = Game.battle:getActiveEnemies()

    if #enemys == 3 then
        self.simulnotes = 1
    elseif #enemys == 2 then
        self.simulnotes = 2
    elseif #enemys == 1 then
        self.simulnotes = 5
    end

    if self.sameattack == 1 then
        self.origin_list = {1, 1, 1, 2, 2, 2, 3, 3, 3, TableUtils.pick{1,2,3}}
    elseif self.sameattack == 2 then
        self.origin_list = {0, 0, 1, 1, 2, 2}
        self.interval_org = 25
        for _ = 1, 4 do
            TableUtils.removeValue(self.gap_list, 1)
        end
    end
    table.sort(self.gap_list)
    self.origin_list = TableUtils.shuffle(self.origin_list)
end

----------------------longnote code----------------------

function LongNotesOrganNote:onEnd()
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

function LongNotesOrganNote:alarm()  
    local list = {0, 1, 2, 3, 4, 5}
    TableUtils.removeValue(list, self.first_segment)
        
    self.segment = TableUtils.pick(list)
    self.segment = self.segment % 6
    self.first_segment = self.segment
    local x, y = 0, 0
    x = Game.battle.arena.x
    y = Game.battle.arena.top + 12.5 + (25 * self.segment)

    self.b = self:spawnBullet("organikk/pillar_harmony", x, y)
end

----------------------organnote code----------------------

function LongNotesOrganNote:update()
    super.update(self)

    if self.alarm_0 > 0 and self.alarm_0_start then
        self.alarm_0 = self.alarm_0 - DTMULT
        if self.alarm_0 <= 0 then
            self.alarm_0_start = false
            self:alarm0()
        end
    end
    if self.alarm_1 > 0 and self.alarm_1_start then
        self.alarm_1 = self.alarm_1 - DTMULT
        if self.alarm_1 <= 0 then
            self.alarm_1_start = false
            self:alarm1()
        end
    end
    if self.alarm_2 > 0 and self.alarm_2_start then
        self.alarm_2 = self.alarm_2 - DTMULT
        if self.alarm_2 <= 0 then
            self.alarm_2_start = false
            self:alarm2()
        end
    end
end

function LongNotesOrganNote:alarm0()
    self.timer:lerpVar(self, "drawlength", 0, 77 * 2.5, 16, -1, "out")
    self.alarm_1 = 8
    self.alarm_1_start = true
end

function LongNotesOrganNote:alarm1()
    local arena = Game.battle.arena

    if (self.sameattacker == 0) then
        self.v_pos = arena.top - 40
    else
        self.v_pos = arena.bottom + 40
    end

    if self.bullet_counter < #self.origin_list then
        self.special = TableUtils.pick{-3, -2, -1, 0, 1, 2}

        self.image_index = self.origin_list[self.bullet_counter + 1]
        self.bullet = self:spawnBullet("organikk/note", self.atx - 50, self.aty - 80, self.image_index, self.special)

        self.gap_value = self.gap_list[self.bullet_counter + 1]
        self.timer:lerpVar(self.bullet, "x", self.bullet.x, (arena.left - 20) + (20 * self.gap_value), 12, 0, "out")

        self.timer:lerpVar(self.bullet, "y", self.bullet.y, self.v_pos + (10 * self.special), 12, -3, "out")

        table.insert(self.bullet_list, self.bullet)

        if self.special == -3 then
            Assets.playSound("organikk_notes/f")
        elseif self.special == -2 then
            Assets.playSound("organikk_notes/e")
        elseif self.special == -1 then
            Assets.playSound("organikk_notes/d")
        elseif self.special == 0 then
            Assets.playSound("organikk_notes/c")
        elseif self.special == 1 then
            Assets.playSound("organikk_notes/b")
        elseif self.special == 2 then
            Assets.playSound("organikk_notes/a")
        end

        self.bullet_counter = self.bullet_counter + 1

        if self.repeating then
            self.alarm_1 = 2
            self.alarm_1_start = true
        else
            self.alarm_1 = 3
            self.alarm_1_start = true
        end
    else 
        self.bullet_list = TableUtils.shuffle(self.bullet_list)
        if self.repeating then
            self.alarm_2 = 1
            self.alarm_2_start = true
        else
            self.alarm_2 = 12
            self.alarm_2_start = true
        end
    end
end

function LongNotesOrganNote:alarm2()
    local arena = Game.battle.arena

    for i = 1, self.simulnotes do
        if #self.bullet_list > 0 then
            local cur_note = self.bullet_list[1]

            cur_note.shway_counter = TableUtils.pick{0, 10 * math.pi}
            cur_note.physics.direction = Utils.angle(cur_note.x, cur_note.y, Game.battle.soul.x, Game.battle.soul.y)
            self.timer:lerpVar(cur_note.physics, "speed", -5, 0, 10, 0, "in")

            self.timer:after(0.4, function ()
                if (self.sameattacker == 0) then
                    cur_note.physics.direction = math.rad(90 + MathUtils.random(-5,5))
                else
                    self.v_pos = arena.bottom + 40
                end
            end)
            self.timer:after(0.8, function ()
                self:spawnBullet("organikk/afterimage_note", cur_note.x, cur_note.y, cur_note.image_index)

                if(cur_note.image_index == 1) then
                    cur_note.go = true
                    cur_note.physics.speed = 4
                end
                if(cur_note.image_index == 2) then
                    cur_note.physics.speed = 5
                end
                if(cur_note.image_index == 3) then
                    cur_note.physics.speed = 3.75
                end
            end)

            table.remove(self.bullet_list, 1)
        end
    end

    if #self.bullet_list > 0 then
        self.alarm_2 =  self.interval_org
        self.alarm_2_start = true
    else
        self.alarm_1 = 1
        self.alarm_1_start = true
        self.bullet_counter = 0
        self.repeating = true

        self.origin_list = {}
        if self.sameattack == 1 then
            self.origin_list = {1, 1, 1, 2, 2, 2, 3, 3, 3, TableUtils.pick{1,2,3}}
        elseif self.sameattack == 2 then
            self.origin_list = {0, 0, 1, 1, 2, 2}
        end

        self.origin_list = TableUtils.shuffle(self.origin_list)

        self.gap_list = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
        TableUtils.shuffle(self.gap_list)

        if self.sameattack == 2 then
            for _ = 1, 4 do
                TableUtils.removeValue(self.gap_list, 1)
            end
        end
        table.sort(self.gap_list)
    end
end

local function draw_line_width_color(x1, y1, x2, y2, width, color1, color2)
    love.graphics.setLineWidth(width)
    love.graphics.setColor(color1)
    love.graphics.line(x1, y1, x2, y2)
end

-- function LongNotesOrganNote:shuffle(tbl)
--     for i = #tbl, 2, -1 do
--         local j = math.random(1, i)
--         tbl[i], tbl[j] = tbl[j], tbl[i]
--     end
-- end

function LongNotesOrganNote:draw()
    super.draw(self)

    local arena = Game.battle.arena

    local col = ColorUtils.mergeColor(COLORS.green, COLORS.lime, 0.5)
    local v_pos
    if self.sameattacker == 0 then
        v_pos = arena.top - 40
    else
        v_pos = arena.bottom + 40
    end

    for a = 0, 4 do
        local y = (v_pos - 20) + (10 * a)
        draw_line_width_color(arena.right + 25, y, (arena.right + 25) - self.drawlength, y, 2, col, col) --20
    end

    for b = 0, self.drawlength - 1 do
        if b == 45 or b == 138 then -- 50 140
            local x = (arena.right + 20) - b
            draw_line_width_color(x, v_pos - 25, x, v_pos + 25, 2, col, col)
        end
    end
end

return LongNotesOrganNote