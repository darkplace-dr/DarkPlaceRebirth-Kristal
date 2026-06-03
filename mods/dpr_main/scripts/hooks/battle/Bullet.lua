---@class Bullet : Bullet
local Bullet, super = HookSystem.hookScript(Bullet)

function Bullet:onGraze(first)
	super.onGraze(self, first)

    local tenna = Game.battle:getEnemyBattler("tenna")

	if tenna and first then
		tenna:addScore(1)
	end
end

return Bullet