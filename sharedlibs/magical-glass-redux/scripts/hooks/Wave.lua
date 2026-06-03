local Wave, super = HookSystem.hookScript(Wave)

function Wave:spawnBulletTo(parent, bullet, ...)
    local new_bullet = super.spawnBulletTo(self, parent, bullet, ...)

    if new_bullet:includes(LightBullet) then
        error("Attempted to use LightBullet in a DarkBattle. Convert \"" .. bullet .. "\" to a Bullet")
    end

    return new_bullet
end

return Wave