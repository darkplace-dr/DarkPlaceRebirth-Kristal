local BookAttack, super = Class(Wave, "bibliox/book_attack")

function BookAttack:init()
    super.init(self)

    self.time = 200/30
    self.enemies = self:getAttackers()
	self.sameattack = #self.enemies
	self.ratio = 1
	if #Game.battle.enemies == 2 then
		self.ratio = 1.6
	elseif #Game.battle.enemies == 3 then
		self.ratio = 2.3
	end

    self.made = false
    self.type = 140
    self.spell = 0
    self.btimer = 99
    self.special = 0
end

function BookAttack:update()
    super.update(self)

    self.btimer = self.btimer + DTMULT

    local arena = Game.battle.arena
    local maxtime = 5 + (35 * self.ratio) + (10 * ((self.spell == 0 and self.ratio == 1.5) and 1 or 0)) - (24 * ((self.spell == 0 and self.ratio == 2.3) and 1 or 0))

    if self.type >= 140 and self.type <= 143 then
	    for sameattacker = 0, #self.enemies-1 do
            if self.made == false then
                if self.type > 140 then
                    self.spell = self.type - 140
                else
                    self.spell = MathUtils.randomInt(3)
                end
        
                self.made = true
                self.btimer = maxtime - (8 * sameattacker)
            end
        end


        local remaining_time = Game.battle.wave_length - Game.battle.wave_timer
        if self.btimer > maxtime and remaining_time > (50/30) then
            self.btimer = 0

	    	for sameattacker = 0, #self.enemies-1 do
                local bookside = MathUtils.sign((sameattacker % 2) - 0.5) * MathUtils.sign((self.special % 2) - 0.5)
                local book_x, book_y = arena.x + ((170 + MathUtils.random(20)) * bookside), (arena.y + 70) - (45 * sameattacker) - MathUtils.random(120 - (45 * self.sameattack))

                local book = self:spawnBullet("bibliox/magic_book", book_x, book_y)
                book.timer = 0 - math.floor(sameattacker * 7)
                book.ratio = self.ratio
                book.open_side = bookside
                book.sameattacker = sameattacker
                book.sameattack = self.sameattack
                book.ratio = self.ratio
                book:setSpeed(-5 * bookside, -4)
                book.spell = self.spell
                book.image_index = book.spell

                local boost = 1
                if self.type ~= 104 or self.spell ~= 2 then
                    boost = 0
                end

                book.boost = boost
            end
            
            self.special = self.special + 1
        end

        if remaining_time > (10/30) then
            for _, attacker in ipairs(self.enemies) do
                attacker.sprite:fadeToSpeed(0, 0.1)
            end
        end
    end
end

function BookAttack:onEnd()
    for _, attacker in ipairs(self.enemies) do
        attacker.sprite:fadeToSpeed(1, 0.1)
    end
end

return BookAttack
