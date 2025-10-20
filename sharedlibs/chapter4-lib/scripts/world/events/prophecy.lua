---@class Event.prophecy : Event
local Prophecy, super = Class(Event, "prophecy")

function Prophecy:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}

    self.container_offset_x       = properties["offx"] or 0                  -- x offset of the sprite
    self.container_offset_y       = properties["offy"] or 0                  -- y offset of the sprite
	
    self.container = Object(self.container_offset_x,self.container_offset_y)
    self:addChild(self.container)

    self.texture               = properties["texture"] or "initial1"          -- the sprite to display (gets sprite from "world/events/prophecy/")
    self.sprite_offset_x       = properties["spr_offx"] or 0                  -- x offset of the sprite
    self.sprite_offset_y       = properties["spr_offy"] or 0                  -- y offset of the sprite

    self.text                  = properties["text"]                           -- the text to display
    self.text_offset_x         = properties["txt_offx"] or 0                  -- x offset of the text
    self.text_offset_y         = properties["txt_offy"] or 0                  -- y offset of the text

	local tex = Assets.getTexture("world/events/prophecy/"..self.texture or "") or nil
	if tex then
		self.panel_width       = properties["panel_w"] or 150
		self.panel_height      = properties["panel_h"] or 90
	else	
		self.panel_width       = properties["panel_w"] or 150
		self.panel_height      = properties["panel_h"] or 90
	end
	
    self.can_break             = properties["can_break"]                      -- if true, then allows the player to break panel when interacted with
    self.break_type            = properties["break_type"]                     -- if enabled, sets the delay time for when the panel should break apart to a specific interval
    self.break_delay           = properties["break_delay"]                    -- if "break_type" is not defined, sets the delay time for when the panel should break apart

	self.no_back               = properties["no_back"] or false

	self.fade_edges            = properties["no_back"] or false

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

function Prophecy:getSortPosition()
    return self.x,self.y
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
    if self:collidesWith(self.world.player) then
        --self.afx.alpha = Utils.approach(self.afx.alpha, 1, DT*4)
		self.panel_active = true
		self.panel.panel_alpha = Utils.lerp(self.panel.panel_alpha, 1.2, DTMULT*0.1)
    else
        --self.afx.alpha = Utils.approach(self.afx.alpha, 0, DT*2)
		self.panel.panel_alpha = Utils.lerp(self.panel.panel_alpha, 0, DTMULT*0.2)
		self.panel_active = false
    end
    Object.endCache()
end

return Prophecy