local Book_Attack, super = Class(Wave)

function Book_Attack:init()
    super.init(self)
    self.time = 8
    self.ratio = self:getEnemyRatio()
    self.sameattack = self:getAttackers()
    self.made = false
    self.type = 140
    self.spell = 0
    self.btimer = 0
    self.special = 0

    self.same_attack = #self:getAttackers()
    self.btimer2 = 0
    self.spell2 = 0
    self.special2 = 0

    self.attack_end = false
end

function Book_Attack:onStart()
    local bibliox = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "bibliox" end)
    for _, biblioxs in ipairs(bibliox) do
        Game.battle.timer:lerpVar(biblioxs.sprite, "alpha", biblioxs.sprite.alpha, 0, 10, 1, "out")
        Game.battle.timer:lerpVar(biblioxs.sprite.body, "alpha", biblioxs.sprite.body.alpha, 0, 10, 1, "out")
        Game.battle.timer:lerpVar(biblioxs.sprite.head, "alpha", biblioxs.sprite.head.alpha, 0, 10, 1, "out")
    end

    if (self.type > 140) then
        self.spell = self.type - 139
    else
        self.spell = Utils.pick { 1, 2, 3 }
        if (self.same_attack == 2) then
            self.spell2 = Utils.pick { 1, 2, 3 }
        end
    end

    self.btimer = (5 + (35 * self.ratio) + (10 * ((self.spell == 0 and self.ratio == 1.5) and 1 or 0))) -
    (24 * ((self.spell == 0 and self.ratio == 2.3) and 1 or 0)) - (8 * 0)
    if (self.same_attack == 2) then
        self.btimer2 = (5 + (35 * self.ratio) + (10 * ((self.spell2 == 0 and self.ratio == 1.5) and 1 or 0))) -
        (24 * ((self.spell2 == 0 and self.ratio == 2.3) and 1 or 0)) - (8 * 1)
    end
end

function Book_Attack:onEnd()
    local bibliox = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "bibliox" end)
    for _, biblioxs in ipairs(bibliox) do
        Game.battle.timer:lerpVar(biblioxs.sprite, "alpha", biblioxs.sprite.alpha, 1, 10, 1, "out")
        Game.battle.timer:lerpVar(biblioxs.sprite.body, "alpha", biblioxs.sprite.body.alpha, 1, 10, 1, "out")
        Game.battle.timer:lerpVar(biblioxs.sprite.head, "alpha", biblioxs.sprite.head.alpha, 1, 10, 1, "out")
    end
end

function Book_Attack:update()
    super.update(self)
    self.btimer = self.btimer + 1 * DTMULT
    if (self.same_attack == 2) then
        self.btimer2 = self.btimer2 + 1 * DTMULT
    end
    if self.btimer > (5 + (35 * self.ratio) + (10 * ((self.spell == 0 and self.ratio == 1.5) and 1 or 0)) - (24 * ((self.spell == 0 and self.ratio == 2.3) and 1 or 0))) and not self.attack_end then
        self.btimer = 0
        local bookside = Utils.sign((0 % 2) - 0.5) * Utils.sign((self.special % 2) - 0.5)
        local book = self:spawnBullet("bibliox/magic_book", Game.battle.arena.x + ((170 + Utils.random(20)) * bookside),
            (Game.battle.arena.y + 70) - (45 * 0) - Utils.random(120 - (45 * #self.sameattack)),
            self.spell)
        book.timer = 0 - math.floor(0 * 7)
        book.ratio = self.ratio
        book.open_side = bookside
        book.sameattacker = 0
        book.sameattack = #self.sameattack
        book.ratio = self.ratio
        book.physics.speed_x = -5 * bookside
        book.physics.speed_y = -4
        book.spell = self.spell
        local boost = 1

        if (self.spell ~= 3) then
            boost = 0
        end

        book.boost = boost

        self.special = self.special + 1
    end
    if (self.same_attack == 2) then
        if self.btimer2 > (5 + (35 * self.ratio) + (10 * ((self.spell == 0 and self.ratio == 1.5) and 1 or 0)) - (24 * ((self.spell2 == 0 and self.ratio == 2.3) and 1 or 0))) and not self.attack_end then
            self.btimer2 = 0
            local bookside2 = Utils.sign((1 % 2) - 0.5) * Utils.sign((self.special2 % 2) - 0.5)
            local book2 = self:spawnBullet("bibliox/magic_book",
                Game.battle.arena.x + ((170 + Utils.random(20)) * bookside2),
                (Game.battle.arena.y + 70) - (45 * 1) - Utils.random(120 - (45 * #self.sameattack)),
                self.spell2)
            book2.timer = 0 - math.floor(1 * 7)
            book2.ratio = self.ratio
            book2.open_side = bookside2
            book2.sameattacker = 1
            book2.sameattack = #self.sameattack
            book2.ratio = self.ratio
            book2.physics.speed_x = -5 * bookside2
            book2.physics.speed_y = -4
            book2.spell = self.spell2
            book2.boost = 0

            self.special2 = self.special2 + 1
        end
    end

    if Game.battle.wave_length - Game.battle.wave_timer < 18 / 50 and self.attack_end == false then
        self.attack_end = true
    end
end

function Book_Attack:getEnemyRatio()
    local enemies = #Game.battle:getActiveEnemies()
    if enemies <= 1 then
        return 1
    elseif enemies == 2 then
        return 1.6
    elseif enemies >= 3 then
        return 2.3
    end
end

return Book_Attack
