---@class SmashCutAttack : Bullet
---@overload fun(...) : SmashCutAttack
local SmashCutAttack, super = Class(Bullet)

function SmashCutAttack:init(x, y)
    super.init(self, x, y)

    self.tenna = Game.battle:getEnemyBattler("tenna")

    self.collidable = false

    self.timer = 10
    self.timer2 = 12
    self.side = -1
    self.aim_counter = 0

    self.type = 1
    self.difficulty = 0

    self.damage = 92
    self.sideprevious = -2

    self.rumble_loop = Assets.newSound("rumble")
    self.rumble_loop:setVolume(0.5)
    self.rumble_loop:setLooping(true)
end

function SmashCutAttack:onAdd(parent)
    super.onAdd(self, parent)

    if self.tenna then
        local smashcutter = self.wave:spawnObject(ShearySmashCutter(self.x, self.y))
    else
        Assets.playSound("scytheburst")

        local smashcut_manager = self.wave:spawnObject(ShearySmashCutManager(self.x, self.y))
        smashcut_manager:setLayer(BATTLE_LAYERS["above_bullets"])
        Game.battle:shakeCamera()
        self.rumble_loop:play()
    end
end

function SmashCutAttack:getTarget()
    return "ALL"
end

function SmashCutAttack:update()
    super.update(self)

    local old_t = self.timer
    self.timer = self.timer + DTMULT

    local old_t2 = self.timer2
    self.timer2 = self.timer2 + DTMULT

    if (self.timer == ((24 + ((10 - self.difficulty) * self.type)) - (self.difficulty * 2)) and self.type ~= 2) then
        self.timer = 0
        local angle = TableUtils.pick(90, 90, 90, 70, 110)
        local xxx = MathUtils.random(72) - 37
        
        -- for xx = -90, 90 do
        --     scr_fire_bullet(obj_growtangle.x + lengthdir_x(180, angle) + xx + xxx, obj_growtangle.y + lengthdir_y(180, angle), obj_bullet_scissor, angle + 180, 6, spr_scissor_bullet, true, false, 2);
        -- end
    end

    if (self.timer2 == ((25 + (10 * self.type)) - ((3 + self.type) * self.difficulty)) and self.type >= 2) then
        self.side = self.side * -1
        self.timer2 = 0
        --scr_fire_bullet(obj_growtangle.x + (180 * side), obj_growtangle.y + (40 * side), obj_bullet_scissor_big, 90 + (90 * side), 5, spr_scissor_bullet_big, true, false, 3);
    end
end

function SmashCutAttack:draw()
    super.draw(self)
end

function SmashCutAttack:onRemove()
    super.onRemove(self)

    if self.rumble_loop then
        self.rumble_loop:stop()
    end
end

return SmashCutAttack