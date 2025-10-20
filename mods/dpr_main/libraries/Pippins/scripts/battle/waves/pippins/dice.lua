local Dice, super = Class(Wave)

function Dice:init()
	super.init(self)
	self.time = 5
    self.timer = 0
    self.soul_offset_x = -10+8
    self.soul_offset_y = 18+8
    self.savex = 0
    self.difficulty = Utils.pick{0,1,2,3,4}
    self.n = 0
end

function Dice:onStart()
    local attackers = Game.battle:getActiveEnemies()

    if(#attackers >= 3) then
        self.difficulty = 1
    else
        self.difficulty = Utils.pick{0,1,2,3,4}
    end
    if(self.difficulty == 3 or self.difficulty == 4) then
        if(#attackers >= 2) then
            self.difficulty = Utils.pick{0,1,2,3,4}
        end
    end
    if(self.difficulty == 0) then
        self.n = Utils.pick{1,5,5,5}
    elseif(self.difficulty == 1) then
        self.n = Utils.pick{8,8,4,4}
    elseif(self.difficulty == 2) then
        self.n = Utils.pick{12,8,8,5}
    elseif(self.difficulty == 3) then
        self.n = Utils.pick{12,12,8,8}
    elseif(self.difficulty == 4) then
        self.n = Utils.pick{1,12,12,8}
    end

    for _, attacker in ipairs(self:getAttackers()) do
        attacker:setAnimation("prepare")
        Game.battle.timer:tween(0.3, attacker, {x = attacker.x + 50}, "out-quad", function() end)
    end
    Assets.stopSound("wing")
    Assets.playSound("wing")
    local bullet = self:spawnBullet("pippins/dicebullet",(Game.battle.arena.x - 60 + love.math.random(120)), (Game.battle.arena.y - 90 - love.math.random(30)), 0)
    bullet.image_index = self.n
    for _, attacker in ipairs(self:getAttackers()) do
        if(attacker.ikasama == true) then
            bullet.setsprite = "bullets/pippins/all4s_"
        end
    end
    
end

function Dice:onEnd()
    for _, attacker in ipairs(self:getAttackers()) do
        if(attacker.bet == true) then
            attacker.bet = false
        end
        if(attacker.ikasama == true) then
            attacker.ikasama = false
        end
        if(attacker.wairo == true) then
            attacker.wairo = false
        end
        if attacker.anim ~= "idle" then
            if(attacker.mercy >= 100) then
                attacker:setAnimation("spared")
            elseif(attacker.tired == true) then
                attacker:setAnimation("tired")
            else
                attacker:setAnimation("idle")
            end
        end
    end
end

function Dice:update()
    super.update(self)

    local attackers = Game.battle:getActiveEnemies()

    self.timer = self.timer + (1 * DTMULT)
    local pippins = Utils.filter(Game.battle:getActiveEnemies(), function(e) return e.id == "pippins" end)
    if(#pippins >= 1) then
        if(self.timer == 12) then
            for _, attacker in ipairs(self:getAttackers()) do
                Game.battle.timer:tween(0.3, attacker, {x = attacker.x - 50}, "out-quad", function() end)
            end

            if(#attackers >= 3) then
                self.difficulty = 1
            else
                self.difficulty = Utils.pick{0,1,2,3,4}
            end
            if(self.difficulty == 3 or self.difficulty == 4) then
                if(#attackers >= 2) then
                    self.difficulty = Utils.pick{0,1,2,3,4}
                end
            end
            if(self.difficulty == 0) then
                self.n = Utils.pick{1,5,5,5}
            elseif(self.difficulty == 1) then
                self.n = Utils.pick{8,8,4,4}
            elseif(self.difficulty == 2) then
                self.n = Utils.pick{12,8,8,5}
            elseif(self.difficulty == 3) then
                self.n = Utils.pick{12,12,8,8}
            elseif(self.difficulty == 4) then
                self.n = Utils.pick{1,12,12,8}
            end

            Assets.stopSound("wing")
            Assets.playSound("wing",1,1.1)
            local bullet = self:spawnBullet("pippins/dicebullet",(Game.battle.arena.x - 60 + love.math.random(120)), (Game.battle.arena.y - 90 - love.math.random(30)), 0)
            bullet.image_index = self.n
            for _, attacker in ipairs(self:getAttackers()) do
                if(attacker.ikasama == true) then
                    bullet.setsprite = "bullets/pippins/all4s_"
                end
            end
        end
        if(self.timer == 24 and #pippins >= 2) then

            if(#attackers >= 3) then
                self.difficulty = 1
            else
                self.difficulty = Utils.pick{0,1,2,3,4}
            end

            self.difficulty = Utils.pick{0,1,2,3,4}
            if(self.difficulty == 3 or self.difficulty == 4) then
                self.difficulty = Utils.pick{0,1,2,3,4}
            end
            if(self.difficulty == 0) then
                self.n = Utils.pick{1,5,5,5}
            elseif(self.difficulty == 1) then
                self.n = Utils.pick{8,8,4,4}
            elseif(self.difficulty == 2) then
                self.n = Utils.pick{12,8,8,5}
            elseif(self.difficulty == 3) then
                self.n = Utils.pick{12,12,8,8}
            elseif(self.difficulty == 4) then
                self.n = Utils.pick{1,12,12,8}
            end

            Assets.stopSound("wing")
            Assets.playSound("wing",1,1.2)
            local bullet = self:spawnBullet("pippins/dicebullet",(Game.battle.arena.x - 60 + love.math.random(120)), (Game.battle.arena.y - 90 - love.math.random(30)), 0)
            bullet.image_index = self.n
            for _, attacker in ipairs(self:getAttackers()) do
                if(attacker.ikasama == true) then
                    bullet.setsprite = "bullets/pippins/all4s_"
                end
            end
        end
        if(self.timer == 36 and #pippins >= 3) then

            self.n = Utils.pick{8,8,4,4}

            Assets.stopSound("wing")
            Assets.playSound("wing",1,1.3)
            local bullet = self:spawnBullet("pippins/dicebullet",(Game.battle.arena.x - 60 + love.math.random(120)), (Game.battle.arena.y - 90 - love.math.random(30)), 0)
            bullet.image_index = self.n
            for _, attacker in ipairs(self:getAttackers()) do
                if(attacker.ikasama == true) then
                    bullet.setsprite = "bullets/pippins/all4s_"
                end
            end
        end
    end
     
end

return Dice