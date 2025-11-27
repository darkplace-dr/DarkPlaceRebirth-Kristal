local Spiral, super = Class(Bullet, "mizzle/spiral")

function Spiral:init(x, y)
    super.init(self, x, y, "battle/bullets/mizzle/spiral_1")

    self:setScale(0)

    self.timer = 0
    self.turnvar = 0
    self.angled = false

    self.made = false
end

function Spiral:update()
    super.update(self)

    if not self.made then	
        Game.battle.timer:lerpVar(self, "scale_x", 0, 1, 5)
        Game.battle.timer:lerpVar(self, "scale_y", 0, 1, 5)
        self.made = true
    end

    if Game.battle.wave_timer >= Game.battle.wave_length - 2/30 then
        self:remove()
    end

    self.rotation = self.rotation + -math.rad(10) * DTMULT
    self.timer = self.timer + DTMULT

    if self.angled then
        if self.timer == 5 then
            local bullet = self.wave:spawnBullet("mizzle/holydroplet", self.x, self.y)
            if bullet then
                bullet.physics.direction = MathUtils.angle(bullet.x, bullet.y, Game.battle.arena.x, Game.battle.arena.y) + -math.rad(self.turnvar)
                bullet.rotation = bullet.physics.direction
                bullet.alpha = 0
                bullet.scale_x = 0
                bullet.scale_y = 0
                bullet.physics.speed = 4
            end

            local lifetime = 48
            Game.battle.timer:lerpVar(bullet, "alpha", 0, 1, 8)
            Game.battle.timer:lerpVar(bullet, "scale_x", 0, 0.75, 14)
            Game.battle.timer:lerpVar(bullet, "scale_y", 0, 0.75, 14)

            Game.battle.timer:after(lifetime/30, function()
                bullet.physics.speed = 0
                bullet.collidable = false

                Game.battle.timer:lerpVar(bullet, "alpha", 1, 0, 5)
                Game.battle.timer:lerpVar(bullet, "scale_x", 1, 0, 5)
                Game.battle.timer:lerpVar(bullet, "scale_y", 1, 0, 5)
            end)
            Game.battle.timer:after((lifetime+5)/30, function() 
                self:remove()
            end)
            if self.turnvar ~= 0 then
                Game.battle.timer:lerpVar(bullet.physics, "direction", bullet.physics.direction, bullet.physics.direction - (self.turnvar * 1.75), lifetime * 0.85)
            end
        end
        if self.timer == 7 then
            Game.battle.timer:lerpVar(self, "scale_x", 1, 0, 18)
            Game.battle.timer:lerpVar(self, "scale_y", 1, 0, 18)
        end
        if self.timer == 30 then
            self:remove()
        end
    else
        if self.timer == 5 then
            local bullet = self.wave:spawnBullet("mizzle/holydroplet", self.x, self.y)
            if bullet then
                bullet.physics.direction = MathUtils.angle(bullet.x, bullet.y, Game.battle.arena.x, Game.battle.arena.y)
                bullet.rotation = bullet.physics.direction
                bullet.alpha = 0
                bullet.scale_x = 0
                bullet.scale_y = 0
            end

            Game.battle.timer:lerpVar(bullet, "alpha", 0, 1, 8)
            Game.battle.timer:lerpVar(bullet, "scale_x", 0, 0.75, 14)
            Game.battle.timer:lerpVar(bullet, "scale_y", 0, 0.75, 14)

            Game.battle.timer:after(5/30, function()
                if Game.battle.arena then -- this prevents some crash from occuring on rare occasions when the wave is about to end.
		            bullet.physics.speed = (MathUtils.dist(bullet.x, bullet.y, Game.battle.arena.x, Game.battle.arena.y))/48
                end
            end)
            Game.battle.timer:after(52/30, function()
                bullet.physics.speed = 0
                bullet.collidable = false

                Game.battle.timer:lerpVar(bullet, "alpha", 1, 0, 16)
                Game.battle.timer:lerpVar(bullet, "scale_x", 1, 0, 16)
                Game.battle.timer:lerpVar(bullet, "scale_y", 1, 0, 16)
            end)
        end
        if self.timer == 7 then
            Game.battle.timer:lerpVar(self, "scale_x", 1, 0, 18)
            Game.battle.timer:lerpVar(self, "scale_y", 1, 0, 18)
        end
        if self.timer == 30 then
            self:remove()
        end
    end
end

return Spiral