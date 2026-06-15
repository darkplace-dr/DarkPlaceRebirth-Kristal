local MathUtils = setmetatable({}, {__index = MathUtils})

function MathUtils.easeOutAccurate(value, ease_type)
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

function MathUtils.easeInAccurate(value, ease_type)
    if ease_type < -3 or ease_type > 7 then
        return value
    end

    if ease_type == -3 then
        return Utils.ease(0, 1, value, "in-bounce")
    elseif ease_type == -2 then
        return Utils.ease(0, 1, value, "in-elastic")
    elseif ease_type == -1 then
        local s = 1.70158
        return value * value * (((s + 1) * value) - s)
    elseif ease_type == 0 then
        return value
    elseif ease_type == 1 then
        return -math.cos(value * 1.5707963267948966) + 1
    elseif ease_type == 6 then
        return math.pow(2, 10 * (value - 1))
    elseif ease_type == 7 then
        return -(math.sqrt(1 - value * value) - 1)
    else
        return math.pow(value, ease_type)
    end
end

function MathUtils.easeInOutAccurate(value, ease_type)
    if ease_type < -3 or ease_type > 7 then
        return value
    end

    if ease_type == -3 then
        return Utils.ease(0, 1, value, "in-out-bounce")
    elseif ease_type == -2 then
        return Utils.ease(0, 1, value, "in-out-elastic")
    elseif ease_type == -1 then
        return Utils.ease(0, 1, value, "in-out-back")
    elseif ease_type == 0 then
        return value
    elseif ease_type == 1 then
        return -0.5 * math.cos((math.pi * value) - 1)
    end

    value = value * 2
    if value < 1 then
        return 0.5 * MathUtils.easeInAccurate(value, ease_type)
    else
        value = value - 1
        return 0.5 * (MathUtils.easeOutAccurate(value, ease_type) + 1)
    end
end

function MathUtils.lerpEaseOut(from, to, value, ease_type)
    return MathUtils.lerp(from, to, MathUtils.easeOutAccurate(value, ease_type))
end

function MathUtils.lerpEaseIn(from, to, value, ease_type)
    return MathUtils.lerp(from, to, MathUtils.easeInAccurate(value, ease_type))
end

function MathUtils.lerpEaseInOut(from, to, value, ease_type)
    return MathUtils.lerp(from, to, MathUtils.easeInOutAccurate(value, ease_type))
end

function MathUtils.lengthDirX(length, dir)
    return math.cos(-dir) * length
end

function MathUtils.lengthDirY(length, dir)
    return math.sin(-dir) * length
end

function MathUtils.approachCurve(val, target, amount)
    local t = 0.1
    return MathUtils.approach(val, target, math.max(t, math.abs(target - val) / amount))
end

function MathUtils.approachCurveDTMULT(val, target, amount)
    return MathUtils.approach(val, target, math.max(0.1, math.abs(target - val) / amount) * DTMULT)
end

function MathUtils.rotateTowards(a, b, t)
    local diff = MathUtils.angleDiff(b, a)
    if (math.abs(diff) > t) then
        return a + (MathUtils.sign(diff) * t)
    else
        return b
    end
end

function MathUtils.angleLerp(a, b, t)
    local diff = MathUtils.angleDiff(b, a)
    return a + MathUtils.lerp(0, diff, t)
end

return MathUtils
