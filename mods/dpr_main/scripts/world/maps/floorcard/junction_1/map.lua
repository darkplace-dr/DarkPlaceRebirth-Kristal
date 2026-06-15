local Room1, super = Class(Map)

function Room1:load()
    super.load(self)
	for _,enemy in ipairs(Game.stage:getObjects(ChaserEnemy)) do
		if enemy.sprite.sprite == "overworld" then
			enemy:setWalkSprite("overworld")
		end
	end
end

return Room1