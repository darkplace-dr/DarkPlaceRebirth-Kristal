local SoulSlimeSplatter, super = Class(Object)

function SoulSlimeSplatter:init(x, y)
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
end

local function easeOut(value, ease_type)
    if ease_type < -3 or ease_type > 7 then
        return value
    end

    if ease_type == -3 then
        return Utils.ease(0, 1, value, "out-bounce")
    elseif ease_type == -2 then
        return Utils.ease(0, 1, value, "out-elastic")
    elseif ease_type == -1 then
        return Utils.ease(0, 1, value, "out-back")
    elseif ease_type == 0 then
        return value
    elseif ease_type == 1 then
        return math.sin(value * 1.5707963267948966)
    elseif ease_type == 2 then
        return -value * (value - 2)
    elseif ease_type == 6 then
        return -math.pow(2, -10 * value) + 1
    elseif ease_type == 7 then
        value = value - 1
        return math.sqrt(1 - value * value)
    else
        value = value - 1
        if ease_type == 4 then
            return -1 * (math.pow(value, ease_type) - 1)
        end
        return math.pow(value, ease_type) + 1
    end
end

function SoulSlimeSplatter:update()
    super.update(self)

    if self.done then
        return
    end

    if not self._init then
        self._init = true
        
        if self.delay > 0 then
            self.inverse = true
            self.time = self.maxsize
        else
            self.time = 12 - self.maxsize
        end
    end

    if self.delay > 0 then
        self.delay = self.delay - DTMULT
        
        if self.delay <= 0 then
            self:setSpeed(0)
        else
            return
        end
    end

    self.timer = self.timer + DTMULT

    if self.timer >= self.time then
        self.done = true;
        self.timer = self.time;
        self.size = self.maxsize;
    end

    if self.inverse then
        self.size = easeOut(self.timer / self.time, 2) * self.maxsize
    else
        self.size = MathUtils.lerp(self.maxsize + 4, self.maxsize, easeOut(self.timer / self.time, 2))
    end
end

return SoulSlimeSplatter