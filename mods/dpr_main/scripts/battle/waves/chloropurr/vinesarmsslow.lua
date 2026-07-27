local MovingArena, super = Class(Wave)

function MovingArena:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
    self.time = 18
end

function MovingArena:onStart()
    -- Get the arena object
    local arena = Game.battle.arena

        -- Spawn spikes on top of arena
        self:spawnBulletTo(Game.battle.arena, "chloropurr/vines", arena.width/2, 0, math.rad(0),20)
local enemy = Game.battle:getEnemyBattler("chloropurr")
        enemy:setAnimation("hitslower")
    -- Every 0.33 seconds...
    self.timer:every(1, function()
        -- Get all enemies that selected this wave as their attack
        local attackers = self:getAttackers()

        -- Loop through all attackers
        for _, attacker in ipairs(attackers) do

            -- Get the attacker's center position
            local x, y = attacker:getRelativePos(attacker.width/2, attacker.height/2)

            -- Get the angle between the bullet position and the soul's position

            -- Spawn smallbullet angled towards the player with speed 8 (see scripts/battle/bullets/smallbullet.lua)
            self:spawnBullet("chloropurr/handbullet", x-60, y, (MathUtils.random(-50, 50)), 12, Game.battle.soul.x, Game.battle.soul.y)
        end
    end)
    -- Store starting arena position
end

function MovingArena:update()
    -- Increment timer for arena movement

    -- Calculate the arena offset

    super.update(self)
end
function MovingArena:onEnd()
    local enemy = Game.battle:getEnemyBattler("chloropurr")
    enemy:setAnimation("idle")
end
return MovingArena