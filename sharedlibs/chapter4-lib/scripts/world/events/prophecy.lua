---@class Event.prophecy : Event
local Prophecy, super = Class(Event, "prophecy")

function Prophecy:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}

	self.always_visible = properties["alwaysvisible"] or false
	
    self.texture = properties["texture"] or "initial1" -- the sprite to display (gets sprite from "world/events/prophecy/")
	local tex = Assets.getTexture("world/events/prophecy/"..self.texture or "") or nil
	if tex then
		self.panel_width = properties["panel_w"] or 150
		self.panel_height = properties["panel_h"] or 90
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

	self.no_back = properties["no_back"] or false

	self.fade_edges = properties["fade_edges"] or false

    self.panel                 = ProphecyPanel(self.texture, self.text, self.panel_width, self.panel_height)
    self.panel.sprite_offset_x = self.sprite_offset_x
    self.panel.sprite_offset_y = self.sprite_offset_y
    self.panel.text_offset_x   = self.text_offset_x
    self.panel.text_offset_y   = self.text_offset_y
	self.panel.no_back		   = self.no_back
	self.panel.fade_edges	   = self.fade_edges

    self.container:addChild(self.panel)

    --self.afx = self.container:addFX(AlphaFX(0))

    self.nodestroysound        = false
    self.nodestroysecondsound  = false
    self.nodestroysparkles     = false
    self.destroy               = 0
	self.roomglow = nil
	self.panel_active = false
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

function Prophecy:breakProphecy(type, silent)
	local destroytype = type or 0
	local silent = silent or false
    local sprites = Assets.getFrames("world/events/prophecy/prophecy_shatter")
    if #sprites == 0 then return end

    local delaytime = 30/30

    local broken_container = Object(self.x-self.panel_width, self.y-self.panel_height)
    broken_container:setScaleOrigin(0.5, 0.5)
    broken_container:setLayer(self:getLayer())
    self.parent:addChild(broken_container)

    broken_container.timer = Timer()
    broken_container:addChild(broken_container.timer)

    local timer = broken_container.timer
    for _, texture in ipairs(sprites) do
        local s = Sprite(texture)
        s:setScale(2)
        broken_container:addChild(s)

		if destroytype == 3 then
			s.alpha = 0.3;
			s:setPhysics({
				speed = 0,
				friction = 0.5,
				direction = math.rad(270)
			})
			delaytime = 5
			broken_container.timer:after(((delaytime * MathUtils.random(5)) + 1)/30, function()
				s:setPhysics({
					speed = 2,
					friction = 0,
					gravity = 0.5 + MathUtils.random(0.1)
				})
			end)
		else
			s.alpha = 0.8;
			s:setPhysics({
				speed = 2,
				friction = 0.05,
				direction = math.rad(Utils.random(360))
			})
			s:setGraphics({
				fade_to = 0,
				fade = 0.01
			})
		end
    end

    broken_container:setScale(
        self:getRealWidth() / (sprites[1]:getWidth()*2),
        self:getRealHeight() / (sprites[1]:getHeight()*2)
    )
    broken_container.timer:after(120/30, function()
        broken_container:remove()
    end)

	if not silent then
		broken_container.timer:after(2/30, function() Assets.playSound("glassbreak", 0.4, 0.6) end)
		Assets.playSound("sparkle_glock", 0.5, 0.8)
		Assets.playSound("sparkle_glock", 0.5, 0.71)
		Assets.playSound("punchmed", 0.95, 0.7)
	end
	
    self:remove()
end

function Prophecy:update()
    super.update(self)

    --self.container.y = Utils.wave(Kristal.getTime()*2, -10, 10)

    if self.texture and self.text then
        self.panel.text.y = -self.panel_height + self.panel.text_offset_y
    else
        self.panel.text.y = self.text_offset_y
    end

    Object.startCache()
	if self.always_visible then
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
