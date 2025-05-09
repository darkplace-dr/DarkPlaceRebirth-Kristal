local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)

    local code = Game.world:addFX(ShaderFX("crt", {
        ["time"] = function() return Kristal.getTime() end,
        ["resolution"] = {SCREEN_WIDTH, SCREEN_HEIGHT}
    }), "crt")
end

function map:onExit()
    super.onExit(self)
    Game.world:removeFX("crt")
end

return map