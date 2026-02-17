local Slasher, super = Class(Bullet)

function Slasher:init(x, y)
    super.init(self, x, y, "battle/enemies/rudinnranger/slash")
    self.sprite:stop()
    self.image_index = 1
    self.sprite:setFrame(self.image_index)

	self:setOrigin(0.5, 1)

    self.inv_timer = 60/30
    self.tp = 2.4
    self.time_bonus = 2
	
    self.con = 0
    self.timer = 0
    self.type = 0

    self.movecon = 0
    self.movetimer = 0
    self.movesiner = 0
    self.movefactor = 0

    self.start_x, self.start_y = self.x, self.y
	self.sprite:setOriginExact(20, 10)
end

function Slasher:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Y Pos: " .. self.y)
    table.insert(info, "Con: " .. self.con)
    table.insert(info, "Move Con: " .. self.movecon)
    return info
end

function Slasher:update()
    super.update(self)

    if self.con == 0 then
        self.throwernumber = #Game.stage:getObjects(Registry.getBullet("rudinnranger/slasher"))
        self.con = 12
        self.movecon = 4
        self.timer = 0
        self.thrown = 0
        self.image_index = 1
    end

    if self.movecon == 4 then
        self.movesiner = self.movesiner + (1 * DTMULT)

        if Game.battle.wave_timer <= (Game.battle.wave_length - 1) then
            if self.movefactor < 1 then
                self.movefactor = self.movefactor + (0.1 * DTMULT)
            end
        end

        self.y = self.start_y + (math.sin(self.movesiner / 16) * 40 * self.movefactor)

        if Game.battle.wave_timer >= (Game.battle.wave_length - 1) then
            if self.movefactor > 0 then
                self.movefactor = self.movefactor - (0.1 * DTMULT)
            else
                self.movefactor = 0
            end
        end
    end

    if self.con == 10 then
        self.timer = 0
        self.thrown = 0
        self.image_index = 1

        if Game.battle.wave_timer < (Game.battle.wave_length - (15/30)) then
            self.con = 11
        end
    end

    if self.con == 11 then
        self.image_index = self.image_index + 0.334 * DTMULT
    
        if self.image_index >= 5 and self.thrown == 0 then
	        local xx, yy = self:getRelativePos(0, 0)
            local swordbullet = self.wave:spawnBullet("rudinnranger/swordbullet", xx + 6, yy + 34)
            swordbullet.siner = self.movesiner
            swordbullet.throwernumber = self.throwernumber

            swordbullet.physics.direction = MathUtils.angle(swordbullet.x, swordbullet.y, Game.battle.soul.x, Game.battle.soul.y)
            swordbullet:setSpeed(9 + (math.sin(swordbullet.siner / 10) * 4))

            if swordbullet.throwernumber == 2 then
                swordbullet.physics.speed = swordbullet.physics.speed * 0.85
            end
            if swordbullet.throwernumber == 3 then
                swordbullet.physics.speed = swordbullet.physics.speed * 0.7
            end

            swordbullet.physics.direction = swordbullet.physics.direction + -math.rad(5 - MathUtils.random(10))
            swordbullet.rotation = swordbullet.physics.direction
            swordbullet:setLayer(self.layer - 1)
            self.thrown = 1
        end
    
        if self.image_index >= 7 then
            self.con = 12
            self.timer = 0
        end
    end

    if self.con == 12 then
        self.timer = self.timer + 1 * DTMULT
    
        if self.timer >= (self.throwernumber * 3) then
            self.con = 10
        end
    end

    self.sprite:setFrame(math.floor(self.image_index))
end

return Slasher