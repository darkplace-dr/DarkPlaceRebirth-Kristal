local wave, super = Class(Wave)

function wave:init()
    super.init(self)
    self.time = 10

    self:setArenaPosition(321, 260)
    self:setArenaSize(142, 100)

    self.atx = 0
    self.aty = 0

    self.timer = 0
    self.image_index = 0
    self.remove_timer = 0
    self.remove_string = false

end

function wave:onStart()
    self.same_attack = #self:getAttackers()
    local attacker
    if(Game.battle.enemies[1].id == "balthizard" and Game.battle.enemies[1].lightup == true) then
        attacker = Game.battle.enemies[1]
    elseif(Game.battle.enemies[2].id == "balthizard" and Game.battle.enemies[2].lightup == true) then
        attacker = Game.battle.enemies[2]
    elseif(Game.battle.enemies[2].id == "balthizard") then
        attacker = Game.battle.enemies[2]
    elseif(Game.battle.enemies[3].id == "balthizard") then
        attacker = Game.battle.enemies[3]
    end
    if(self.same_attack == 2) then
        self.atx = attacker.x
        self.aty = attacker.y - 50
        self:spawnBullet("balthizard/censer", self.atx, self.aty)
        attacker:setAnimation("transition")
    end
    self:spawnBullet("balthizard/cloud_manager", Game.battle.arena.x, Game.battle.arena.y)
end

function wave:update()
    super.update(self)
    local attacker
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
        Object.startCache()
        local infected = {}
        for _,smoke in ipairs(self.bullets) do
            if smoke.collidable and smoke:isBullet("balthizard/incense_fire_bullet") then
                for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
                    if bullet:isBullet("balthizard/cloud") then
                        if not infected[bullet] and bullet:collidesWith(smoke.infect_collider) then
                            infected[bullet] = true
                            smoke:infect(bullet)
                            break
                        end
                    end
                end
            end
        end
        Object.endCache()
        Object.startCache()
        local infected2 = {}
        for _,destroyed in ipairs(self.bullets) do
            if destroyed.collidable and destroyed:isBullet("balthizard/cloud_destroyed") then
                for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
                    if bullet:isBullet("balthizard/cloud") then
                        if not infected2[bullet] and bullet:collidesWith(destroyed.infect_collider) then
                            infected2[bullet] = true
                            destroyed:infect(bullet)
                            break
                        end
                    end
                end
            end
        end
        Object.endCache()
        Object.startCache()
        local infected3 = {}
        for _,fire in ipairs(self.bullets) do
            if fire.collidable and fire:isBullet("balthizard/incense_bullet_fire") then
                for _,bullet in ipairs(Game.stage:getObjects(Bullet)) do
                    if bullet:isBullet("balthizard/cloud") then
                        if not infected3[bullet] and bullet:collidesWith(fire.infect_collider) then
                            infected3[bullet] = true
                            fire:infect(bullet)
                            break
                        end
                    end
                end
            end
        end
        Object.endCache()
    end

    if(self.timer == 2) then
        if(self.image_index == 0) then
            self.image_index = 1
        else
            self.image_index = 0
        end
        self.timer = 0
    end
    if(self.remove_timer >= 15) then
        self.remove_string = true
    end
    self.timer = self.timer + 1
    self.remove_timer = self.remove_timer + 1
end

return wave