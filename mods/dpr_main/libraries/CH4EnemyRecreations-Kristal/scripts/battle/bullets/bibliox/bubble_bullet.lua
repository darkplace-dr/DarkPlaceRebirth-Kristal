local Book_Bubble, super = Class(Bullet)

function Book_Bubble:init(x, y)
    super.init(self, x, y, "battle/bullets/bibliox/book_bubble")
    self.destroy_on_hit = false
    self.scale_x = 1
    self.scale_y = 1
    self.sprite:play(0.1, true)
    self.insidebox = false

    self.alarm_0 = 0
    self.alarm_0_start = true

    self.dir = 0
    self.book_bullet = nil

    self.pop = false

    self:setHitbox(12, 12, 12, 12)
end

function Book_Bubble:update()
    super.update(self)
    if (self.alarm_0 > 0 and self.alarm_0_start == true) then
        self.alarm_0 = self.alarm_0 - 1 * DTMULT
        if (self.alarm_0 <= 0) then
            self:setSprite("battle/bullets/bibliox/book_bubble_split")
            self.sprite:play(0.1, true)
            self.sprite:setFrame(1)
            self.rotation = math.rad(Utils.random(120)) - math.rad(60)
            self.alarm_0_start = false
        end
    end

    if (self.sprite.frame == 5) then
        if(not self.pop) then
            self.wave:spawnBullet("bibliox/pop", self.x, self.y)
            self.pop = true
        end
    end

    if (self.sprite.frame == 5) then
        if (not self.wave.attack_end) then
            self.dir = (self.rotation + math.rad(360)) % math.rad(120)

            while self.dir < math.rad(360) do
                self.book_bullet = self.wave:spawnBullet("bibliox/bubble_smol", self.x, self.y)
                self.book_bullet.physics.direction = self.dir
                self.book_bullet.physics.speed = 3.5

                Game.battle.timer:lerpVar(self.book_bullet.physics, "speed", self.book_bullet.physics.speed, 2, 20)
                --Game.battle.timer:lerpVar(self.book_bullet.sprite, "speed", self.book_bullet.sprite.speed, 0.1, 35)

                self.dir = self.dir + math.rad(120)
            end
        end
        self:remove()
    end
end

function Book_Bubble:scr_approach_curve(arg0, arg1, arg2)
    local diff = math.abs(arg1 - arg0)
    local step = math.max(0.1, diff / arg2)
    return Utils.approach(arg0, arg1, step)
end

return Book_Bubble
