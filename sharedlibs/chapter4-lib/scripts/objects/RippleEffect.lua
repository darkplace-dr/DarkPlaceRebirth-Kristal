---@class RippleEffect: Object
local RippleEffect, super = Class(Object)

---@return self
function RippleEffect:MakeRipple(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
    arg2 = arg2 or 60
    arg3 = arg3 or 16159050
    arg4 = arg4 or 160
    arg5 = arg5 or 1
    arg6 = arg6 or 15
    arg7 = arg7 or 1999000
    arg8 = arg8 or 0
    arg9 = arg9 or 0
    arg10 = arg10 or 0.1
    arg3 = Utils.hexToRgb("#"..Utils.sub(string.format("%08X",arg3), 3,8))
    arg3[1], arg3[3] = arg3[3], arg3[1]

    local obj = self(arg0, arg1, arg4, arg5, arg6, arg3, arg8, arg9, arg10, arg2, arg11)
    obj.layer = arg7 and -arg7 or obj.layer
    Game.world:addChild(obj)
    return obj
end

function RippleEffect:applySpeedFrom(obj, scale)
    scale = scale or 1
    self.physics.speed_x = ((obj.x - obj.last_x)/DTMULT)*scale
    self.physics.speed_y = ((obj.y - obj.last_y)/DTMULT)*scale
end

function RippleEffect:init(x, y, radmax, radstart, thickness, color, hsp, vsp, fric, life, curve)
    local obj
    if type(x) == "table" then
        obj = x
        x, y, radmax, radstart, thickness, color, hsp, vsp, fric, life, curve = x.x, x.y, y, radmax, radstart, thickness, color, hsp, vsp, fric, life, curve
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