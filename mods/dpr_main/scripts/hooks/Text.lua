---@class Text : Text
table.insert(Text.COMMANDS, "funnytext")

local Text, super = Utils.hookScript(Text)

function Text:init(text, x, y, w, h, options)
    super.init(self, text, x or 0, y or 0, w or SCREEN_WIDTH, h or SCREEN_HEIGHT, options)
	self.draw_children_below = 0 -- funnytext draws below the text
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
    end
end

return Text