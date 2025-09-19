---@class Text : Text
table.insert(Text.COMMANDS, "funnytext")
table.insert(Text.COMMANDS, "rainbow")

local Text, super = Utils.hookScript(Text)

function Text:init(text, x, y, w, h, options)
    super.init(self, text, x or 0, y or 0, w or SCREEN_WIDTH, h or SCREEN_HEIGHT, options)
	self.draw_children_below = 0 -- funnytext draws below the text
end

function Text:resetState()
	super.resetState(self)
	table.insert(self.state, {rainbow_speed = 0, rainbow_distance = 0})
end

function Text:processModifier(node, dry)
    super.processModifier(self, node, dry)
    if node.command == "funnytext" then
        local x_offset = tonumber(node.arguments[3]) or 0
        local y_offset = tonumber(node.arguments[4]) or 0
        local x_origin = tonumber(node.arguments[5]) or 0.5
        local y_origin = tonumber(node.arguments[6]) or 0.5
        local x_scale  = tonumber(node.arguments[7]) or 1
        local y_scale  = tonumber(node.arguments[8]) or 1
        local speed    = tonumber(node.arguments[9]) or 1

        local tname    = node.arguments[1]
        local texture  = Assets.getFramesOrTexture("funnytext/"..tname)
        local sound    = node.arguments[2]

        if texture then
            if not dry then
				local ftext = FunnyText(tname, sound, self.state.current_x + x_offset, self.state.current_y + y_offset)
				ftext.in_dialogue = false
				ftext:setOriginExact(x_origin,y_origin)
				ftext.ideal_scale_x = x_scale
				ftext.ideal_scale_y = y_scale
				ftext.layer = self.layer - 1
				ftext.speed = speed
				self:addChild(ftext)
				table.insert(self.sprites, ftext)
            end
            self.state.current_x = self.state.current_x + (texture[1]:getWidth() * x_scale) + self.state.spacing
        end
    elseif node.command == "rainbow" then
		self.state.rainbow_speed = tonumber(node.arguments[1]) or 8
		self.state.rainbow_distance = tonumber(node.arguments[2]) or 8
        self.draw_every_frame = true
	end
end

function Text:getTextColor(state, use_base_color)
	if state.rainbow_speed and state.rainbow_speed > 0 then
		if use_base_color then
			cr, cg, cb, ca = self:getDrawColor()
		else
			cr, cg, cb, ca = 1, 1, 1, 1
		end
		local sr, sg, sb, sa = Utils.hsvToRgb((((self.timer * state.rainbow_speed) + (state.typed_characters * state.rainbow_distance)) / 255) % 1, 140/255, 1)
		sa = sa or 1

		return sr * cr, sg * cg, sb * cb, sa * ca
	else
		return super.getTextColor(self, state, use_base_color)
	end
end

return Text