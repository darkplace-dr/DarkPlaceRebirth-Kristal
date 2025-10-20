local Deoxtest, super = Class(Map)

function Deoxtest:onEnter()
    super.onEnter(self)

	if Game:getFlag("acj_switch_pressed") then
		Game.world.map:getTileLayer("TilesToRemove").visible = false
		Game.world.map:getTileLayer("AnotherLayerToRemove").visible = false
		Game.world.map:getHitbox("collision_to_remove").collidable = false
	end
end

return Deoxtest
