local LenRoom, super = Class(Map)

function LenRoom:onEnter()
	super.onEnter(self)

	if Game:getFlag("gave_red_spear") then
		---@type TileLayer
        local spear = Game.world.map:getTileLayer("spear")
		spear.visible = false
		Game.world.music:play("deltarune/tv_results_screen", 2)
		local tvSnow = TVSnow()
		tvSnow.layer = Game.world.player.layer + 1
		Game.world:addChild(tvSnow)
	elseif Game:getFlag("encounter#dpr_main/lenhoodredspear:done") then
		Game.world.music:play("forgottenbone", 2)
	end
end

return LenRoom