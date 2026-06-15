---@class SmashCutAttack : Bullet
---@overload fun(...) : SmashCutAttack
local SmashCutAttack, super = Class(Bullet)

function SmashCutAttack:init(x, y)
    super.init(self, x, y)

    self.tenna = Game.battle:getEnemyBattler("tenna")

    self.collidable = false

    self.timer = 0
    self.side = -1
    self.aim_counter = 0

    self.type = -1
    
    if self.tenna then
        self.type = (self.tenna.hellmode == true) and 2 or 1

        if self.tenna.smashcutwithouttakingdamage == 1 then
            self.type = 3
        end
    end

    self.damage = 4
    self.sideprevious = -2

    self.rumble_loop = Assets.newSound("rumble")
    self.rumble_loop:setVolume(0.5)
    self.rumble_loop:setLooping(true)
end

function SmashCutAttack:onAdd(parent)
    super.onAdd(self, parent)

    if self.tenna then
        local smashcutter = self.wave:spawnObject(TennaSmashCutter(self.x, self.y))
    else
        Assets.playSound("scytheburst")

        local smashcut_manager = self.wave:spawnObject(TennaSmashCutManager(self.x, self.y))
        smashcut_manager:setLayer(BATTLE_LAYERS["above_bullets"])
        Game.battle:shakeCamera()
        self.rumble_loop:play()
    end
end

function SmashCutAttack:getTarget()
    return "ALL"
end

function SmashCutAttack:update()
    super.update(self)

    local old_t = self.timer
    self.timer = self.timer + DTMULT
    
    local make_random_lightning = 0

    if self.type == 0 then
        if self.timer >= 10 then
            make_random_lightning = 1
            self.timer = 0
        end
    end

    if self.type >= 1 then
        if old_t < 10 and self.timer >= 10 then
            self.timer = -20

            local vside = TableUtils.pick{ -1, 1 } 
            local hside = 0

            if self.type == 1 or self.type == 3 then
                hside = TableUtils.pick{ -1, 1 } 
            
                if hside == self.sideprevious then
                    hside = TableUtils.pick{ -1, 1 } 
                end

                if hside == self.sideprevious then
                    hside = TableUtils.pick{ -1, 1 } 
                end

                if self.type == 3 then
                    self.side = self.side * (-1 ^ DTMULT)
                    vside = self.side
                end
            
                self.timer = -16
            end

            if self.type == 2 then
                hside = TableUtils.pick{ -1, 1, 2 }
            
                if hside == self.sideprevious then
                    hside = TableUtils.pick{ -1, 1, 2 }
                end

                if hside == self.sideprevious then
                    hside = TableUtils.pick{ -1, 1, 2 }
                end

                self.timer = -16
            end
        
            self.sideprevious = hside
            local makex = Game.battle.arena.x
            local amount = 5
            local randomhoz

            if self.type == 3 then
                amount = 3
                randomhoz = MathUtils.random(-30, 30)
            end

            for i = 0, amount-1 do
                if hside == 1 or hside == -1 then
                    makex = Game.battle.arena.x + ((70 - (i * 16)) * hside)
                elseif (i % 2) == 0 then
                    makex = Game.battle.arena.x - (i * 8)
                else
                    makex = Game.battle.arena.x + (i * 8)
                end
            
                if self.type == 3 then
                    makex = Game.battle.arena.x + (((60 - (i * 60)) + randomhoz) * hside)
                end

                local smash_lightning = self.wave:spawnBullet("tenna/smash_lightning", makex, Game.battle.arena.y + (140 * vside))
                smash_lightning.physics.direction = -math.rad(180 - (90 * self.side))
                smash_lightning:setSpeed(0, vside * -(2 - (i / 4)))
                smash_lightning.physics.friction = -0.08
                
                if self.type == 3 then
                    smash_lightning.tp = 1.8
                end

                smash_lightning.damage = self.damage

                if self.type == 3 then
                    smash_lightning.physics.friction = -0.03
                    smash_lightning.alpha = 0
                    Game.battle.timer:lerpVar(smash_lightning, "alpha", 4, 0, 100)
                    Game.battle.timer:lerpVar(smash_lightning, "alpha", 0, 1, 8)
                    Game.battle.timer:after(100/30, function() smash_lightning:remove() end)
                else
                    smash_lightning.alpha = 0
                    Game.battle.timer:lerpVar(smash_lightning, "alpha", 4, 0, 70)
                    Game.battle.timer:lerpVar(smash_lightning, "alpha", 0, 1, 8)
                    Game.battle.timer:after(70/30, function() smash_lightning:remove() end)
                end
            end
        end
    end

    if make_random_lightning == 1 then
        self.side = self.side * (-1 ^ DTMULT)
        self.aim_counter = self.aim_counter + DTMULT
        local hoz = Game.battle.arena.x + MathUtils.randomInt(-86, 86)

        if self.aim_counter >= 7 or (self.aim_counter > 4 and MathUtils.randomInt(2)) then
            hoz = Game.battle.soul.x
            self.aim_counter = 0
        end

        local smash_lightning = self.wave:spawnBullet("tenna/smash_lightning", hoz, Game.battle.arena.y + (120 * self.side))
        smash_lightning.physics.direction = -math.rad(180 - (90 * self.side))
        smash_lightning.damage = self.damage
        smash_lightning.tp = 0.8
        smash_lightning.x = smash_lightning.x + 4 * DTMULT

        Game.battle.timer:after(1/30, function() smash_lightning.x = smash_lightning.x - 8 end)
        Game.battle.timer:after(2/30, function() smash_lightning.x = smash_lightning.x + 7 end)
        Game.battle.timer:after(3/30, function() smash_lightning.x = smash_lightning.x - 6 end)
        Game.battle.timer:after(4/30, function() smash_lightning.x = smash_lightning.x + 5 end)
        Game.battle.timer:after(5/30, function() smash_lightning.x = smash_lightning.x - 4 end)
        Game.battle.timer:after(6/30, function() smash_lightning.x = smash_lightning.x + 3 end)
        Game.battle.timer:after(7/30, function() smash_lightning.x = smash_lightning.x - 2 end)
        Game.battle.timer:after(8/30, function() smash_lightning.x = smash_lightning.x + 1 end)
        Game.battle.timer:after(10/30, function() Game.battle.timer:lerpVar(smash_lightning.physics, "speed", 2, 6, 20) end)
    end
end

function SmashCutAttack:draw()
    super.draw(self)
end

function SmashCutAttack:onRemove()
    super.onRemove(self)

    if self.rumble_loop then
        self.rumble_loop:stop()
    end
end

return SmashCutAttack