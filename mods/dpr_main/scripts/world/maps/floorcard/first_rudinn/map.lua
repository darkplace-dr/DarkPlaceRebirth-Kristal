local Room1, super = Class(Map)

function Room1:load()
    super.load(self)
	if not Game:getFlag("sawFieldMusicLogo", false) then
        Game.world:spawnObject(MusicLogo("field", 180, 100, true), WORLD_LAYERS["ui"])
		Game:setFlag("sawFieldMusicLogo", true)
	end
	for _,enemy in ipairs(Game.stage:getObjects(ChaserEnemy)) do
		if enemy.sprite.sprite == "overworld" then
			enemy:setWalkSprite("overworld")
		end
	end
end

return Room1