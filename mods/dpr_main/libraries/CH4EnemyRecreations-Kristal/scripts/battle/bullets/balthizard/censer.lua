local Censer, super = Class(Bullet)

function Censer:init(x, y)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/balthizard/body")

    self.collidable = false

    self.box_offset = 24;
    self.anchor_x = self.x;
    self.anchor_y = self.y;
    self.hang_x = self.x;
    self.hang_y = math.rad(170)
    self.hheight = self.y - self.hang_y;
    self.height_goal = Game.battle.arena.y - 70 - (Game.battle.arena.height * 0.5) - self.box_offset - self.hang_y
    self.hangle = 270
    self.cur_angle = 270
    self.swing_max = 35
    self.acceleration_val = 0;
    self.timer = 0;
    self.con = 0;
    self.ratio = 1;
    self.do_return = false;
    self.string_shake_x = 0;
    self.string_shake_y = 0;
    self.string_shake_timer = 0;
    self.lightup = false;
    self.remove_offscreen = false
    self.alpha = 0

    self.string = 1
    self.ccon = 0
    self.string_timer = 0
    self.string_go = false

    --self.mask_fx = MaskFX(self.cloud_mask)
    --self:addFX(self.mask_fx)

    self.rng_angle = 0
    self.b1 = nil
    self.b2 = nil
    self.b3 = nil

    
    self.line = {self.width/2, self.height/2, 30, -y,}
    self.initt = false
end

function Censer:update()
    super.update(self)
    if(self.initt == false) then
        local attacker
        if(self.wave.same_attack == 2) then
            if(Game.battle.enemies[1].id == "balthizard" and Game.battle.enemies[1].lightup == true) then
                attacker = Game.battle.enemies[1]
            elseif(Game.battle.enemies[2].id == "balthizard" and Game.battle.enemies[2].lightup == true) then
                attacker = Game.battle.enemies[2]
            elseif(Game.battle.enemies[2].id == "balthizard") then
                attacker = Game.battle.enemies[2]
            elseif(Game.battle.enemies[3].id == "balthizard") then
                attacker = Game.battle.enemies[3]
            end
            if(attacker.lightup) then
                self.lightup = true;
            end
        else
            for _, attacker in ipairs(self.wave:getAttackers()) do
                if(attacker.lightup) then
                    self.lightup = true;
                end
            end
        end
    end
    local enemys = Game.battle:getActiveEnemies()
    local balthizard = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "balthizard" end)
    if(self.ccon == 0) then
        self.timer = self.timer + 1
        self.string_timer = self.string_timer + 1
        if(self.timer == 1 and self.string <= 15) then
            local attacker
            if(self.wave.same_attack == 2) then
                if(Game.battle.enemies[1].id == "balthizard" and Game.battle.enemies[1].lightup == true) then
                    attacker = Game.battle.enemies[1]
                elseif(Game.battle.enemies[2].id == "balthizard" and Game.battle.enemies[2].lightup == true) then
                    attacker = Game.battle.enemies[2]
                elseif(Game.battle.enemies[2].id == "balthizard") then
                    attacker = Game.battle.enemies[2]
                elseif(Game.battle.enemies[3].id == "balthizard") then
                    attacker = Game.battle.enemies[3]
                end
                self.atx = attacker.x
                self.aty = attacker.y
            else
                for _, attacker in ipairs(self.wave:getAttackers()) do
                    self.atx = attacker.x
                    self.aty = attacker.y
                end
            end
            self.wave:spawnBullet("balthizard/turtle_string", self.atx, self.aty - 50 - (17 * self.string))
            self.string = self.string + 1
            self.timer = 0
        end
        if(self.string_timer == 16) then
            self.timer = 0
            self.string_timer = 0
            self.ccon = 1
        end
    end
    if(self.ccon == 1) then
        self.timer = self.timer + 1
        self.acceleration_val = Utils.approach(self.acceleration_val, 0.25, 0.01);
        self.cur_angle = math.rad(self.hangle) + (math.sin(self.timer * 0.1) * math.rad(self.swing_max));
        self.hang_x = Utils.approach(self.hang_x, Game.battle.arena.x, math.abs(self.hang_x - Game.battle.arena.x) * self.acceleration_val);
        self.hheight = Utils.approach(self.hheight, self.height_goal, math.abs(self.hheight - self.height_goal) * 0.25);

        self.x = self.hang_x + math.cos(self.cur_angle) * self.hheight
        --self.y = self.y + math.sin(self.cur_angle)

        if self.timer == 1 then
            self.alpha = 1
            self.string_go = true
            Game.battle.timer:lerpVar(self, "y", self.y, 120, 25, -1, "out")
        end

        if self.timer == 150 then
            self.ccon = 2
            self.timer = 0
            Game.battle.timer:lerpVar(self, "x", self.x, self.atx, 25, -1, "out")
            Game.battle.timer:lerpVar(self, "y", self.y, self.aty - 44, 25, -1, "out")
        end

        if(self.timer < 20) then
            return
        end

        if ((((#enemys > 1 and (self.timer % (13 + math.floor(15 * self.ratio))) == 0) or (self.timer % (13 + math.floor(15 * self.ratio))) == 5) and (#balthizard > 1 or self.lightup == false)) or (#enemys == 3 and (self.timer % 7) == 0 and self.lightup == true and #balthizard == 1) or (#enemys == 2 and (self.timer % 7) == 0 and self.lightup == true and #balthizard == 1) or (#enemys == 1 and (self.timer % 4) == 0 and self.lightup == true) or (#enemys == 1 and (self.timer % 10) == 0 and self.lightup == false)) then
            self.rng_angle = math.rad(Utils.random(-15,15))
            if(self.lightup) then
                self.b1 = self.wave:spawnBullet("balthizard/incense_fire_bullet", self.x, self.y)
                self.b1.physics.direction = math.rad(270) + self.rng_angle
                self.b1.physics.speed = -0.1
                self.b1.physics.gravity_direction = self.b1.physics.direction
                self.b1.physics.friction = -0.2
                self.b1.rotation = 0
                self.b1.scale_x = 1
                self.b1.scale_y = 1
            else
                self.b1 = self.wave:spawnBullet("balthizard/incense_bullet", self.x + 10, self.y - 10)
                self.b1.physics.direction = (math.rad(270) + self.rng_angle) - math.rad(15)
                self.b1.physics.speed = -0.04
                self.b1.physics.gravity_direction = self.b1.physics.direction - math.rad(20)
                self.b1.physics.friction = -0.15
                self.b1.spin = 1
                self.b1.spinspeed = 1
                self.b2 = self.wave:spawnBullet("balthizard/incense_bullet", self.x, self.y - 25)
                self.b2.physics.direction = math.rad(270) + self.rng_angle
                self.b2.physics.speed = -0.01
                self.b2.physics.gravity_direction = self.b2.physics.direction
                self.b2.physics.friction = -0.1
                self.b2.spin = 1
                self.b2.spinspeed = 1
                self.b3 = self.wave:spawnBullet("balthizard/incense_bullet", self.x - 10, self.y - 20)
                self.b3.physics.direction = (math.rad(270) + self.rng_angle) + math.rad(15)
                self.b3.physics.speed = -0.04
                self.b3.physics.gravity_direction = self.b3.physics.direction + math.rad(20)
                self.b3.physics.friction = -0.15
                self.b3.spin = 1
                self.b3.spinspeed = 1
            end
        end
        
    end
    if(self.ccon == 2) then
        self.rotation = math.rad(0)
        self.timer = self.timer + 1
        if self.timer == 10 then
            self.ccon = 3
            self.timer = 0
        end
    end
    if(self.ccon == 3) then
        self.timer = self.timer + 1
        if self.timer == 20 then
            self.line = {0, 0, 0, 0,}
            local attacker
            if(self.wave.same_attack == 2) then
                if(Game.battle.enemies[1].id == "balthizard" and Game.battle.enemies[1].lightup == true) then
                    attacker = Game.battle.enemies[1]
                elseif(Game.battle.enemies[2].id == "balthizard" and Game.battle.enemies[2].lightup == true) then
                    attacker = Game.battle.enemies[2]
                elseif(Game.battle.enemies[2].id == "balthizard") then
                    attacker = Game.battle.enemies[2]
                elseif(Game.battle.enemies[3].id == "balthizard") then
                    attacker = Game.battle.enemies[3]
                end
                attacker:setAnimation("transition_end")
            else
                for _, attacker in ipairs(self.wave:getAttackers()) do
                    attacker:setAnimation("transition_end")
                end
            end
        end
        if self.timer == 21 then
            self.alpha = 0
        end
        
    end
end

function Censer:lengthdir_x(length, angle_deg)
    local angle_rad = angle_deg
    return math.cos(angle_rad) * length
end

function Censer:lengthdir_y(length, angle_deg)
    local angle_rad = angle_deg
    return math.sin(angle_rad) * length
end

function Censer:draw()
    if(self.ccon <= 2) then
        self.rotation = Utils.angle(self.x, self.y, self.hang_x, self.hang_y) + math.rad(90)
    end
    if(self.string_go) then
        love.graphics.setColor(1,1,1, 1)
        love.graphics.setLineWidth(2)
        love.graphics.line(self.line)
        love.graphics.setLineWidth(1)
    end
    super.draw(self)
end



return Censer