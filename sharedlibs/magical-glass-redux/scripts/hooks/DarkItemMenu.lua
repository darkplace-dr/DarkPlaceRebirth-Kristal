local DarkItemMenu, super = HookSystem.hookScript(DarkItemMenu)

function DarkItemMenu:init()
    super.init(self)

    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")
end

function DarkItemMenu:update()
    if self.state == "SELECT" then
        if Input.pressed("cancel") then
            self.item_selected_x = 1
            self.item_selected_y = 1
            self.selected_item = 1
        end
    end

    super.update(self)
end

function DarkItemMenu:draw()
    love.graphics.setFont(self.font)

    local headers = {"USE", "TOSS", "KEY"}

    for i, name in ipairs(headers) do
        if self.state == "MENU" then
            Draw.setColor(PALETTE["world_header"])
        elseif self.item_header_selected == i then
            Draw.setColor(PALETTE["world_header_selected"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        local x = 88 + ((i - 1) * 120)
        love.graphics.print(name, x, -2)
    end

    local item_x = 0
    local item_y = 0
    local inventory = self:getCurrentStorage()

    local page = math.ceil(self.item_selected_y / 6) - 1
    local max_page = math.ceil(#inventory / 12) - 1

    local page_offset = page * 12
    for i = page_offset + 1, math.min(page_offset + 12, #inventory) do
        local item = inventory[i]

        -- Draw the item shadow
        Draw.setColor(PALETTE["world_text_shadow"])
        local name = item:getWorldMenuName()
        love.graphics.print(name, 54 + (item_x * 210) + 2, 40 + (item_y * 30) + 2)

        if self.state == "MENU" then
            Draw.setColor(PALETTE["world_gray"])
        else
            if item.usable_in == "world" or item.usable_in == "all" then
                Draw.setColor(PALETTE["world_text"])
            else
                Draw.setColor(PALETTE["world_text_unusable"])
            end
        end
        love.graphics.print(name, 54 + (item_x * 210), 40 + (item_y * 30))
        item_x = item_x + 1
        if item_x >= 2 then
            item_x = 0
            item_y = item_y + 1
        end
    end

    local heart_x = 20
    local heart_y = 20

    if self.state == "MENU" then
        heart_x = 88 + ((self.item_header_selected - 1) * 120) - 25
        heart_y = 8
    elseif self.state == "SELECT" then
        heart_x = 28 + (self.item_selected_x - 1) * 210
        heart_y = 50 + (self.item_selected_y - page_offset / 2 - 1) * 30
    end
    if self.state ~= "USE" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, heart_x, heart_y)
    end

    if self.state ~= "MENU" then
        Draw.setColor(1, 1, 1, 1)
        local sine_off = 0
        if self.state == "SELECT" then
            sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
        end
        if page < max_page then
            Draw.draw(self.arrow_sprite, -5, 203 + sine_off)
        end
        if page > 0 then
            Draw.draw(self.arrow_sprite, -5, 62 - sine_off, 0, 1, -1)
        end
    end

    for _, item in ipairs(inventory) do
        Draw.setColor(1, 1, 1)
        item:onMenuDraw(self.parent)
    end

    Object.draw(self)
end

return DarkItemMenu