---@class OverworldSoul : OverworldSoul
local OverworldSoul, super = HookSystem.hookScript(OverworldSoul)

function OverworldSoul:init(x, y)
    super.init(self, x, y)

    self.sprite:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart_dodge")

    -- Diamond shield variables start here
    self.glow_alpha = 0
    self.glow_alpha_increase = 0.1
    -- Diamond shield variables end here
end

function OverworldSoul:update()
    super.update(self)

    -- Diamond shield code starts here
    if not Game:hasInvulnerability() and Game.pp > 0 and Game.world.battle_alpha > 0 then
        self.glow_alpha = self.glow_alpha + self.glow_alpha_increase * DTMULT
        if self.glow_alpha >= 1 then
            self.glow_alpha = 1
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
        if self.glow_alpha <= 0 then
            self.glow_alpha = 0
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
    else
        self.glow_alpha = 0
        self.glow_alpha_increase = math.abs(self.glow_alpha_increase)
    end
    -- Diamond shield code ends here
end

function OverworldSoul:draw()
    super.super.draw(self)

    local glow_w, glow_h = self.sprite:getTexture():getWidth(), self.sprite:getTexture():getHeight()
    local scale_x, scale_y = self.sprite.scale_x, self.sprite.scale_y
    love.graphics.setColor(1, 1, 1, self.glow_alpha * Game.world.battle_alpha)
    love.graphics.draw(self.sprite:getTexture(), -glow_w/2 * scale_x, -glow_h/2 * scale_y, 0, scale_x, scale_y)
    love.graphics.setColor(1, 1, 1, 1)

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
    end
end

return OverworldSoul