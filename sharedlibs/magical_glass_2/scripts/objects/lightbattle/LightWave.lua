local LightWave, super = Class(Object)

function LightWave:init()
    super.init(self)

    self.layer = BATTLE_LAYERS["above_bullets"]

    self.arena_x = nil
    self.arena_y = nil

    self.arena_offset_x = nil
    self.arena_offset_y = nil

    self.arena_width = nil
    self.arena_height = nil

    self.arena_shape = nil

    -- lets you change the shape in beforeStart if true
    self.has_arena = true
    self.dont_change_shape = false

    self.has_soul = true

    self.soul_start_x = nil
    self.soul_start_y = nil
    self.soul_offset_x = nil
    self.soul_offset_y = nil

    self.allow_duplicates = false
    self.darken = false

    self.instant_transition_in = false
    self.instant_transition_out = false

    self.clear_on_end = true

    self.time = 5
    self.finished = false

    self.encounter = Game.battle.encounter

    self.bullets = {}
    self.objects = {}

    self.timer = Timer()
    self:addChild(self.timer)
end

function LightWave:update()
    for i = 1, #self.bullets do
        if self.bullets[i] and not self.bullets[i].parent then
            table.remove(self.bullets, i)
            i = i - 1
        end
    end
    super.update(self)
end

function LightWave:onArenaEnter() end
function LightWave:onArenaExit() end

function LightWave:beforeStart() end
function LightWave:onStart() end
function LightWave:onEnd(death) end
function LightWave:beforeEnd() end

function LightWave:canEnd() return true end

function LightWave:clear()
    for _,object in ipairs(self.objects) do
        object:remove()
    end

    self.bullets = {}
    self.objects = {}
end

function LightWave:spawnBullet(bullet, ...)
    return self:spawnBulletTo(nil, bullet, ...)
end

function LightWave:spawnMaskedBullet(bullet, ...)
    return self:spawnBulletTo(Game.battle.arena.mask, bullet, ...)
end

function LightWave:spawnRelativeMaskedBullet(bullet, ...)
    local args = {...}
    local x, y = Game.battle:getRelativePos(args[1], args[2], Game.battle.arena.mask)
    args[1] = x
    args[2] = y
    return self:spawnBulletTo(Game.battle.arena.mask, bullet, unpack(args))
end

function LightWave:spawnBulletTo(parent, bullet, ...)
    local new_bullet
    if isClass(bullet) and bullet:includes(Bullet) then
        new_bullet = bullet
    elseif Registry.getBullet(bullet) then
        new_bullet = Registry.createBullet(bullet, ...)
    else
        local x, y = ...
        table.remove(arg, 1)
        table.remove(arg, 1)
        new_bullet = Bullet(x, y, bullet, unpack(arg))
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
        new_bullet.attacker = Utils.pick(attackers)
    end
    table.insert(self.bullets, new_bullet)
    table.insert(self.objects, new_bullet)
    if parent then
        new_bullet:setParent(parent)
    elseif not new_bullet.parent then
        Game.battle:addChild(new_bullet)
    end
    new_bullet:onWaveSpawn(self)
    return new_bullet
end

function LightWave:spawnSprite(texture, x, y, layer)
    return self:spawnSpriteTo(Game.battle, texture, x, y, layer)
end

function LightWave:spawnMaskedSprite(texture, ...)
    return self:spawnSpriteTo(Game.battle.arena.mask, texture, ...)
end

function LightWave:spawnRelativeMaskedSprite(texture, ...)
    local args = {...}
    local x, y = Game.battle:getRelativePos(args[1], args[2], Game.battle.arena.mask)
    args[1] = x
    args[2] = y
    return self:spawnSpriteTo(Game.battle.arena.mask, bullet, unpack(args))
end

function LightWave:spawnSpriteTo(parent, texture, x, y, layer)
    local sprite = Sprite(texture, x, y)
    sprite:setOrigin(0.5, 0.5)
    sprite:setScale(2)
    sprite.layer = layer or BATTLE_LAYERS["above_arena"]
    return self:spawnObjectTo(parent, sprite)
end

function LightWave:spawnObject(object, x, y)
    return self:spawnObjectTo(Game.battle, object, x, y)
end

function LightWave:spawnMaskedObject(object, ...)
    return self:spawnObjectTo(Game.battle.arena.mask, object, ...)
end

function LightWave:spawnRelativeMaskedObject(object, ...)
    local args = {...}
    local x, y = Game.battle:getRelativePos(args[1], args[2], Game.battle.arena.mask)
    args[1] = x
    args[2] = y
    return self:spawnObjectTo(Game.battle.arena.mask, bullet, unpack(args))
end

function LightWave:spawnObjectTo(parent, object, x, y)
    if x or y then
        object:setPosition(x, y)
    end
    object.wave = self
    parent:addChild(object)
    table.insert(self.objects, object)
    if object.onWaveSpawn then
        object:onWaveSpawn(self)
    end
    return object
end

function LightWave:setArenaPosition(x, y)
    self.arena_x = x
    self.arena_y = y
end

function LightWave:setArenaOffset(x, y)
    self.arena_offset_x = x
    self.arena_offset_y = y
end

function LightWave:setArenaSize(width, height)
    self.arena_width = width
    self.arena_height = height or width
end

function LightWave:setArenaShape(...)
    self.arena_shape = {...}
end

function LightWave:setArenaRotation(rotation)
    self.arena_rotation = rotation
end

function LightWave:setSoulPosition(x, y)
    self.soul_start_x = x
    self.soul_start_y = y

    if Game.battle.soul then
        Game.battle.soul:setExactPosition(x, y)
    end
end

function LightWave:setSoulOffset(x, y)
    self.soul_offset_x = x
    self.soul_offset_y = y

    if Game.battle.soul then
        Game.battle.soul:move(x or 0, y or 0)
    end
end

function LightWave:getAttackers()
    local result = {}
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy.selected_wave
        if type(wave) == "table" and wave.id == self.id or wave == self.id then
            table.insert(result, enemy)
        end
    end
    return result
end

function LightWave:getMenuAttackers()
    local result = {}
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy.selected_menu_wave
        if type(wave) == "table" and wave.id == self.id or wave == self.id then
            table.insert(result, enemy)
        end
    end
    return result
end

function LightWave:canDeepCopy()
    return false
end

return LightWave