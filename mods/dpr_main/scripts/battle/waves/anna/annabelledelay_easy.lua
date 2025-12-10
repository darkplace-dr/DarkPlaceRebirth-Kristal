local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)
    self.animation = self:getAttackers()[1]
end

function Basic:onStart()
    self:spawnBullet("annabelle/soulmarker", 320, 170, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 320, 120, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 320, 220, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 370, 170, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 370, 120, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 370, 220, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 270, 170, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 270, 120, math.rad(180), 0)
    self:spawnBullet("annabelle/soulmarker", 270, 220, math.rad(180), 0)
    -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn arrow_short angled towards the player with speed 8 (see scripts/battle/bullets/arrow_short.lua)
            self.animation.sprite:set("attack")
            Assets.playSound("wing")
            local random = love.math.random(1, 6)
            if random == 1 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,2)
            end
            if random == 2 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,1)
            end
            if random == 3 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,2)
            end
            if random == 4 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,1)
            end
            if random == 5 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,0)
            end
            if random == 6 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,0)
            end
        end
    self.timer:every(1, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn arrow_short angled towards the player with speed 8 (see scripts/battle/bullets/arrow_short.lua)
            self.animation.sprite:set("attack")
            Assets.playSound("wing")
            local random = love.math.random(1, 6)
            if random == 1 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,2)
            end
            if random == 2 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,1)
            end
            if random == 3 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,2)
            end
            if random == 4 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,0)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,1)
            end
            if random == 5 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,0)
            end
            if random == 6 then
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 170,1)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 120,2)
                self:spawnBullet("annabelle/arrow_delay", x, y, math.rad(180), -4, 220,0)
            end
        end
    end)
end

function Basic:onEnd()
    self.animation.sprite:set("idle")
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic