local TennaRoom, super = Class(Map)

function TennaRoom:load()
    super.load(self)

    local tenna = Game.world:getCharacter("tenna")
    if Game:getFlag("can_kill") == true then
        tenna.sprite:setPreset(0)
        tenna:setAnimation("pose_headlowered_nose")
    else
        tenna.sprite:setPreset(24)
    end
end

function TennaRoom:onExit()
    super.onExit(self)
end

return TennaRoom