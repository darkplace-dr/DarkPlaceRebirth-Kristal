local EveningShadowFull, super = Class(Event)

function EveningShadowFull:init(data)
    super.init(self, data)
end

function EveningShadowFull:update()
    super.update(self)
	Object.startCache()
	for _, chara in ipairs(Game.stage:getObjects(Character)) do
		local offset = chara.is_player and 4 or 0
		local collider = PointCollider(chara, chara.width / 2, chara.height - offset)
		if collider:meetsObject(self) then
			chara.selfshadow_override = true
			chara.reset_selfshadow_override = true
		end
	end
	Object.endCache()
end

return EveningShadowFull