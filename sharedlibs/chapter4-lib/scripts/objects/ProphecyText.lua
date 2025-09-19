local ProphecyText, super = Class(Text)

ProphecyText.COMMANDS = {}

function ProphecyText:init(text, x, y, w, h, options)
    if type(w) == "table" then
        options = w
        w, h = SCREEN_WIDTH, SCREEN_HEIGHT
    end
    options = options or {}

    options["font"] = options["font"] or "legend"
    options["style"] = options["style"] or "none"
    options["line_offset"] = options["line_offset"] or 0

    self.custom_command_wait = {}
    if type(text) == "string" then
        text = { text }
    end
    super.init(self, text, x or 0, y or 0, w or SCREEN_WIDTH, h or SCREEN_HEIGHT, options)
end

function ProphecyText:resetState()
	super.resetState(self)
	self.state.spacing = 1
	self.state.offset_x = 1
end

function ProphecyText:processNode(node, dry)
	if node.type == "character" and node.character == "L" then
		self.state.offset_x = 2
	end
	super.processNode(self, node, dry)
	self.state.offset_x = 1
end

function ProphecyText:draw()
    if DEBUG_RENDER then
        Draw.setColor(0, 1, 0.5, 0.5)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", 0, 0, self.width, self.height)

        Draw.setColor(0, 1, 0.5, 1)
        love.graphics.rectangle("line", 0, 0, self:getTextWidth(), self:getTextHeight())
    end

    super.super.draw(self)
end

return ProphecyText