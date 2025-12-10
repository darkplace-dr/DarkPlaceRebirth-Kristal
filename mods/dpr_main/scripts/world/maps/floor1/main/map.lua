local MainHub, super = Class(Map)

function MainHub:onEnter()
    super.onEnter(self)
    if DTRANS then
        Game.world:startCutscene("darkenter")
    end

    local sans = Game.world:getCharacter("sans")
    if sans then
        if Game:getFlag("hasPushedSans") then
            sans.x = 545
        else
            sans.x = 465
        end
    end
end

return MainHub