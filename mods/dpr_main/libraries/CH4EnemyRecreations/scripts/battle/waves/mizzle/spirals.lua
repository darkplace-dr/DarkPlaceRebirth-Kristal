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

    local miz_cd
    if attackers == enemies then
        miz_cd = 19 + (attackers * 3)
    else
        miz_cd = 22 + (attackers * 6)
    end

    self.timer:everyInstant(miz_cd/30, function()
        local do_this = true
		
		for _, wave in ipairs(Game.battle.waves) do
			if wave.spotlight and wave.spotlight.alert then
				do_this = false
			end
		end
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

function Spirals:update()
	super.update(self)
    local attackers = #self:getAttackers()           --scr_monsterpop()
    local enemies = #Game.battle:getActiveEnemies()  --sameattack
    if enemies == attackers then
		for _, bullet in ipairs(self.bullets) do
			if bullet:isBullet("mizzle/holydroplet") and not bullet:isRemoved() then
				bullet.x = bullet.x + ((math.sin((Kristal.getTime()*30) * 0.1) * 1.5) / enemies)
			end
		end
    end
end

function Spirals:draw()
	super.draw(self)
	for _, bullet in ipairs(self.bullets) do
		if bullet:isBullet("mizzle/holydroplet") and not bullet:isRemoved() then
			Draw.setColor(bullet:getDrawColor())
			Draw.draw(bullet.outline_tex, bullet.x, bullet.y, bullet.rotation, bullet.scale_x, bullet.scale_y, 16, 16)
		end
	end
	for _, bullet in ipairs(self.bullets) do
		if bullet:isBullet("mizzle/holydroplet") and not bullet:isRemoved() then
			Draw.setColor(0, 0.5, 0.5, bullet.alpha)
			Draw.draw(bullet.sprite.texture, bullet.x + ((bullet.last_x - bullet.x) * FRAMERATE/30), bullet.y + ((bullet.last_y - bullet.y) * FRAMERATE/30), MathUtils.angle(bullet.x + ((bullet.last_x - bullet.x) * FRAMERATE/30), bullet.y + ((bullet.last_y - bullet.y) * FRAMERATE/30), bullet.x, bullet.y), bullet.scale_x, bullet.scale_y, 16, 16)
			Draw.setColor(bullet:getDrawColor())
		end
	end
	for _, bullet in ipairs(self.bullets) do
		if bullet:isBullet("mizzle/holydroplet") and not bullet:isRemoved() then
			Draw.setColor(bullet:getDrawColor())
			Draw.draw(bullet.sprite.texture, bullet.x, bullet.y, bullet.rotation, bullet.scale_x, bullet.scale_y, 16, 16)
		end
	end
end
return Spirals