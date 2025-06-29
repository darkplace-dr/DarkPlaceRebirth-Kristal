local TennaRoom, super = Class(Map)

function TennaRoom:load()
    super.load(self)

    local tenna = Game.world:getCharacter("tenna")
    if Game:getFlag("can_kill", true) then
        tenna:setSprite("sad")
        tenna.actor:setPreset(0)
    else
        tenna.actor:setPreset(23)
    end
end

function TennaRoom:onExit()
    super.onExit(self)
end

return TennaRoom