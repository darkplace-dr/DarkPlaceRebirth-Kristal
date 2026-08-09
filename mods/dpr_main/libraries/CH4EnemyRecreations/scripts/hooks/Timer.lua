local Timer, super = Utils.hookScript(Timer)

---@alias ease_in_out
---| "in"
---| "out"
---| "inout"

--- A port of scr_lerpvar()/scr_lerpvar_instance from Deltarune's code.
--- Credit to HmmNoPls for originally porting this function to Dark Place: REBIRTH.
---@param target        table           The object to be tweened.
---@param key           string          The key of the `subject` table.
---@param from          number          The starting value of the key.
---@param to            number          The target value of the key.
---@param max_time      number          The duration of the tween in frames at 30 FPS.
---@param ease_type     number          A number between -3 to 7 determining the ease type.
---@param ease_in_out   ease_in_out     A string determining whether the ease is in, out, or in out.
---@return table handle
function Timer:lerpVar(target, key, from, to, max_time, ease_type, ease_in_out)
    local time = 0
    return self:during(math.huge, function ()
        time = time + DTMULT
        local factor = math.min(1, time / max_time)
        if ease_type == nil or ease_type == 0 then
            target[key] = MathUtils.lerp(from, to, factor)
        else
            if ease_in_out == "out" then
                target[key] = MathUtils.lerpEaseOut(from, to, factor, ease_type)
            elseif ease_in_out == "in" then
                target[key] = MathUtils.lerpEaseIn(from, to, factor, ease_type)
            elseif ease_in_out == "inout" then
                target[key] = MathUtils.lerpEaseInOut(from, to, factor, ease_type)
            end
        end
        if time >= max_time then
            return false
        end
    end)
end

return Timer
