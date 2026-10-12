local SoulSlimeDrop, super = Class(Object)

function SoulSlimeDrop:init(x, y)
    super.init(self, x, y)

    self.maxsize = 8
    self.sizer = 2
    self.size = 2
    self.done = false
    self.delay = 0
    self.inverse = false
    self.timer = 0
    self.time = 10
    self._init = false
    self.height = 1
    self.width = 1
    self.floorhit = false
    self.wallhit = false
    self.lastx = {}
    self.lasty = {}
end

local function moveTowards(a, b, t)
    if (a == b) then
        return a
    elseif (a > b) then
        return math.max(a - t, b)
    else
        return math.min(a + t, b)
    end
end

function SoulSlimeDrop:update()
    super.update(self)

    if not self._init then
        self.lastx[1] = self.x
        self.lasty[1] = self.y
        self.lastx[2] = self.x
        self.lastx[2] = self.y
    end

    if self.floorhit then
        self.height = moveTowards(self.height, 0.5, 0.1*DTMULT)
        self.width = moveTowards(self.width, 2, 0.1*DTMULT)
        self.physics.gravity = 0.1
        
        if (self.y - self.height) > (Game.battle.arena.y + 80) then
            self:remove()
        end
        
        return
    else
        self.lastx[2] = self.lastx[1]
        self.lasty[2] = self.lasty[1]
        self.lastx[1] = self.x
        self.lasty[1] = self.y
    end

    if self.y > (Game.battle.arena.y + 70) then
        self.y = Game.battle.arena.y + 70
        
        if self.wallhit then
            if self.x < Game.battle.arena.x then
                self.physics.speed_x = self.physics.speed_y
            else
                self.physics.speed_x = -self.physics.speed_y
            end
        end
        
        self.physics.speed_y = 0
        self.physics.gravity = 0.1
        self.physics.speed_x = self.physics.speed_x / 2
        self.physics.friction = 0.2
        self.rotation = -math.rad(0)
        self.width = self.x
        self.floorhit = true
    end

    if self.y < (Game.battle.arena.y - 71) and self.physics.speed_y < 0 then
        self.physics.speed_y = 0
        self.physics.friction = 0.2
        self.physics.gravity = 0.1
        self.y = Game.battle.arena.y - 71
    end

    if not self.wallhit and self.physics.gravity < 0.5 and self.physics.speed_y > 0 and self.y > ((Game.battle.arena.y - 70) + (self.height / 2)) then
        self.physics.gravity = 0.5
        self.physics.friction = 0
    end

    if not self.floorhit and (self.x < (Game.battle.arena.x - 70) or self.x > (Game.battle.arena.x + 70)) then
        self.physics.speed_x = 0
        self.physics.speed_y = self.physics.speed_y / 2
        
        if self.x < Game.battle.arena.x then
            self.x = Game.battle.arena.x - 70
        else
            self.x = Game.battle.arena.x + 70
        end
        
        self.physics.gravity = 0.5
        self.physics.friction = 0.3
        self.wallhit = true
    end
end

return SoulSlimeDrop