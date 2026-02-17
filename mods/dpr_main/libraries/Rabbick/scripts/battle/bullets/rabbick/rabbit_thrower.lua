local Rabbit, super = Class(Bullet)

function Rabbit:init(x, y)
    super.init(self, x, y, "bullets/rabbick/thrower")
    self.sprite:stop()

    self:setOriginExact(11, 17)

    self.collider = CircleCollider(self, 12, 20, 4)
    self.collidable = false

    self.tp = 3.6
    self.time_bonus = 3
	
    self.con = 0
    self.throw_n = 0
    self.buffer = 0
    self.throwtimer = 0

    self.dir = TableUtils.pick{1, -1}
    self.physics.gravity = 1
    self.physics.speed_y = -14
    self.physics.speed_x = self.dir * MathUtils.random(2)

    self.layer = Game.battle.arena.layer - 1
	
    self.timer = Timer()
    self:addChild(self.timer)
end

function Rabbit:update()
    local enemies = #Game.battle:getActiveEnemies()

    self.buffer = self.buffer + (1 * DTMULT)
	
    if self.buffer == 19 then
        self.physics.gravity = 0
        self.physics.speed_y = 0
        self.physics.speed_x = 4 * self.dir
        self:setLayer(BATTLE_LAYERS["above_arena"])
        --self.collidable = true
    end
	
    if self.buffer >= 19 then
        self.y = Game.battle.arena.y - (Game.battle.arena.height / 2)
		
        if self.x <= (Game.battle.arena.x - Game.battle.arena.width / 2 + 20) then
            self.x = self.x + 4
            if self.physics.speed_x < 0 then
                self.physics.speed_x = -self.physics.speed_x
            end
        end
        if self.x >= (Game.battle.arena.x + Game.battle.arena.width / 2 - 20) then
            self.x = self.x - 4
            if self.physics.speed_x > 0 then
                self.physics.speed_x = -self.physics.speed_x
            end
        end
		
        if self.buffer >= 20 and self.con == 0 and (math.abs(self.x - (Game.battle.soul.x + 2)) < 30) then
            self.con = 5
        end
		
        if self.con == 5 then
            self.sprite:play(1/(30 * 0.5), false)
            self.con = 6
        end
		
        if self.con == 6 then
            if self.sprite.frame >= 3 and self.throw_n == 0 then
                self.throw_n = 1
				
                local carrot = self.wave:spawnBullet("bullets/rabbick/carrot", self.x, self.y)
                carrot.collider = CircleCollider(carrot, 6, 6, 2)
				
                local speedmax = 7
                if enemies == 2 then
                    speedmax = 6
                end
                if enemies == 3 then
                    speedmax = 5
                end

                carrot.physics.speed_y = speedmax
                carrot.sprite:play(1/(30 * 0.25), true)
                carrot.remove_offscreen = true
            end
            if self.sprite.frame >= 4 then
                self.throw_n = 0
                self.sprite:stop()
                self.con = 7

                if enemies == 2 then
                    self.timer:after(22/30, function() self.con = self.con + 1 end)
                elseif enemies == 3 then
                    self.timer:after(30/30, function() self.con = self.con + 1 end)
                else
                    self.timer:after(15/30, function() self.con = self.con + 1 end)
                end
            end
        end

        if self.con == 8 then
            self.sprite:setFrame(1)
            self.con = 0
        end
    end

	super.update(self)
end

return Rabbit