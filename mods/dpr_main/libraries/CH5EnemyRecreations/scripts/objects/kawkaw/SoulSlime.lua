local SoulSlime, super = Class(Object)

function SoulSlime:init(x, y)
    super.init(self, x, y)

    self.surf = nil
    self.persistent_surf = nil

    self.heartx, self.hearty = Game.battle.soul.x, Game.battle.soul.y
    self.heart_hspeed = 0
    self.heart_vspeed = 0

    self.timer = 0
    self.siner = 0
    self.hitspeed = 1
    self.size = 10
    self.trailx = 0
    self.traily = 0
    self.dripleft = 0
    self.dripright = 0
    self.dripper = 1
    self.splatter = false
end

function SoulSlime:onAdd(parent)
    super.onAdd(self, parent)
end

function SoulSlime:update()
    self:setLayer(BATTLE_LAYERS["arena"] + 1)

    if Game.battle.arena then
        self.x = (Game.battle.arena.x - 70) + 1
        self.y = (Game.battle.arena.y - 70) + 1
    end

    if self.heartx ~= Game.battle.soul.x or self.hearty ~= Game.battle.soul.y then
        self.heart_hspeed = MathUtils.approach(self.heart_hspeed, Game.battle.soul.x - self.heartx, DTMULT)
        self.heart_vspeed = MathUtils.approach(self.heart_vspeed, Game.battle.soul.y - self.hearty, DTMULT)
        self.heartx = Game.battle.soul.x
        self.hearty = Game.battle.soul.y
        self.timer = self.timer - DTMULT
    else
        self.heart_hspeed = 0
        self.heart_vspeed = 0
    end

    for _, soul in ipairs(Game.stage:getObjects(Soul)) do
        if soul:onDamage() then
            self.hitspeed = 8
            DebuggingUtils.print("heart hit")

            local _count = MathUtils.randomInt(4+1, 7+1)
            local _st = MathUtils.random(360)
            local _a = 360 / _count
            local _devi = _a * (1/3)
            local _slime = self.splatter and SoulSlimeSplatter or SoulSlimeDrop

            if self.splatter then
                local _drop = Game.battle:addChild(_slime(Game.battle.soul.x, Game.battle.soul.y))
                _drop.maxsize = MathUtils.randomInt(6+1, 8+1)
                _drop.size = _drop.maxsize / 2
            end

            for i = 0, _count-1 do
                local _drop = Game.battle:addChild(_slime(Game.battle.soul.x, Game.battle.soul.y))
                local _speed = self.splatter and MathUtils.random(6, 10) or MathUtils.random(4, 8)
                _drop.physics.direction = -math.rad((i * _a) + MathUtils.random(-20, 20) + _st)
                _drop.delay = 1
                _dropsetSpeed(_speed)
                _drop.maxsize = MathUtils.randomInt(6+1, 8+1)
                _drop.size = _drop.maxsize / 2

                if not self.splatter then
                    _drop.physics.gravity = 0.5
                end

                _drop = Game.battle:addChild(_slime(Game.battle.soul.x, Game.battle.soul.y))
                _drop.physics.direction = -math.rad((i * _a) + MathUtils.random(-20, 20) + _st)
                _drop.delay = 2
                _dropsetSpeed(_speed)
                _drop.maxsize = MathUtils.randomInt(4+1, 6+1)
                _drop.size = _drop.maxsize / 2

                if not self.splatter then
                    _drop.physics.gravity = 0.5
                end

                if self.splatter then
                    _drop = Game.battle:addChild(_slime(Game.battle.soul.x, Game.battle.soul.y))
                    _drop.physics.direction = -math.rad((i * _a) + MathUtils.random(-20, 20) + _st)
                    _drop.delay = 3
                    _dropsetSpeed(_speed)
                    _drop.maxsize = MathUtils.randomInt(2+1, 3+1)
                    _drop.size = _drop.maxsize / 2
                end
            end
        end
    end

    super.update(self)
end

function SoulSlime:drawSelf()
    for _, wave in ipairs(Game.battle.waves) do
        if wave:onEnd() or not Game.battle.soul then
            self:remove()
            return
        end
    end

    local _init = false
    local _slime = self.splatter and SoulSlimeSplatter or SoulSlimeDrop

    if self.surf == nil then
        self.surf = love.graphics.newCanvas(140, 140)
    end

    if self.persistent_surf == nil then
        self.persistent_surf = love.graphics.newCanvas(140, 140)
        local persistent_canvas = Draw.pushCanvas(self.persistent_surf)
        love.graphics.clear(0,0,0,0)
        Draw.popCanvas(true)
    end

    love.graphics.setBlendMode("add")
    local persistent_canvas = Draw.pushCanvas(self.persistent_surf)

    for _, slime in ipairs(Game.stage:getObjects(_slime)) do
        if slime.done then
            Draw.setColor(1, 1, 1, 0)
            love.graphics.ellipse("fill", slime.x - self.x, slime.y - self.y, self.size, self.size)
            slime:remove()
        end
    end

    Draw.popCanvas(true)
    local canvas = Draw.pushCanvas(self.surf)
    love.graphics.clear(0,0,0,0)
    Draw.drawCanvas(self.persistent_surf, 0, 0)

    for _, slime in ipairs(Game.stage:getObjects(_slime)) do
        Draw.setColor(1, 1, 1, 0)
        love.graphics.ellipse("fill", slime.x - self.x, slime.y - self.y, self.size, self.size)
    end

    self.siner = self.siner + self.hitspeed * DTMULT

    if self.hitspeed > 1 then
        self.hitspeed = MathUtils.approach(self.hitspeed, 1, 0.1*DTMULT)
    end

    local _hx = (Game.battle.soul.x - self.x) - MathUtils.clamp(self.heart_hspeed, -1, 1)
    local _hy = (Game.battle.soul.y - self.y) - MathUtils.clamp(self.heart_vspeed, -1, 1)
    local _sizer = 0

    if self.hitspeed ~= 0 then
        _sizer = 3 * (2 / self.hitspeed)
    end

    --DebuggingUtils.print("heartspeed: " .. tostring(self.heart_hspeed) .. ", " .. tostring(self.heart_vspeed))
    _hx = (Game.battle.soul.x - self.x) - self.heart_hspeed
    _hy = (Game.battle.soul.y - self.y) - self.heart_vspeed
    self.dripper = self.dripper + ((2 * (self.hitspeed - self.heart_vspeed)) / 2) * DTMULT

    Draw.draw(Assets.getTexture("player/heart_dodge"), _hx + 10, _hy + 10, 0, 1.2 + (math.sin(self.siner / 10) * 0.1), 1.2 + (math.cos(self.siner / 10) * 0.1))
    love.graphics.ellipse("fill", _hx - (math.sin(self.dripper / 10) * 2) - 4, (_hy - (math.cos((self.dripper - 4) / 10) * 5)) + 1, ((math.sin((self.dripper + 3) / 10) / 2) + 1) * _sizer, ((math.sin((self.dripper + 3) / 10) / 2) + 1) * _sizer)
    love.graphics.ellipse("fill", _hx + (math.cos(self.dripper / 10) * 2) + 2, _hy + (math.sin((self.dripper - 4) / 10) * 5) + 1, ((math.cos((self.dripper + 3) / 10) / 2) + 1) * _sizer, ((math.cos((self.dripper + 3) / 10) / 2) + 1) * _sizer)

    Draw.popCanvas(true)
    love.graphics.setBlendMode("alpha")

    local last_shader = love.graphics.getShader()
    local shader = Kristal.Shaders["AddColor"]
    love.graphics.setShader(shader)
    shader:send("inputcolor", ColorUtils.hexToRGB("#666666"))
    shader:send("amount", 1)

    Draw.setColor(COLORS.gray[1], COLORS.gray[2], COLORS.gray[3], 1)
    Draw.drawCanvas(self.surf, self.x, self.y - 1, 0, 1, 1)
    Draw.drawCanvas(self.surf, self.x, self.y + 1, 0, 1, 1)
    Draw.drawCanvas(self.surf, self.x + 1, self.y, 0, 1, 1)
    Draw.drawCanvas(self.surf, self.x - 1, self.y, 0, 1, 1)

    love.graphics.setShader(last_shader)

    Draw.setColor(0, 0, 0, 1)
    Draw.drawCanvas(self.surf, self.x, self.y, 0, 1, 1)
end

function SoulSlime:onRemoveFromStage(stage)
    super.onRemove(self, stage)

    if self.surf then
        self.surf:release()
    end

    if self.persistent_surf then
        self.persistent_surf:release()
    end

    for _, drop in ipairs(Game.stage:getObjects(SoulSlimeDrop)) do
        drop:remove()
    end
end

return SoulSlime