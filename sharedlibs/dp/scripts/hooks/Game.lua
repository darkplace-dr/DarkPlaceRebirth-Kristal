---@class Game : Game
local Game, super = HookSystem.hookScript(Game)

function Game:getConfig(key, merge, deep_merge)

    -- just for Dark Place
    if key == "overworldSpells" then
        return true
    end

    return super.getConfig(self, key, merge, deep_merge)
end

return Game
