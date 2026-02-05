local Cloud_manager, super = Class(Bullet)

function Cloud_manager:init(x, y)
    super.init(self, x, y, nil)

    self.collidable = false

    self.cloud_surface = -1;
    self.turn_direction = math.rad(TableUtils.pick{-1, 1})
    self.timer = 0;
    self.cloud_approach = 0;
    self.movedir_1 = TableUtils.pick{-1, 1};
    self.movedir_2 = TableUtils.pick{-1, 1};
    self.contraction = 1;
    self.sameattack = 2;
    self.power_val = 0;
    self.sin_power = 1 + (math.sin(self.timer * 0.05) * self.power_val);
    self.cos_power = 1 - (math.sin(self.timer * 0.05) * self.power_val);

    self.cloud = {}
    self.mas = {}

    self.ultimate_goal = 0

    self.iinit = false
    self.remove_offscreen = false

    self.hurt_notify_timer = 0
end

function Cloud_manager:update()
    super.update(self)
    if(self.iinit == false) then
        for i = 0, 19 do
            local cloud = self.wave:spawnBullet("balthizard/cloud", self.x + MathUtils.lengthDirX(240 * self.sin_power, -i * 18), self.y + MathUtils.lengthDirY(240 * self.cos_power, -i * 18))
            cloud.manager = self
            self.cloud[i] = cloud
            self.cloud[i].alpha = -i * 0.025
            self.cloud[i].distance = 240
            self.cloud[i].current_angle = MathUtils.angle(self.cloud[i].x, self.cloud[i].y, self.x, self.y)
            self.cloud[i].rotation = self.cloud[i].current_angle - math.rad(90)
            local extender = 0
            if((i % 2) == 0) then
                self.cloud[i].ratio = 1
                self.cloud[i].distance_goal = 55 - MathUtils.random(5);
                self.cloud[i].distance_goal = self.cloud[i].distance_goal + (15 * self.sameattack);
            else
                self.cloud[i].ratio = (0.66 + MathUtils.random(0.33)) * 2;
                self.cloud[i].distance_goal = 65 - MathUtils.random(10);
                self.cloud[i].distance_goal = self.cloud[i].distance_goal + (15 * self.sameattack);
            end
            self.cloud[i].distance_goal = self.cloud[i].distance_goal + extender
        end
        self.iinit = true
    end

    self.timer = self.timer + DTMULT
    self.cloud_approach = MathUtils.approach(self.cloud_approach, 0.25, 0.0025 * DTMULT);
    self.sin_power = 1 + (math.sin(self.timer * 0.05) * self.power_val);
    self.cos_power = 1 - (math.sin(self.timer * 0.05) * self.power_val);
    self.contraction = 1 + (math.sin(self.timer * 0.06) * 0.2);

    for i = 0, 19 do
        self.cloud[i].alpha = MathUtils.approach(self.cloud[i].alpha, 0.1, 0.05 * DTMULT);
    end
    self.x = Game.battle.arena.x + (math.sin(self.timer * 0.03) * 36 * self.movedir_1);
    self.y = Game.battle.arena.y + (math.sin(self.timer * 0.06) * 28 * self.movedir_2);

    for i = 0, 19 do
        self.ultimate_goal = (self.cloud[i].distance_goal * self.contraction) + (math.sin((self.timer * 0.1) + self.cloud[i].individual_value) * 4) * DTMULT;
        self.cloud[i].distance = MathUtils.approach(self.cloud[i].distance, self.ultimate_goal, math.abs(self.cloud[i].distance - self.ultimate_goal) * self.cloud_approach * DTMULT);
        self.cloud[i].current_angle = self.cloud[i].current_angle + (self.cloud[i].ratio * self.turn_direction) * DTMULT;
        self.cloud[i].rotation = self.cloud[i].current_angle - math.rad(90)
        self.cloud[i].x = self.x + MathUtils.lengthDirX(self.cloud[i].distance * self.sin_power, -self.cloud[i].current_angle);
        self.cloud[i].y = self.y + MathUtils.lengthDirY(self.cloud[i].distance * self.sin_power, -self.cloud[i].current_angle);
    end
end

return Cloud_manager