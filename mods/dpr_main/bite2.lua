local Bite, super = Class(Wave)

function Bite:init()
    super.init(self)

    -- Initialize timer
    self.siner = 0
    self.time = 10
end

function Bite:onStart()
    -- Get the arena object
        self.timer:every(1/3, function()
        -- Our X position is offscreen, to the right
        local y = SCREEN_HEIGHT + 20
        -- Get a random Y position between the top and the bottom of the arena
        local x = Utils.random(Game.battle.arena.left, Game.battle.arena.right)

        -- Spawn smallbullet going left with speed 8 (see scripts/battle/bullets/smallbullet.lua)
        local bullet = self:spawnBullet("tailofhell", x, y, math.rad(180), 8)
		if Game.battle.encounter.volume_up then
			bullet:setScale(0.25)
			bullet.tp = 6.4
		end
        -- Dont remove the bullet offscreen, because we spawn it offscreen
        bullet.remove_offscreen = false
    local arena = Game.battle.arena

    -- Spawn spikes on top of arena
    self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 - 60, 0, math.rad(0))
    self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 - 30, 0, math.rad(0))
    self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2, 0, math.rad(0))
    self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 + 30, 0, math.rad(0))
    self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 + 60, 0, math.rad(0))

    -- Spawn spikes on bottom of arena (rotated 180 degrees)
    self.skull = self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 - 60, arena.height, math.rad(180))
    self.skull = self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 - 30, arena.height, math.rad(180))
    self.skull = self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2, arena.height, math.rad(180))
    self.skull = self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 + 30, arena.height, math.rad(180))
    self.skull = self:spawnBulletTo(Game.battle.arena, "teeth", arena.width / 2 + 60, arena.height, math.rad(180))

    -- Store starting arena position
    self.arena_start_x = arena.x
    self.arena_start_y = arena.y
    self.timer:after(love.math.random(3, 8), function(wait)
    self.x_offset = 0 
    self.y_offset = 0
end)
end)
end

function Bite:update()
    -- Increment timer for arena movement
    self.siner = self.siner + DT

    -- Calculate the arena Y offset
    self.y_offset = math.sin(self.siner * 1.5) * 60
    self.x_offset = math.cos(self.siner * 1.5) * 60

    -- Move the arena
    Game.battle.arena:setPosition(self.arena_start_x + self.x_offset, self.arena_start_y + self.y_offset)
end

return Bite
