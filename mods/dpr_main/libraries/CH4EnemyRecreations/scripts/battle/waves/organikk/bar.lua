local OrganNoteManager, super = Class(Wave)

function OrganNoteManager:init()
    super.init(self)

    self.time = 220/30

    self.drawlength = 0;
    --alarm[0] = 8;
    self.sameattacker = 0;
    self.sameattack = 1;
    self.bullet_counter = 0;
    self.repeating = false;
    self.simulnotes = 0
    self.interval = 0
    --enemy 1
    self.origin_list = {}
    self.gap_list = {}
    self.bullet_list = {}
    self.v_pos = 0
    self.gap_value = 0

    --enemy 2
    self.origin_list2 = {}
    self.gap_list2 = {}
    self.bullet_list2 = {}
    self.v_pos2 = 0
    self.cur_note2 = 0
    self.gap_value2 = 0

    self.special = 0
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

function OrganNoteManager:onStart()
    self.same_attack = #self:getAttackers()

    if self.same_attack >= 2 then
        self.same_attack = 2
    end

    for _, attacker in ipairs(self:getAttackers()) do
        self.atx = attacker.x
        self.aty = attacker.y
    end

    self.gap_list = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    self.gap_list = TableUtils.shuffle(self.gap_list)

    if self.same_attack == 2 then
        self.gap_list2 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
        self.gap_list2 = TableUtils.shuffle(self.gap_list2)
    end

    self.interval = 20

    local enemys = Game.battle:getActiveEnemies()

    if #enemys == 3 then
        self.simulnotes = 1
    elseif #enemys == 2 then
        self.simulnotes = 2
    elseif #enemys == 1 then
        self.simulnotes = 5
    end

    if self.same_attack == 2 then
        self.simulnotes = 2
    end

    if self.same_attack == 1 then
        self.origin_list = {1, 1, 1, 2, 2, 2, 3, 3, 3, TableUtils.pick{1,2,3}}
    elseif self.same_attack == 2 then
        self.origin_list = {1, 1, 2, 2, 3, 3}
        self.origin_list2 = {1, 1, 2, 2, 3, 3}
        self.interval = 25
        for _ = 1, 4 do
            table.remove(self.gap_list, 1)
            table.remove(self.gap_list2, 1)
            --TableUtils.removeValue(self.gap_list, 1)
            --TableUtils.removeValue(self.gap_list2, 1)
        end
    end
    table.sort(self.gap_list)
    self.origin_list = TableUtils.shuffle(self.origin_list)

    if(self.same_attack == 2) then
        table.sort(self.gap_list2)
        self.origin_list2 = TableUtils.shuffle(self.origin_list2)
    end
end

function OrganNoteManager:update()
    super.update(self)
    if self.alarm_0 > 0 and self.alarm_0_start then
        self.alarm_0 = self.alarm_0 - 1 * DTMULT
        if self.alarm_0 <= 0 then
            self.alarm_0_start = false
            self:alarm0()
        end
    end
    if self.alarm_1 > 0 and self.alarm_1_start then
        self.alarm_1 = self.alarm_1 - 1 * DTMULT
        if self.alarm_1 <= 0 then
            self.alarm_1_start = false
            self:alarm1()
        end
    end
    if self.alarm_2 > 0 and self.alarm_2_start then
        self.alarm_2 = self.alarm_2 - 1 * DTMULT
        if self.alarm_2 <= 0 then
            self.alarm_2_start = false
            self.timeron = false
            self.timeron = true
            self:alarm2()
        end
    end
end

function OrganNoteManager:alarm0()
    self.timer:lerpVar(self, "drawlength", 0, 77 * 2.5, 16, -1, "out")
    self.alarm_1 = 8
    self.alarm_1_start = true
end

function OrganNoteManager:alarm1()
    local arena = Game.battle.arena
    
    self.v_pos = arena.top - 40
    self.v_pos2 = arena.bottom + 40

    if self.bullet_counter < #self.origin_list then
        self.special = TableUtils.pick{-3, -2, -1, 0, 1, 2}

        self.image_index = self.origin_list[self.bullet_counter + 1]
        self.bullet = self:spawnBullet("organikk/note", self.atx - 50, self.aty - 80, self.image_index, self.special)

        self.gap_value = self.gap_list[self.bullet_counter + 1]
        self.timer:lerpVar(self.bullet, "x", self.bullet.x, (arena.left - 20) + (20 * self.gap_value), 12, 0, "out")

        self.timer:lerpVar(self.bullet, "y", self.bullet.y, self.v_pos + (10 * self.special), 12, -3, "out")

        table.insert(self.bullet_list, self.bullet)

        if(self.same_attack == 2) then
            self.image_index = self.origin_list2[self.bullet_counter + 1]
            self.bullet2 = self:spawnBullet("organikk/note", self.atx - 50, self.aty - 80, self.image_index, self.special)

            self.gap_value2 = self.gap_list2[self.bullet_counter + 1]
            self.timer:lerpVar(self.bullet2, "x", self.bullet2.x, (arena.left - 20) + (20 * self.gap_value2), 12, 0, "out")

            self.timer:lerpVar(self.bullet2, "y", self.bullet2.y, self.v_pos2 + (10 * self.special), 12, -3, "out")

            table.insert(self.bullet_list2, self.bullet2)
        end

        if self.special == -3 then
            Assets.playSound("organikk_notes/f")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/f")
            end
        elseif self.special == -2 then
            Assets.playSound("organikk_notes/e")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/e")
            end
        elseif self.special == -1 then
            Assets.playSound("organikk_notes/d")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/d")
            end
        elseif self.special == 0 then
            Assets.playSound("organikk_notes/c")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/c")
            end
        elseif self.special == 1 then
            Assets.playSound("organikk_notes/b")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/b")
            end
        elseif self.special == 2 then
            Assets.playSound("organikk_notes/a")
            if(self.same_attack == 2) then
                Assets.playSound("organikk_notes/a")
            end
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
        if(self.same_attack == 2) then
            self.bullet_list2 = TableUtils.shuffle(self.bullet_list2)
        end
        if self.repeating then
            self.alarm_2 = 1
            self.alarm_2_start = true
        else
            self.alarm_2 = 12
            self.alarm_2_start = true
        end
    end
end

function OrganNoteManager:alarm2()
    for i = 1, self.simulnotes do
        if #self.bullet_list > 0 then
            local cur_note = self.bullet_list[1]
            local cur_note2 = self.bullet_list2[1]

            cur_note.shway_counter = TableUtils.pick{0, 10 * math.pi}
            cur_note.physics.direction = Utils.angle(cur_note.x, cur_note.y, Game.battle.soul.x, Game.battle.soul.y)
            self.timer:lerpVar(cur_note.physics, "speed", -5, 0, 10, 0, "in")

            if(self.same_attack == 2) then
                cur_note2.shway_counter = TableUtils.pick{0, 10 * math.pi}
                cur_note2.physics.direction = Utils.angle(cur_note2.x, cur_note2.y, Game.battle.soul.x, Game.battle.soul.y)
                self.timer:lerpVar(cur_note2.physics, "speed", -5, 0, 10, 0, "in")
            end

            self.timer:after(0.4, function ()
                    cur_note.physics.direction = math.rad(90 + MathUtils.random(-5,5))
                    if(self.same_attack == 2) then
                        cur_note2.physics.direction = math.rad(270 + MathUtils.random(-5,5))
                    end
            end)
            self.timer:after(0.8, function ()
                self:spawnBullet("organikk/afterimage_note", cur_note.x, cur_note.y, cur_note.image_index)
                if(self.same_attack == 2) then
                    self:spawnBullet("organikk/afterimage_note", cur_note2.x, cur_note2.y, cur_note2.image_index)
                end

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

                if(self.same_attack == 2) then
                    if(cur_note2.image_index == 1) then
                        cur_note2.go = true
                        cur_note2.physics.speed = 4
                    end
                    if(cur_note2.image_index == 2) then
                        cur_note2.physics.speed = 5
                    end
                    if(cur_note2.image_index == 3) then
                        cur_note2.physics.speed = 3.75
                    end
                end
            end)

            table.remove(self.bullet_list, 1)
            if(self.same_attack == 2) then
                table.remove(self.bullet_list2, 1)
            end
        end
    end

    if #self.bullet_list > 0 then
        self.alarm_2 = self.interval
        self.alarm_2_start = true
    else
        self.alarm_1 = 1
        self.alarm_1_start = true
        self.bullet_counter = 0
        self.repeating = true

        self.origin_list = {}
        if(self.same_attack == 2) then
            self.origin_list2 = {}
        end
        if self.same_attack == 1 then
            self.origin_list = {1, 1, 1, 2, 2, 2, 3, 3, 3, TableUtils.pick{1,2,3}}
        elseif self.same_attack == 2 then
            self.origin_list = {1, 1, 2, 2, 3, 3}
            self.origin_list2 = {1, 1, 2, 2, 3, 3}
        end

        self.origin_list = TableUtils.shuffle(self.origin_list)
        if(self.same_attack == 2) then
            self.origin_list2 = TableUtils.shuffle(self.origin_list2)
        end

        self.gap_list = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
        self.gap_list = TableUtils.shuffle(self.gap_list)

        if(self.same_attack == 2) then
            self.gap_list2 = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
            self.gap_list2 = TableUtils.shuffle(self.gap_list2)
        end

        if self.same_attack == 2 then
            for _ = 1, 4 do
                table.remove(self.gap_list, 1)
                table.remove(self.gap_list2, 1)
            end
        end

        table.sort(self.gap_list)
        if(self.same_attack == 2) then
            table.sort(self.gap_list2)
        end
    end
end

local function draw_line_width_color(x1, y1, x2, y2, width, color1, color2)
    love.graphics.setLineWidth(width)
    love.graphics.setColor(color1)
    love.graphics.line(x1, y1, x2, y2)
end

-- function OrganNoteManager:shuffle(tbl)
--     for i = #tbl, 2, -1 do
--         local j = math.random(1, i)
--         tbl[i], tbl[j] = tbl[j], tbl[i]
--     end
-- end

function OrganNoteManager:draw()

    local arena = Game.battle.arena

    local col = ColorUtils.mergeColor(COLORS.green, COLORS.lime, 0.5)
    local v_pos
    local v_pos2
    v_pos = arena.top - 40
    v_pos2 = arena.bottom + 40

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

    if self.same_attack == 2 then
        for c = 0, 4 do
            local y2 = (v_pos2 - 20) + (10 * c)
            draw_line_width_color(arena.right + 25, y2, (arena.right + 25) - self.drawlength, y2, 2, col, col) --20
        end

        for d = 0, self.drawlength - 1 do
            if d == 45 or d == 138 then -- 50 140
                local x2 = (arena.right + 20) - d
                draw_line_width_color(x2, v_pos2 - 25, x2, v_pos2 + 25, 2, col, col)
            end
        end
    end
end

return OrganNoteManager