---@class Cutscene:Cutscene
local Cutscene, super = HookSystem.hookScript(Cutscene)

--- Temporarily suspends execution of the cutscene script until multiple functions all return true.
---@param ... fun():boolean Any amount of functions that returns a function for wait().
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

--- Runs `func` if `cond` is true
---@param cond boolean? A condition that returns true or false.
---@param func fun(Cutscene:self, ...) A custom function that will be ran if `cond` if true.
---@param ... any Any other arguments for `func`
function Cutscene:runIf(cond, func, ...)
    if cond then
        func(self, ...)
    end
end

---@param obj Object The object to explode
---@param ... any Other arguments to pass to Object.explode
---@return fun():boolean finished Returns `true` when the explosion has disappeared.
---@see Object.explode
function Cutscene:explode(obj, ...)
    local e = obj:explode(...)
    return function() return e.parent == nil end
end

return Cutscene