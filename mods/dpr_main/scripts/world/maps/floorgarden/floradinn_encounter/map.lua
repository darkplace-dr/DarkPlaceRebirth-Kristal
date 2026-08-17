local Room1, super = Class(Map)

function Room1:init(world, data)
	super.init(self, world, data)
end

function Room1:load()
    super.load(self)
	for _,enemy in ipairs(Game.stage:getObjects(ChaserEnemy)) do
		if enemy.sprite.sprite == "overworld" then
			enemy:setWalkSprite("overworld")
		end
	end
	self:getTileLayer("tiles_deco_topreflect").visible = false
end

function Room1:onEnter()
    super.onEnter(self)
	if not Game:getFlag("sawGardenMusicLogo", false) then
        Game.world:spawnObject(MusicLogo("garden", 180, 324, true), WORLD_LAYERS["ui"])
		Game:setFlag("sawGardenMusicLogo", true)
	end
end

return Room1