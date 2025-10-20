---@class RippleEffect: Object
---@overload fun(x, y, life, radmax, thickness, color, hsp, vsp, radstart, fric, curve): RippleEffect
local RippleEffect, super = Class(Object)

---@return self
-- Helper function for porting from Deltarune GML code. Please only use as a placeholder.
function RippleEffect:MakeRipple(x, y, life, color, radmax, radstart, thickness, depth, hsp, vsp, fric, curve)
    depth = depth or 1999000
    color = color or 16159050
    if type(color) == "number" then
        color = Utils.hexToRgb("#"..Utils.sub(string.format("%08X",color), 3,8))
        color[1], color[3] = color[3], color[1]
    end
    local obj = self(x, y, life, radmax, thickness, color, hsp, vsp, radstart, fric, curve)
    obj.layer = depth and -depth or obj.layer
    Game.world:addChild(obj)
    return obj
end

function RippleEffect:applySpeedFrom(obj, scale)
    scale = scale or 1
    self.physics.speed_x = ((obj.x - obj.last_x)/DTMULT)*scale
    self.physics.speed_y = ((obj.y - obj.last_y)/DTMULT)*scale
end

function RippleEffect:init(x, y, life, radmax, thickness, color, hsp, vsp, radstart, fric, curve)
    local obj
    life = life or 60
    radmax = radmax or 160
    radstart = radstart or 1
    thickness = thickness or 15
    hsp = hsp or 0
    vsp = vsp or 0
    fric = fric or 0.1
    if type(x) == "table" then
        obj = x
        x, y, life, radmax, thickness, color, hsp, vsp, radstart, fric, curve = x.x, x.y, y, life, radmax, thickness, color, hsp, vsp, radstart, fric, curve
    end
    super.init(self, x, y)
    if obj then
        self.physics.speed_x = (obj.x - obj.last_x)/DTMULT
        self.physics.speed_y = (obj.y - obj.last_y)/DTMULT
    end
    self.shader = Assets.getShader("ripple")
    self.max_radius = max_radius or 100
    self.rad = radstart
    self.radstart = radstart
    self.life = life
    self.lifemax = self.life
    self.radmax = radmax
    if color then
        self:setColor(color)
    end
    self.physics.speed_x = hsp or self.physics.speed_x
    self.physics.speed_y = vsp or self.physics.speed_y
    self.fric = fric
    self.thickness = thickness
    self.curve = curve or LibTimer.tween["out-quad"]
end

function RippleEffect:update()
    super.update(self)
end

-- TODO: Framerate-independence
function RippleEffect:draw()
    super.draw(self)
    local cx, cy = love.graphics.transformPoint(0,0)
    love.graphics.origin()
    self.shader:send("rippleCenter", {cx,cy})
    self.life = math.max(0, self.life - 1);

    if (self.physics.speed_x > 0) then
        self.physics.speed_x = Utils.approach(self.physics.speed_x, 0, self.fric*DTMULT)
    end

    if (self.physics.speed_y > 0) then
        self.physics.speed_y = Utils.approach(self.physics.speed_y, 0, self.fric*DTMULT)
    end

    self.rad = Utils.lerp(self.radstart, self.radmax, self.curve(1 - (self.life / self.lifemax)));

    if (self.rad > 0) then
        self.shader:send("rippleRad", {self.rad, self.radmax, self.thickness})
        Draw.setColor(self:getDrawColor());
        love.graphics.setShader(self.shader)
        love.graphics.rectangle("fill", 0,0,SCREEN_WIDTH,SCREEN_HEIGHT)
        love.graphics.setShader()
        if (self.life == 0) then
            self:remove()
        end
    end
end

return RippleEffect