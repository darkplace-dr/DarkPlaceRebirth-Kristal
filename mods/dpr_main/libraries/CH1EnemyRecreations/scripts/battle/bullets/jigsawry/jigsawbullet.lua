local JigsawBullet, super = Class(Bullet)

function JigsawBullet:init(x, y)
    super.init(self, x, y, "battle/bullets/jigsaw")

    self:setScale(1)

    self.damage = 0
    self.tp = 0
    self.grazed = false
    self.time_bonus = 0
    self.collidable = false
    self.alpha = 0

    self.bul_init = false
    self.tracking = true
    self.timer = 0
    self.con = 0
    self.side = 0
    self.fade = 0
    self.locked = false
    self.ltimer = 0
    self.joker = false            -- unused variable pertaining to Jevil(?)
end

function JigsawBullet:update()
    local soul = Game.battle.soul

    if self.bul_init == false and self.alpha < 1 then
        self.alpha = self.alpha + (0.1 * DTMULT)

        if self.alpha >= 1 then
            self.bul_init = true
            self.collidable = true
        end
    end

    if self.tracking == true then
        if soul then
            if self.side == 1 or self.side == 3 then
                if (soul.x - self.x) >= 10 then
                    self.x = self.x + 3 * DTMULT
                end
                if (soul.x - self.x) <= -10 then
                    self.x = self.x - 3 * DTMULT
                end
            end

            if self.side == 0 or self.side == 2 then
                if (soul.y - self.y) >= 10 then
                    self.y = self.y + 3 * DTMULT
                end
                if (soul.y - self.y) <= -10 then
                    self.y = self.y - 3 * DTMULT
                end
            end
        end
    end

    self.timer = self.timer + (1 * DTMULT)

    if self.timer >= 30 and self.con == 0 then
        self.tracking = false
        self.physics.direction = -math.rad((self.side * 90) + 180)
        self.physics.speed = 4
        self.physics.gravity_direction = -math.rad(self.side * 90)
        self.physics.gravity = 1.2
    
        if self.joker == true then
            self.physics.gravity = 1.6
            self.physics.speed = 6
        end

        self.con = 1
    end

    if self.timer >= 40 then
        self.physics.gravity = 0
    end

    if self.locked == true then
        self.ltimer = self.ltimer + (1 * DTMULT)
    
        if self.ltimer >= 12 then
            self.alpha = self.alpha - (0.2 * DTMULT)
            self.collidable = false
        end
    
        if self.ltimer >= 17 then
            self:remove()
        end
    end

    local bullets = Game.stage:getObjects(Registry.getBullet("jigsawry/jigsawbullet"))
    for _, bul in ipairs(bullets) do
        if bul.con == 1 and self.con == 1 and bul.collidable == true and self.collidable == true then
            if bul.locked == false then
                bul.physics.speed = 0
                bul.locked = true

                self.physics.speed = 0
                self.locked = 1;
            end
        
            for i = 0, 16-1 do
                if bul.side == 0 then
                    if (bul.x >= (self.x - 28)) then
                        bul.x = bul.x - (1 * DTMULT)
                    end
                    if (x >= (self.x - 28)) then
                        self.x = self.x + (1 * DTMULT)
                    end
                end
            
                if bul.side == 3 then
                    if bul.y >= (self.y - 28) then
                        bul.y = bul.y - (1 * DTMULT)
                    end
                    if bul.y >= (self.y - 28) then
                        self.y = self.y + (1 * DTMULT)
                    end
                end
            
                if bul.side == 2 then
                    if bul.x <= (self.x + 28) then
                        bul.x = bul.x + (1 * DTMULT)
                    end
                
                    if bul.x <= (self.x + 28) then
                        self.x = self.x - (1 * DTMULT)
                    end
                end
            
                if bul.side == 1 then
                    if bul.y <= (self.y + 28) then
                        bul.y = bul.y + (1 * DTMULT)
                    end
                
                    if bul.y <= (self.y + 28) then
                        self.y = self.y - (1 * DTMULT)
                    end
                end
            end
        end
    end

    super.update(self)
end

return JigsawBullet