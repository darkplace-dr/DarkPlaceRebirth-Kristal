local Room1, super = Class(Map)

function Room1:init(world, data)
	super.init(self, world, data)
	if Game:getFlag("hackerSidequest", 0) == 2 then
		self.music = "keygen_credits"
	end
end

function Room1:onEnter()
    super.onEnter(self)
	self.digital_bg = Game.world:spawnObject(DigitalMatrixBG(), "objects_bg")
	self.demoscene_bg = Game.world:spawnObject(HackerDemosceneBG(), "objects_bg")
	self.demoscene_bg.layer = self.demoscene_bg.layer - 0.001
	if Game:getFlag("hackerSidequest", 0) == 2 then
		self.digital_bg.matrix_hide_char_val = 1
		self.demoscene_bg.demo_active = true
		self.demoscene_bg.demo_alpha = 1
	end
end

function Room1:update()
    super.update(self)
    for _,chara in ipairs(Game.stage:getObjects(Character)) do
		if self.demoscene_bg.demo_active then
			local hfx = chara:getFX("highlight")
			if hfx then
				hfx.alpha = self.demoscene_bg.demo_alpha
				hfx.color = self.demoscene_bg.rainbow_color
			else
				chara:addFX(ChurchHighlightFX(self.demoscene_bg.demo_alpha, self.demoscene_bg.rainbow_color, {darkcol = ColorUtils.hexToRGB("#404040FF")}, 1), "highlight")
			end
		end
    end
end

return Room1