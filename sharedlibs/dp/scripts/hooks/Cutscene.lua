local Cutscene, super = HookSystem.hookScript(Cutscene)

--- Temporarily suspends execution of the cutscene script until multiple functions all return true.
---@param ... function Any amount of functions that returns a function for wait().
---@see Cutscene.wait
---@return any ... Any values passed into the adjacent Cutscene:resume(...) call. 
function Cutscene:waitMultiple(...)
    local waitholder = {...}
    self.wait_func = function()
        for i,wait in ipairs(waitholder) do
            if not wait() then
                return false
            end
        end
        return true
    end

    return coroutine.yield()
end

function Cutscene:runIf(cond, func)
    if cond then
        func(self)
    end
end

return Cutscene