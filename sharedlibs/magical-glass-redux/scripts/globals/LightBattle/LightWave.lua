local LightWave, super = Class(Wave)

function LightWave:init()
    super.init(self)
    
    self.allow_duplicates = true

    self.darken = false
    self.auto_clear = true
end

function LightWave:setArenaSize(width, height)
    self.arena_width = width
    self.arena_height = height or width
end

function LightWave:setArenaPosition(x, y)
    self.arena_x = x
    self.arena_y = y
end

function LightWave:setSoulPosition(x, y)
    self.soul_start_x = x
    self.soul_start_y = y
end

function LightWave:setSoulOffset(x, y)
    self.soul_offset_x = x
    self.soul_offset_y = y
end

function LightWave:getMenuAttackers()
    local result = {}
    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy.selected_menu_wave
        if isClass(wave) and wave.id == self.id or wave == self.id then
            table.insert(result, enemy)
        end
    end
    return result
end

function LightWave:spawnBulletTo(parent, bullet, ...)
    local new_bullet
    if isClass(bullet) and bullet:includes(Bullet) then
        new_bullet = bullet
    elseif Mod.libs["magical-glass"]:getLightBullet(bullet) then
        new_bullet = Mod.libs["magical-glass"]:createLightBullet(bullet, ...)
    else
        local x, y = ...
        table.remove(arg, 1)
        table.remove(arg, 1)
        new_bullet = LightBullet(x, y, bullet, unpack(arg))
    end
    new_bullet.wave = self
    local attackers
    if #Game.battle.menu_waves > 0 then
        attackers = self:getMenuAttackers()
    end
    if #Game.battle.waves > 0 then
        attackers = self:getAttackers()
    end
    if #attackers > 0 then
        new_bullet.attacker = TableUtils.pick(attackers)
    end
    table.insert(self.bullets, new_bullet)
    table.insert(self.objects, new_bullet)
    if parent then
        new_bullet:setParent(parent)
    elseif not new_bullet.parent then
        Game.battle:addChild(new_bullet)
    end
    new_bullet:onWaveSpawn(self)
    if not new_bullet:includes(LightBullet) then
        error("Attempted to use Bullet in a LightBattle. Convert \""..bullet.."\" to a LightBullet")
    end
    return new_bullet
end

return LightWave