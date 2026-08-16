local SuperStar, super = Class(Event)

function SuperStar:init(x, y, properties)
    super.init(self, x, y)
	self:setOrigin(0.5, 0.5)
	self:setSprite("world/events/star")
    self.solid = false

	self.inv_frames = properties["inv_frames"] or 20
end

function SuperStar:onCollide(chara)
    if chara.is_player then
		if not Game:hasInvulnerability() then
			chara.old_song = Game.world.music.current
			Game.world.music:play("starman/" .. Game.party[1]:getStarmanTheme())
		end
        Game:setInvulnFrames(self.inv_frames)
		chara.invincible_colors = true
		self:remove()
    end
end

return SuperStar