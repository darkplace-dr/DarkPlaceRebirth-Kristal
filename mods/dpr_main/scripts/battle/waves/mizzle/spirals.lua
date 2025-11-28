local Spirals, super = Class(Wave)

function Spirals:init()
    super.init(self)

    self.time = 270/30
end

function Spirals:onStart()
    local attackers = #self:getAttackers()           --scr_monsterpop()
    local enemies = #Game.battle:getActiveEnemies()  --sameattack
    local arena = Game.battle.arena

    local side = 1
    local offset = 0
    --coat_pop = instance_number(obj_mizzle_enemy);    -- literally an unused variable lmao
    --instance_create(0, 0, obj_coathanger_renderer);  -- this is supposed to be the blue trail effect on the droplet bullets

    if enemies == attackers then
        --for _, bul in ipairs(Game.stage:getObjects(Registry.getBullet("mizzle/holydroplet"))) do
        --    bul.x = ((math.sin((Kristal.getTime()*30) * 0.1) * 1.5) / enemies)
        --end
    end

    local miz_cd
    if attackers == enemies then
        miz_cd = 19 + (attackers * 3)
    else
        miz_cd = 22 + (attackers * 6)
    end

    self.timer:everyInstant(miz_cd/30, function()
        local do_this = true

        --haven't ported the spotlight attack yet.
        --[[
        with (obj_mizzle_spotlight_controller_b)
        {
            if (alert)
                do_this = false;
        }
        ]]
        
        offset = MathUtils.randomInt(-60, 60)
        local circ = 7 + (3 * enemies)
        
        if do_this then
            for a = 0, circ-1 do
                local cside = 90 + (90 * side)
                local spiral = self:spawnBullet("mizzle/spiral",arena.x + MathUtils.lengthDirX(128, math.rad((cside - 5) + (10 * a) + offset)), arena.y + MathUtils.lengthDirY(128, math.rad((cside - 5) + (10 * a) + offset)))
                spiral = self:spawnBullet("mizzle/spiral", arena.x + MathUtils.lengthDirX(128, math.rad(((cside + 5) - (10 * a)) + offset)), arena.y + MathUtils.lengthDirY(128, math.rad(((cside + 5) - (10 * a)) + offset)))
            end
        end
        
        side = side * -1
    end)
end

return Spirals