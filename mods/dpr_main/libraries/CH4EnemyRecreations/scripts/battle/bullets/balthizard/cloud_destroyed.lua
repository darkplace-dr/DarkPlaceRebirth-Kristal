local Cloud_Destroyed, super = Class(Bullet)

function Cloud_Destroyed:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/incense_cloud")
    self:setHitbox(26, 21, 17, 10)
    self.destroy_on_hit = false
    self.timer = 0;
    self.con = 0;
    self.type = 2;
    self.chainreaction = true;
    self.chainreactiontimer = 0;
    self.alpha = 0
    self.fx = nil
    self.inst = nil

    self.infect_collider = Hitbox(self, 26, 21, 17, 10)
    self.infecting = false
end

function Cloud_Destroyed:infect(other)
    if not other.parent or not self.parent then return end
    if(other.fireeeeeee <= 0 and self.chainreactiontimer > 5) then
        other.fireeeeeee = 1
    end
end

function Cloud_Destroyed:update()
    super.update(self)
    self.chainreactiontimer = self.chainreactiontimer + 1
    self.timer = self.timer + 1
    if(self.timer == 1) then
        Assets.stopSound("explosion_firework")
        Assets.playSound("explosion_firework")
        Assets.playSound("explosion_firework")
    end
    if(self.timer == 1) then
        local dir = math.rad(-20) + math.rad(Utils.random(40)) + self.rotation
        local len = 10 + Utils.random(15)
        self.fx = self.wave:spawnBullet("balthizard/fire_explosion", self.x + math.cos(dir) * len, self.y + math.sin(dir) * len)
        dir = math.rad(160) + math.rad(Utils.random(40)) + self.rotation
        len = Utils.random(25)
        self.fx = self.wave:spawnBullet("balthizard/fire_explosion", self.x + math.cos(dir) * len, self.y + math.sin(dir) * len)
    end
    if(self.timer == 5) then
        local angle = math.rad(Utils.random(360))
        for i = 1, 4 do
            self.inst = self.wave:spawnBullet("balthizard/incense_bullet_fire", self.x,self.y)
            self.inst.rotation = angle
            self.inst.physics.direction = angle
            self.inst.scale_x = 0.5
            self.inst.scale_y = 0.5
            self.inst.physics.speed = 1
            self.inst.physics.friction = -0.1
            self.inst.chainreaction = self.chainreaction
            angle = angle + math.rad(90)
        end
        self:remove()
    end
    
end

return Cloud_Destroyed