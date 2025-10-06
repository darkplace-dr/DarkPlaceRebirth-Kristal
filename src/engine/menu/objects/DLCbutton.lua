local DLCButton, super = Class(ModButton, nil, "DLCButton")

function DLCButton:init(name, width, height, mod)
	super.init(self, name, width, height, mod)

    --[[if mod.button and love.filesystem.getInfo(mod.button) then
        self.button_texture = love.graphics.newImage(mod.button)
    end]]
end

function DLCButton:update()
	super.update(self)

	if not self.selected then
		self.x = Utils.approach(self.x, 25, 4*DTMULT)
	else
		self.x = Utils.approach(self.x, 0, 4*DTMULT)
	end
end

function DLCButton:getDrawColor()
    local r, g, b, a = super.super.getDrawColor(self)
    local color = self.mod.color
    if color then
        if type(color) == "string" then
            r, g, b = unpack(Utils.hexToRgb(color))
        elseif type(color) == "table" then
            r, g, b = unpack(color)
        end
    end
    if not self.selected then
        return r*0.6, g*0.6, b*0.7, a
    else
        return r, g, b, a
    end
end

function DLCButton:draw()
    if not self.button_texture then
        -- Draw the transparent backgrounds
        Draw.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, self.width, self.height)

        -- Draw the rectangle outlines
        -- self:drawCoolRectangle(0, 0, self.width, self.height)
    else
        if self.selected then
            Draw.setColor(1, 1, 1, 1)
        else
            Draw.setColor(0.6, 0.6, 0.7, 1)
        end
        Draw.draw(self.button_texture)
    end

    -- Draw text inside the button rectangle
    Draw.pushScissor()
    Draw.scissor(0, 0, self.width, self.height)

    if not self.mod.hide_name then
        -- Make name position higher if we have a subtitle
        local name_y = math.floor((self.height/2 - self.font:getHeight()/2) / 2) * 2
        love.graphics.setFont(self.font)
        -- Draw the name shadow
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.name, 10 + 2, name_y + 2)
        -- Draw the name
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.name, 10, name_y)
    end

    Draw.popScissor()
end

return DLCButton