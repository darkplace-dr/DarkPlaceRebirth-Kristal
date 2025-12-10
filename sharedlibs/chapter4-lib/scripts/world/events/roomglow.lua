---@class Event.roomglow : Event
local RoomGlow, super = Class(Event, "roomglow")

function RoomGlow:init(data)
    super.init(self, data)
	self.x = 0
	self.y = 0
	self:setParallax(0,0)
    local properties = data and data.properties or {}
	self.prophecy_glow = properties["prophecy"] or false
    self.tint = TiledUtils.parseColorProperty(properties["tint"]) or ColorUtils.hexToRGB("#2A39FFFF")
    self.highlight = TiledUtils.parseColorProperty(properties["highlight"]) or ColorUtils.hexToRGB("#42D0FFFF")
    self.darkcol = TiledUtils.parseColorProperty(properties["darkness"]) or ColorUtils.hexToRGB("#404040FF")
	self.glowactive = false
	self.actind = 0
	self.lerpstrength = 0.125
	self.init = true
end

function RoomGlow:postLoad()
	self.tile_dark = Game.world.map:getTileLayer("roomglow_dark")
	if self.tile_dark then
		self.tile_dark:addFX(ColorMaskFX({0,0,0}), "colormask")
		self.tile_dark:addFX(AlphaFX(0), "shadow")
	end
	self.tile_dark_bg = Game.world.map:getTileLayer("roomglow_dark_bg")
	if self.tile_dark_bg then
		self.tile_dark_bg:addFX(ColorMaskFX({0,0,0}), "colormask")
		self.tile_dark_bg:addFX(AlphaFX(0), "shadow")
	end
	for _, event in ipairs(Game.world.map.events) do
		if event.layer == Game.world.map.layers["objects_roomglow_dark"] then
			event:addFX(ColorMaskFX({0,0,0}), "colormask")
			event:addFX(AlphaFX(0), "alphafx")
		end
	end
end

function RoomGlow:update()
    super.update(self)

    if not self.stage then return end

	if self.prophecy_glow then
		self.glowactive = false
	    for _,prophecy in ipairs(Game.world.map:getEvents("prophecy")) do
			if prophecy.panel_active then
				self.glowactive = true
			end
		end
	end
	if self.init then
		if self.glowactive then
			self.actind = MathUtils.lerp(self.actind, 1.05, self.lerpstrength * DTMULT)
		else
			self.actind = MathUtils.lerp(self.actind, -0.05, self.lerpstrength * DTMULT)
		end
	end
	if self.tile_dark and self.tile_dark:getFX("shadow") then
		self.tile_dark:getFX("shadow").alpha = self.actind
	end
	if self.tile_dark_bg and self.tile_dark_bg:getFX("shadow") then
		self.tile_dark_bg:getFX("shadow").alpha = self.actind
	end
	for _, event in ipairs(Game.world.map.events) do
		if event.layer == Game.world.map.layers["objects_roomglow_dark"] and event:getFX("alphafx") then
			 event:getFX("alphafx").alpha = self.actind
		end
	end
    for _,chara in ipairs(self.stage:getObjects(Character)) do
		if not chara.no_shadow then
			local hfx = chara:getFX("highlight")
			local sfx = chara:getFX("shadow")
			if hfx then
				hfx.alpha = self.actind
			else
				chara:addFX(ChurchHighlightFX(0, self.highlight, {darkcol = self.darkcol}), "highlight")
			end
			if sfx then
				sfx.scale = self.actind*2
				sfx.alpha = self.actind
			else
				chara:addFX(ChurchShadowFX(), "shadow")
			end
        end
    end
end

function RoomGlow:draw()
	if self.actind > 0 then
		love.graphics.setColor(ColorUtils.mergeColor({1,1,1}, {self.tint[1],self.tint[2],self.tint[3]}, self.actind))
		love.graphics.setBlendMode("multiply", "premultiplied")
		love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		love.graphics.setBlendMode("alpha", "alphamultiply")
	end
    super.draw(self)
end

return RoomGlow