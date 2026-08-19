---@class Actor : Actor
local Actor, super = HookSystem.hookScript(Actor)

function Actor:onSpriteInit(sprite)
	--This breaks shopkeeper actors. Maybe find a better fix later?
    --[[if not self:getAnimation("jump_ball_slow") and self:getAnimation("jump_ball") then
        self.animations["jump_ball_slow"] = self:getAnimation("jump_ball")
    end]]
    super.onSpriteInit(self, sprite)
end

return Actor