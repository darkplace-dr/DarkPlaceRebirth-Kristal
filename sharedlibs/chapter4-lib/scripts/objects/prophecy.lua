---@class Chapter4Lib.Prophecy : Event
---@field texture string *[Property `texture`]* The sprite to display, relative to world/events/prophecy (Defaults to `initial1`)
local Prophecy, super = Class(Event, "Prophecy")

function Prophecy:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}

	self.always_visible = properties["alwaysvisible"] or false
	
    self.texture = properties["texture"] or "initial1" -- the sprite to display (gets sprite from "world/events/prophecy/")
	local tex = Assets.getTexture("world/events/prophecy/"..self.texture or "") or nil
	if tex then
		self.panel_width = properties["panel_w"] or math.max(150, tex:getWidth())
		self.panel_height = properties["panel_h"] or math.max(90, tex:getHeight())
	else
		self.panel_width = properties["panel_w"] or 150
		self.panel_height = properties["panel_h"] or 90
	end
	
    self.sprite_offset_x = properties["spr_offx"] or (tex and tex:getWidth()/2) or 0 -- x offset of the sprite
    self.sprite_offset_y = properties["spr_offy"] or (tex and tex:getHeight()) or 0 -- y offset of the sprite

    self.container_offset_x = properties["offx"] or self.width/2 -- x offset of the sprite
    self.container_offset_y = properties["offy"] or ((self.panel_height * -1)) or 0 -- y offset of the sprite
	
    self.container = Object(self.container_offset_x,self.container_offset_y)
    self:addChild(self.container)

    self.text = properties["text"] -- the text to display
    self.text_offset_x   = properties["txt_offx"] or -160 -- x offset of the text
    self.text_offset_y   = properties["txt_offy"] or -16 -- y offset of the text

    self.can_break = properties["can_break"] -- if true, then allows the player to break panel when interacted with
    self.break_type = properties["break_type"] -- if enabled, sets the delay time for when the panel should break apart to a specific interval
    self.break_delay = properties["break_delay"] -- if "break_type" is not defined, sets the delay time for when the panel should break apart
    self.break_silent = properties["break_silent"]
	self.break_second_silent = properties["break_second_silent"]
	self.break_sparkles = properties["break_sparkles"]

	self.no_back = properties["no_back"] or false

	self.fade_edges = properties["fade_edges"] or false

	self.base_tex = properties["base_tex"] or "backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS"
	self.faded_tex = properties["faded_tex"] or "backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS"
	
    self.panel                 = ProphecyPanel(self.base_tex, self.faded_tex, self.texture, self.text, self.panel_width, self.panel_height, properties["musichint"], properties["bignotes"] or false)
    self.panel.sprite_offset_x = self.sprite_offset_x
    self.panel.sprite_offset_y = self.sprite_offset_y
    self.panel.text_offset_x   = self.text_offset_x
    self.panel.text_offset_y   = self.text_offset_y
	self.panel.no_back		   = self.no_back
	self.panel.fade_edges	   = self.fade_edges
	if properties["propbluecol"] then
		self.panel.propblue = properties["propbluecol"] and TiledUtils.parseColorProperty(properties["propbluecol"])
	end
	if properties["litebluecol"] then
		self.panel.liteblue = properties["litebluecol"] and TiledUtils.parseColorProperty(properties["litebluecol"])
	end
	if properties["ogbgcol"] then
		self.panel.ogbg = TiledUtils.parseColorProperty(properties["ogbgcol"])
	end
	if properties["linecol1"] then
		self.panel.linecol1 = properties["linecol1"] and TiledUtils.parseColorProperty(properties["linecol1"])
	end
	if properties["linecol2"] then
		self.panel.linecol2 = properties["linecol2"] and TiledUtils.parseColorProperty(properties["linecol2"])
	end
	if properties["textcol"] then
		self.panel.text_color = properties["textcol"] and TiledUtils.parseColorProperty(properties["textcol"])
	end
	if properties["notex"] then
		self.panel.nxpos = properties["notex"]
	end
	if properties["notey"] then
		self.panel.nypos = properties["notey"]
	end
	if properties["notexspace"] then
		self.panel.nspace = properties["notexspace"]
	end
	if properties["noteyspace"] then
		self.panel.nyspace = properties["noteyspace"]
	end

    self.container:addChild(self.panel)

    --self.afx = self.container:addFX(AlphaFX(0))

    self.nodestroysound        = false
    self.nodestroysecondsound  = false
    self.nodestroysparkles     = false
    self.destroy               = 0
	self.roomglow = nil
	self.panel_active = false
	self.destroying = false
end

function Prophecy:getRealWidth()
    local width = 0

    width = width + self.panel.width*2
    return width
end

function Prophecy:getRealHeight()
    local height = 0

    height = height + self.panel.height*2
    return height
end

function Prophecy:getSortPosition()
    return self.x,self.y
end

function Prophecy:breakProphecy(type, sprite, sparkles, silent, second_silent)
	local destroytype = type or self.break_type
	local silent = self.break_silent or silent or false
	local second_silent = self.break_second_silent or second_silent or false
	local sparkles = self.break_sparkles or sparkles or true
    local sprites = Assets.getFrames("world/events/prophecy/shatter/" .. (sprite or "prophecy_shatter"))
    if #sprites == 0 then return end

    local delaytime = 30
	if type == 2 then
		delaytime = 10
	end
	if type == 3 then
		delaytime = 5
	end
	if self.break_delay then
		delaytime = self.break_delay
	end

	self.world.timer:after(delaytime/30, function()
		if sparkles then
			for i = 1,30 do
				local groundshard = ProphecyGroundShard((self.x - 199) + ((i * 398) / 30) + MathUtils.random(-30, 30), self.y + MathUtils.random(120))
				groundshard.layer = self.layer
				groundshard.ytarg = self.y + SCREEN_HEIGHT/2
				if type == 3 then
					groundshard.ytarg = groundshard.ytarg + 10000
					self.world.timer:after(280/30, function()
						groundshard:remove()
					end)
				end
				Game.world:addChild(groundshard)
			end
		end
		if type < 2 then
			broken_container.timer:after(120/30, function()
				broken_container:remove()
			end)
			self:remove()
		end
	end)
	if not silent then
		if type ~= 3 then
			Assets.playSound("break1", 1, 0.95)
		end
		if not second_silent then
			broken_container.timer:after(delaytime+2/30, function() Assets.playSound("glassbreak", 0.4, 0.6) end)
			broken_container.timer:after(delaytime/30, function() Assets.playSound("sparkle_glock", 0.5, 0.8) end)
			broken_container.timer:after(delaytime/30, function() Assets.playSound("sparkle_glock", 0.5, 0.71) end)
			broken_container.timer:after(delaytime/30, function() Assets.playSound("punchmed", 0.95, 0.7) end)
		end
	end
	
    local broken_container = Object(self.x-self.panel_width, self.y-self.panel_height)
    broken_container:setScaleOrigin(0.5, 0.5)
    broken_container:setLayer(self:getLayer())
	broken_container.draw_children_below = 0
    self.parent:addChild(broken_container)

    broken_container.timer = Timer()
    broken_container:addChild(broken_container.timer)

    local timer = broken_container.timer
    for i, texture in ipairs(sprites) do
        local s = Sprite(texture)
        s:setScale(2)
        broken_container:addChild(s)

		if destroytype == 0 then
			s.alpha = 0.8
			s.physics.speed = 2
			s.physics.friction = 0.5
			s.physics.direction = math.rad(MathUtils.random(360))
			broken_container.timer:after(delaytime/30, function()
				s.physics.gravity = 0.5 + MathUtils.random(0.1)
				s.physics.friction = 0
				s.physics.speed = 2
			end)
		end
		if destroytype == 1 then
			s.alpha = 0.8
			s.physics.speed = 2
			s.physics.friction = 0.5
			s.physics.direction = math.rad(MathUtils.random(360))
			broken_container.timer:after(delaytime/30, function()
				s.physics.speed = 4
				s.physics.friction = 0.4
				broken_container.timer:lerpVar(s, "alpha", alpha, 0, 20)
			end)
		end
		if destroytype == 2 then
			s.alpha = 0.8
			s.physics.speed = 7
			s.physics.friction = 0.75
			s.physics.direction = math.rad(90 + MathUtils.random(-3, 3))
			s.physics.speed_x, s.physics.speed_y = s:getSpeedXY()
			if i == #sprites - 2 or i == #sprites - 4 then
				s.physics.speed_x = 0.5
			end
			if i == #sprites - 1 or i == #sprites - 3 then
				s.physics.speed_x = -0.5
			end
			s.physics.speed, s.physics.direction = s:getSpeedDir()
			s.physics.gravity_direction = math.rad(270)
			broken_container.timer:after(delaytime/30, function()
				s.physics.gravity = 0.25 + MathUtils.random(0.1)
				s.physics.friction = 0
				s.physics.speed = 2 + (((#sprites - i) / #sprites) * 15)
				if i > (#sprites - 5) or i % 2 == 0 then
					s.layer = -1
				end
			end)
		end
		if destroytype == 3 then
			s.alpha = 0.3
			s.physics.speed = 0
			s.physics.friction = 0.5
			s.physics.direction = math.rad(270)
			local delay = (delaytime * MathUtils.random(5)) + 1
			broken_container.timer:after(delay/30, function()
				s.physics.gravity = 0.5 + MathUtils.random(0.1)
				s.physics.friction = 0
				s.physics.speed = 2
			end)
		end
    end

    --[[broken_container:setScale(
        self:getRealWidth() / (sprites[1]:getWidth()*2),
        self:getRealHeight() / (sprites[1]:getHeight()*2)
    )]]
	self.destroying = true
end

function Prophecy:update()
    super.update(self)

    if self.texture and self.text then
        self.panel.text.y = -self.panel_height + self.panel.text_offset_y
    else
        self.panel.text.y = self.text_offset_y
    end

    Object.startCache()
	if self.destroying then
		self.panel.panel_alpha = -99
		self.panel_active = false
		Ch4Lib.updateLightBeams(1)
	elseif self.always_visible then
		self.panel_active = true
		self.panel.panel_alpha = 1.2
		Ch4Lib.updateLightBeams(1 - (self.panel.panel_alpha / 1.2))
	else
		if self:collidesWith(self.world.player) then
			--self.afx.alpha = MathUtils.approach(self.afx.alpha, 1, DT*4)
			self.panel_active = true
			self.panel.panel_alpha = MathUtils.lerp(self.panel.panel_alpha, 1.2, DTMULT*0.1)
			Ch4Lib.updateLightBeams(1 - (self.panel.panel_alpha / 1.2))
		else
			--self.afx.alpha = MathUtils.approach(self.afx.alpha, 0, DT*2)
			self.panel.panel_alpha = MathUtils.lerp(self.panel.panel_alpha, 0, DTMULT*0.2)
			self.panel_active = false
			Ch4Lib.updateLightBeams(1 - (self.panel.panel_alpha / 1.2))
		end
	end
    Object.endCache()
end

return Prophecy
