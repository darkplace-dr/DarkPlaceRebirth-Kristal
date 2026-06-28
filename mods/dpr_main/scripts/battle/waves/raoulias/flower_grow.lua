local flower_grow, super = Class(Wave)

function flower_grow:init()
	super.init(self)
	self.time = 10
        self.bul = {}
end


function flower_grow:onStart()

        Game.battle:swapSoul(BlueSoul())
    --self.timer:every(1/3, function()

       local attackers = self:getAttackers()

        -- Loop through all attackers
        for i, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker.sprite.flower:getScreenPos()

            --:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            self.bul[i] = self:spawnBullet("smallbullet", x, y, angle, math.random(6, 7))
            self.bul[i].sx = self.bul[i].x
            self.bul[i].f = attacker.sprite.flower
        end

    --end)
end


function flower_grow:d()
    local a = 0.3 + math.random(2, 8)/100

    Assets.playSound("bell", 0.4, a)
end

function flower_grow:update()
    -- Code here gets called every frame


    for i, bullet in ipairs(self.bul) do

        local x, y = bullet.f:getScreenPos()

        if bullet.x < Game.battle.arena.left or bullet.y > Game.battle.arena.bottom then
            --bullet.physics.speed = -bullet.physics.speed
            
            bullet.r = true

        elseif bullet.x > x then
            --bullet.physics.speed = -bullet.physics.speed

            bullet.r = nil
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            bullet.physics.direction = angle
            bullet.x = x - 1

            self:d()

        end


        if bullet.r then
            local angle = Utils.angle(bullet.x, bullet.y, x, y)
            bullet.physics.direction = angle
        end

    end


    super.update(self)
end

return flower_grow