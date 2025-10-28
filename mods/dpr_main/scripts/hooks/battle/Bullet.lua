local Bullet, super = Utils.hookScript(Bullet)

function Bullet:onGraze(first)
	super.onGraze(self, first)
	if Game.battle.encounter.addscore and first then
		Game.battle.encounter:addScore(self.graze_score or 1)
	end
end

return Bullet