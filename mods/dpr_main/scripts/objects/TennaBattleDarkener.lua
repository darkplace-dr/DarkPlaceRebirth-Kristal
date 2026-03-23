local TennaBattleDarkener, super = Class(BattleDarkener)

function TennaBattleDarkener:init()
    super.init(self)
end

function TennaBattleDarkener:update()
    super.update(self)
    local tenna_bg = Game.stage:getObjects(TennaBattleBackground)[1]
	if tenna_bg then
		tenna_bg.dark_amount = self.dark_amount
	end
end

function TennaBattleDarkener:draw()
end

return TennaBattleDarkener
