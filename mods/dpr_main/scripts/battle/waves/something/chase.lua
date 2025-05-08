local chase, super = Class(Wave)

function chase:init()
    super.init(self)
    self:setArenaSize(284, 213)
end

function chase:onStart()
    -- Every 0.5 seconds...
    -- Get all enemies that selected this wave as their attack
    local attackers = self:getAttackers()

    -- Loop through all attackers
    for _, attacker in ipairs(attackers) do

        -- Get the attacker's center position
        local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

        -- Get the angle between the bullet position and the soul's position
        local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

        -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        self:spawnBullet("chase", x, y, angle + math.rad(0), 9)
        self:spawnBullet("chase", x, y, angle + math.rad(10), 9)
        self:spawnBullet("chase", x, y, angle - math.rad(10), 9)
        self:spawnBullet("chase", x, y, angle + math.rad(20), 9)
        self:spawnBullet("chase", x, y, angle - math.rad(20), 9)
        self:spawnBullet("chase", x, y, angle + math.rad(30), 9)
        self:spawnBullet("chase", x, y, angle - math.rad(30), 9)
    end
    self.timer:every(0.75, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position
            local angle = Utils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)

            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            self:spawnBullet("chase", x, y, angle + math.rad(10), 9)
            self:spawnBullet("chase", x, y, angle - math.rad(10), 9)
            self:spawnBullet("chase", x, y, angle + math.rad(20), 9)
            self:spawnBullet("chase", x, y, angle - math.rad(20), 9)
            self:spawnBullet("chase", x, y, angle + math.rad(30), 9)
            self:spawnBullet("chase", x, y, angle - math.rad(30), 9)
            self:spawnBullet("chase", x, y, angle + math.rad(0), 9)
        end
    end)
end

function chase:update()
    -- Code here gets called every frame

    super.update(self)
end

return chase