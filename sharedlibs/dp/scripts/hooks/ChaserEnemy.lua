---@class ChaserEnemy : ChaserEnemy
local ChaserEnemy, super = Utils.hookScript(ChaserEnemy)

function ChaserEnemy:onCollide(player)
    if player.invincible_colors then
        self:explode()
        return
    end
    return super.onCollide(self, player)
end

function ChaserEnemy:getBackFace()
    local player = Game.world.player
    if player.facing == "right" then
        return "left"
    elseif player.facing == "left" then
        return "right"
    elseif player.facing == "up" then
        return "down"
    elseif player.facing == "down" then
        return "up"
    end
end

return ChaserEnemy