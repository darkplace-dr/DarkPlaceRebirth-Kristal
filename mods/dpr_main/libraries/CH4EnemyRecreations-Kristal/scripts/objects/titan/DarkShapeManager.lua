---@class DarkShapeManager : Object
---@overload fun(...) : DarkShapeManager
local DarkShapeManager, super = Class(Object)

function DarkShapeManager:init(x, y)
    super.init(self, 0, 0)

    self.pattern = "default"

    self.aim_var = 0
    self.dark_count = 0
    self.basic_shapes = true
    self.noise_played = false

    self.angery = true
    self.timer = 17
    self.timer_alt = 3
    self.timer_alt_goal = 36
    self.speedup_timer = 0
    self.random_offset = MathUtils.randomInt(360)
    self.spawn_counter = 0

    if Game.battle.soul then
        self:setLayer(Game.battle.soul.layer - 1)
    end

    self.its_time = false

    self.barrage_offset = 40
    self.barrage_interval = 40
    self.barrage_end = 64
    self.phase_difficulty = 1
end

function DarkShapeManager:onAdd(parent)
    super.onAdd(self, parent)

    self.spawn_attack_loop = Assets.newSound("spawn_attack")
    self.spawn_attack_loop:setLooping(true)
end

function DarkShapeManager:onRemove(parent)
    super.onRemove(self, parent)

    if Game.battle.soul.omnious_loop then
        Game.battle.soul.omnious_loop:stop()
    end

    self.spawn_attack_loop:stop()
end

function DarkShapeManager:onRemoveFromStage(stage)
    super.onRemoveFromStage(self, stage)

    if Game.battle.soul.omnious_loop then
        Game.battle.soul.omnious_loop:stop()
    end

    self.spawn_attack_loop:stop()
end

function DarkShapeManager:patternToUse(pattern)
    self.pattern = pattern or "default"
    return self.pattern
end

-- This ONLY includes the attack patterns that are used by the Titan Spawn enemies.
-- Any attack patterns used by the Titan *boss* have been excluded from this object for obvious reasons.
function DarkShapeManager:createPattern()
    if self.pattern == "default" then
        if not self.noise_played then
            self.spawn_attack_loop:play()
            self.noise_played = true
        end

        if (self.timer % 12) == 0 then
            local tempdir = MathUtils.randomInt(360)
            local tempdist = 150 + MathUtils.randomInt(50)
            local x, y = Game.battle.arena.x + MathUtils.lengthDirX(tempdist, math.rad(tempdir)), Game.battle.arena.y + MathUtils.lengthDirY(tempdist, math.rad(tempdir))

            if (self.spawn_counter % 5) == 4 then
                local newbullet = self.wave:spawnBullet("titan/redshape", x, y)
                newbullet.physics.direction = MathUtils.angle(newbullet.x, newbullet.y, Game.battle.soul.x, Game.battle.soul.y)
                newbullet.rotation = newbullet.physics.direction
            else
                local newbullet = self.wave:spawnBullet("titan/darkshape", x, y)
            end

            self.spawn_counter = self.spawn_counter + 1
        end

    elseif self.pattern == "intro" then
        if not self.noise_played then
            self.spawn_attack_loop:play()
            self.noise_played = true
        end

        if (self.timer % 24) == 0 then
            local tempdir = MathUtils.randomInt(360)
            local tempdist = 150 + MathUtils.randomInt(50)
            local x, y = Game.battle.arena.x + MathUtils.lengthDirX(tempdist, math.rad(tempdir)), Game.battle.arena.y + MathUtils.lengthDirY(tempdist, math.rad(tempdir))

            local newbullet = self.wave:spawnBullet("titan/darkshape", x, y)
            newbullet:setScale(0.85, 0.85)
            newbullet.scalefactor = 0.85

            self.spawn_counter = self.spawn_counter + 1
        end

    elseif self.pattern == "speedup" then
        if not self.noise_played then
            self.spawn_attack_loop:play()
            self.noise_played = true
        end

        self.timer_alt = self.timer_alt + DTMULT
        self.speedup_timer = self.speedup_timer + DTMULT

        if (self.timer % 16) == 0 then
            self.timer_alt = self.timer_alt - math.floor((self.timer_alt_goal * 0.5) + MathUtils.random(self.timer_alt_goal))
            self.timer_alt_goal = MathUtils.approach(self.timer_alt_goal, 20, 4*DTMULT)
            local tempdir = self.random_offset + math.deg(math.tan(self.speedup_timer * 0.0375))
            if MathUtils.randomInt(8) ~= 0 then
                tempdir = tempdir + 180
            end
            local tempdist = 120 + MathUtils.randomInt(50)
            local x, y = Game.battle.arena.x + MathUtils.lengthDirX(tempdist, math.rad(tempdir)), Game.battle.arena.y + MathUtils.lengthDirY(tempdist, math.rad(tempdir))

            if (self.spawn_counter % 5) == 4 then
                local newbullet = self.wave:spawnBullet("titan/redshape", x, y)
                newbullet.physics.direction = MathUtils.angle(newbullet.x, newbullet.y, Game.battle.soul.x, Game.battle.soul.y)
                newbullet.rotation = newbullet.physics.direction
            else
                local newbullet = self.wave:spawnBullet("titan/darkshape", x, y)
            end

            self.spawn_counter = self.spawn_counter + 1
        end
    end
end

function DarkShapeManager:update()
    self.timer = self.timer + DTMULT

    if Game.battle.wave_timer >= Game.battle.wave_length - 1/30 then
        self.its_time = true
        self:remove()
    end

    if not self.its_time then
        self:createPattern()
    end

    super.update(self)
end

return DarkShapeManager