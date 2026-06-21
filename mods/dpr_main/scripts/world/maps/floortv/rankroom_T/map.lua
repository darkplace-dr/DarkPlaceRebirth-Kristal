local RankT, super = Class(Map)

function RankT:load()
	super.load(self)

	if Game:getFlag("can_kill", false) then return end

	self.screenController = Game.world:getEvent("teevie_tvs")

	for i = 1, self.screenController.tv_columns do
		for j,screen in ipairs(self.screenController.tv_screens[i]) do
			self.screenController:setStatic(screen)
			screen.con = 6
		end
	end
end

function RankT:update()
	super.update(self)
	if Game:getFlag("can_kill", false) then return end

	for i = 1, self.screenController.tv_columns do
		for j,screen in ipairs(self.screenController.tv_screens[i]) do
			if math.abs(screen.timer) % 2 == 0 then
				screen.frame = screen.frame + 1
			end
		end
	end
end

return RankT