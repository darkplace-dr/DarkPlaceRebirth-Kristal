local map, super = Class(Map)

function map:onEnter()
    super.onEnter(self)
end

function map:onExit()
    super.onExit(self)

    if Game:getFlag("met_stranger") == 1 then
        Game.world:startCutscene("cliffside", "stranger_item")
    end
end

return map