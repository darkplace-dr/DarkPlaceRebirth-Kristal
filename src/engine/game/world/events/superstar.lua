local SuperStar, super = Class(Event)

function SuperStar:init(x, y, w, h, properties)
    super.init(self, x, y, 16, 16, properties)
	self:setOrigin(0.5,0.5)
	self:setSprite("world/events/star")
    self.solid = false
end

function SuperStar:onCollide(chara)
    if chara.is_player then
		if chara.inv_timer <= 0 then
			chara.old_song = Game.world.music.current
			Game.world.music:play("starman/" .. Game.party[1]:getStarmanTheme())
		end
        chara.inv_timer = 20
		chara.invincible_colors = true
		self:remove()
    end
end

return SuperStar