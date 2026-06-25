local Room1, super = Class(Map)

function Room1:init(world, data)
	super.init(self, world, data)
	if not Game:getFlag("sawGardenMusicLogo", false) then
		self.music = "deltarune/field_of_hopes_insaneintherain_intro"
	end
end

function Room1:load()
    super.load(self)
	if not Game:getFlag("sawGardenMusicLogo", false) then
        Game.world:spawnObject(MusicLogo("garden", 180, 324, true), WORLD_LAYERS["ui"])
		Game:setFlag("sawGardenMusicLogo", true)
	end
	self:getTileLayer("tiles_deco_topreflect").visible = false
end

return Room1