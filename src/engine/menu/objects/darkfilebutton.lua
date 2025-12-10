---@class FileButton : Object
---@overload fun(...) : FileButton
local FileButton, super = Class(Object)

function FileButton:init(list, id, data, x, y, width, height)
    super.init(self, x, y, width, height)

    self.list = list
    self.data = data
    self.id = id or 1

    self:setData(data)

    self.selected = false

    self.font = Assets.getFont("main")
    self.subfont = Assets.getFont("main", 16)

    self.prompt = nil
    self.choices = nil
    self.selected_choice = 1
end

function FileButton:setData(data)
    self.data = data

    self.name = data and data.name or "[EMPTY]"
    self.area = data and data.room_name or "------------"

    if data and data.playtime then
        local hours = math.floor(data.playtime / 3600)
        local minutes = math.floor(data.playtime / 60 % 60)
        local seconds = math.floor(data.playtime % 60)
        self.time = string.format("%d:%02d:%02d", hours, minutes, seconds)
    else
        -- Don't ask why it's not "--:--:--" -- ask Toby
        self.time = "--:--"
    end
end

function FileButton:setChoices(choices, prompt)
    self.prompt = prompt
    self.choices = choices
    self.selected_choice = 1
end

function FileButton:getDrawColor()
    local r, g, b, a = super.getDrawColor(self)
    if not self.selected then
        return r * 0.6, g * 0.6, b * 0.7, a
    else
        return r, g, b, a
    end
end

function FileButton:getHeartPos()
    if not self.choices then
        if self.selected_x == 1 then
            return self.width/2  - 16, -10
        else
            return self.width/2 - 16, -10
        end
    else
        if self.selected_choice == 1 then
            return 0, 69 - 6
        else
            return 152, 69 - 6
        end
    end
end

function FileButton:draw()
    -- Draw the transparent background
    Draw.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, self.width, self.height)

    -- Draw the rectangle outline
    Draw.setColor(self:getDrawColor())
    Draw.drawMenuRectangle(0, 0, self.width, self.height)

    -- Draw text inside the button rectangle
    Draw.pushScissor()
    Draw.scissor(0, 0, self.width, self.height)

    if not self.prompt then
        -- Draw the name shadow
        Draw.setColor(0, 0, 0)
        local name_x = Utils.clamp((self.width-self.font:getWidth(self.name))/2 + 2, 6, self.width - 6)
        local name_sx = self.font:getWidth(self.name) <= 256 and 1 or 256/self.font:getWidth(self.name)
        love.graphics.print(self.name, name_x + 2, 2 + 2, 0, name_sx, 1)
        -- Draw the name
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.name, name_x, 2, 0, name_sx, 1)

        -- Draw the time shadow
        local time_x = Utils.clamp((self.width-self.font:getWidth(self.time))/2 + 2, 6, self.width - 6)
        local time_sx = self.font:getWidth(self.time) <= 256 and 1 or 256/self.font:getWidth(self.time) + 2
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.time, time_x + 2, 76 + 2, 0, time_sx, 1)
        -- Draw the time
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.time, time_x, 76, 0, time_sx, 1)
    else
        -- Draw the prompt shadow
        local prompt_x = Utils.clamp((self.width-self.font:getWidth(self.prompt))/2 + 2, 6, self.width - 6)
        local prompt_sx = self.font:getWidth(self.prompt) <= 256 and 1 or 256/self.font:getWidth(self.prompt)
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.prompt, prompt_x + 2, 2 + 2, 0, prompt_sx, 1)
        -- Draw the prompt
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.prompt, prompt_x, 2, 0, prompt_sx, 1)
    end

    if not self.choices then
        -- Draw the area shadow
        local area_x = Utils.clamp((self.width-self.font:getWidth(self.area))/2 + 2, 6, self.width - 6)
        local area_sx = self.font:getWidth(self.area) <= 256 and 1 or 256/self.font:getWidth(self.area)
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.area, area_x + 2, 38 + 2, 0, area_sx, 1)
        -- Draw the area
        Draw.setColor(self:getDrawColor())
        love.graphics.print(self.area, area_x, 38, 0, area_sx, 1)
    else
        -- Draw the shadow for choice 1
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.choices[1], 34+2, 38+2)
        -- Draw choice 1
        if self.selected_choice == 1 then
            Draw.setColor(1, 1, 1)
        else
            Draw.setColor(0.6, 0.6, 0.7)
        end
        love.graphics.print(self.choices[1], 34, 38)

        -- Draw the shadow for choice 2
        Draw.setColor(0, 0, 0)
        love.graphics.print(self.choices[2], 186+2, 38+2)
        -- Draw choice 2s
        if self.selected_choice == 2 then
            Draw.setColor(1, 1, 1)
        else
            Draw.setColor(0.6, 0.6, 0.7)
        end
        love.graphics.print(self.choices[2], 186, 38)
    end

    Draw.popScissor()
end

return FileButton