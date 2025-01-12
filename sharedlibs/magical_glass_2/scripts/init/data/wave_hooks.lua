--[[ Utils.hook(Wave, "init", function(orig, self)
    orig(self)

    self.allow_duplicates = false

    self.instant_transition = false

    self.has_soul = true
    self.darken = false
    self.clear_on_end = true
end)

Utils.hook(Wave, "setArenaSize", function(orig, self, width, height)
    if Game.battle.light then
        self.arena_width = width
        self.arena_height = height or width
    else
        orig(self, width, height)
    end
end)

Utils.hook(Wave, "setArenaPosition", function(orig, self, x, y)
    if Game.battle.light then
        self.arena_x = x
        self.arena_y = y
    else
        orig(self, x, y)
    end
end)

Utils.hook(Wave, "getMenuAttackers", function(orig, self)
    local result = {}
    for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
        local wave = enemy.selected_menu_wave
        if type(wave) == "table" and wave.id == self.id or wave == self.id then
            table.insert(result, enemy)
        end
    end
    return result
end)
 ]]
--[[ Utils.hook(Wave, "spawnBulletTo", function(orig, self, parent, bullet, ...)
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
    if MagicalGlass:get and #Game.battle.menu_waves > 0 then
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
end) ]]

--[[ Utils.hook(Wave, "spawnMaskedBullet", function(orig, self, bullet, ...)
    local x, y = ...
    table.remove(arg, 1)
    table.remove(arg, 1)

    x, y = 

    return self:spawnBulletTo(Game.battle.arena.mask, bullet, unpack(arg))
end) ]]