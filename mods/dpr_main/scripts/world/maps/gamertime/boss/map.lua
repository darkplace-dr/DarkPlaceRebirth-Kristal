local Boss, super = Class(Map)

function Boss:onEnter()
    super.onEnter(self)

    Game.world:startCutscene("gamertime", "boss")
end

return Boss
