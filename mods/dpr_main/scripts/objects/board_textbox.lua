---@class board_textbox : Object
---@overload fun(...) : board_textbox
local board_textbox, super = Class(Object)

function board_textbox:init(x, y, width, height, instant)
    super.init(self, x, y, width, height)

    --self.width

    --self.box = UIBox(0, 0, width, height)
    self.box = Rectangle(0, 16, 384, 86)
	self.box.color = {0,0,0}
    self.box.layer = -1
    self.box.debug_select = false
    self:addChild(self.box)

    self.default_font = "8bit"
    self.default_font_size = 1

    self.font = self.default_font
    self.font_size = self.default_font_size
	
    -- Added text width for autowrapping
    self.wrap_add_w = -32

    self.text_x, self.text_y = 16 + 2, 30 - 2 - 3

    self.text = DialogueText("", self.text_x, self.text_y, width + self.wrap_add_w, SCREEN_HEIGHT, {line_offset = 4, style = "none"})
    self.text.box_parent = self
    self:addChild(self.text)

    self.advance_callback = nil
	self.advance_snd = false
	self.instant = instant
	self.text_timer = 0
	self.text_con = 0
    self.y = 480
	self.endy = 352
	self.side = 1
	self.movespeed = 16
end

function board_textbox:update()
	if self.text_con == 0 then
		if self.instant == true then
			self.y = self.endy
			self.text_con = 2
		else
			Assets.playSound("board_lift", 0.5, 1.2)
			self.last_skippable = self.text.skippable
			self.text.skippable = false
			self.text.state["waiting"] = 999
			self.text.visible = false
			self.text_con = 1
		end
	end
	if self.text_con == 1 then
		if self.side == 1 then
			if self.y > self.endy then
				self.y = self.y - self.movespeed * DTMULT
			else
				self.y = self.endy
				self.text.state["waiting"] = 1/30
				self.text.visible = true
				self.text.skippable = self.last_skippable
				self.text_con = 2
			end
		elseif self.side == 0 then
			if self.y < self.endy then
				self.y = self.y + self.movespeed * DTMULT
			else
				self.y = self.endy
				self.text.state["waiting"] = 1/30
				self.text.visible = true
				self.text.skippable = self.last_skippable
				self.text_con = 2
			end
		end
	end
	if self.text_con == 2 then
		if not self:isTyping() then
			if not self.advance_snd then
				Assets.stopAndPlaySound("board_text_end")
				self.advance_snd = true
			end
			if not self.next_arrow then
				self.next_arrow = Sprite("ui/arrow_nooutline")
				self.next_arrow:setScale(2)
				self.next_arrow.x = 350
				self.next_arrow.y = 66 + 16
				self.next_arrow.layer = -0.5
				self:addChild(self.next_arrow)
			else
				self.text_timer = self.text_timer + DTMULT
				if self.text_timer >= 20 then
					self.next_arrow.visible = false
				else
					self.next_arrow.visible = true
				end
				if self.text_timer >= 30 then
					self.text_timer = 0
				end
			end
		else
			self.text_timer = 0
		end
	end
    super.update(self)
end

function board_textbox:advance()
	self.advance_snd = false
	self.text_timer = 0
	if self.next_arrow then
		self.next_arrow:remove()
		self.next_arrow = nil
	end
    self.text:advance()
end

function board_textbox:setSize(w, h)
    self.width, self.height = w or 0, h or 0
    self:updateTextBounds()
end

function board_textbox:setFont(font, size)
    if not font then
        self.font = self.default_font
        self.font_size = self.default_font_size
    else
        self.font = font
        self.font_size = size
    end
end

function board_textbox:setAuto(auto)
    self.text.auto_advance = auto or false
end

function board_textbox:setAdvance(advance)
    self.text.can_advance = advance or false
end

function board_textbox:setSkippable(skippable)
    self.text.skippable = skippable or false
end

function board_textbox:setAlign(align)
    self.text.align = align or "left"
    self:updateTextBounds()
end

function board_textbox:setCallback(callback)
    self.advance_callback = callback
    self.text.advance_callback = callback
end

function board_textbox:resetFunctions()
    self.text.functions = {}
end

function board_textbox:addFunction(id, func)
    self.text:addFunction(id, func)
end

function board_textbox:setText(text, callback)
    self.text.font = self.font
    self.text.font_size = self.font_size

    if type(text) ~= "table" then
        text = {text}
    else
        text = Utils.copy(text)
    end
    for i,line in ipairs(text) do
		text[i] = "[voice:board]"..line
	end
    self.text:setText(text, callback or self.advance_callback)
end

function board_textbox:getText()
    return self.text.text
end

function board_textbox:updateTextBounds()
    self.text.x = self.text_x
    self.text.width = self.width + self.wrap_add_w
end

function board_textbox:getBorder()
    if self.box.visible then
        return 0, 0
    end
end

function board_textbox:getDebugRectangle()
    if not self.debug_rect then
        local bw, bh = self:getBorder()
        return {-bw, -bh, self.width + bw*2, self.height + bh*2}
    end
    return super.getDebugRectangle(self)
end

function board_textbox:isTyping()
    return self.text:isTyping() and self.text_con == 2
end

function board_textbox:isDone()
    return self.text:isDone() and self.text_con == 2
end

function board_textbox:draw()
    super.draw(self)
end

return board_textbox