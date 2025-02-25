local LightStorageMenu, super = Class(Object, "LightStorageMenu")

function LightStorageMenu:init(left_storage, right_storage)
    super.init(self, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

    self:setParallax(0, 0)
    self.draw_children_below = 0

    self.font = Assets.getFont("main")

    self.box = UIBox(40, 40, 562, 402)
    self.box.layer = WORLD_LAYERS["ui"]
    self:addChild(self.box)
    
    self.heart_sprite = Assets.getTexture("player/heart_menu")
    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")

    self.storages = {left_storage or "items", right_storage or "box_a"}

    self.current_selecting = 1
    self.list = 1
    self.scroll_y = {1, 1}
end

function LightStorageMenu:getStorage(list)
    return Game.inventory:getStorage(self.storages[list or self.list])
end

function LightStorageMenu:getSelectedItem(list)
    return Game.inventory:getItem(self:getStorage(list), self.current_selecting)
end

function LightStorageMenu:getLimit(list)
    return 10
end

function LightStorageMenu:onKeyPressed(key)
    local function getEndRow() return math.min(math.max(1, self:getLimit(self.list), #self:getStorage(self.list) + (#self:getStorage(self.list) >= self:getLimit(self.list) and 1 or 0)), self:getStorage(self.list).max) end
    local function bottomRow() return math.min(self:getStorage(self.list).max, self.scroll_y[self.list] + (self:getLimit(self.list) - 1)) end
    if Input.is("cancel", key) then
        self:remove()
        Game.world:closeMenu()
    elseif Input.is("confirm", key) then
        local function adjustPosition()
            if self.current_selecting > getEndRow() then
                self.current_selecting = getEndRow()
            end
            if self.scroll_y[self.list] > 1 and math.min(math.max(1, getEndRow() - (self:getLimit(self.list) - 1)), self.current_selecting) < self.scroll_y[self.list] then
                self.current_selecting = self.current_selecting - 1
            end
        end
        if self.list == 1 then
            if not Game.inventory:isFull(self:getStorage(2)) and Game.inventory:getItem(self:getStorage(self.list), self.current_selecting) then
                Game.inventory:addItemTo(self:getStorage(2), self:getSelectedItem(1))
                Game.inventory:removeItemFrom(self:getStorage(1), self.current_selecting)
                adjustPosition()
            end
        elseif self.list == 2 then
            if not Game.inventory:isFull(self:getStorage(1)) and Game.inventory:getItem(self:getStorage(self.list), self.current_selecting) then
                Game.inventory:addItemTo(self:getStorage(1), self:getSelectedItem(2))
                Game.inventory:removeItemFrom(self:getStorage(2), self.current_selecting)
                adjustPosition()
            end
        end
    elseif Input.is("right", key) and self.list < 2 then
        self.list = 2
        self.current_selecting = self.current_selecting + self.scroll_y[2] - self.scroll_y[1]
        if self.current_selecting > bottomRow() then
            self.current_selecting = bottomRow()
        end
    elseif Input.is("left", key) and self.list > 1 then
        self.list = 1
        self.current_selecting = self.current_selecting + self.scroll_y[1] - self.scroll_y[2]
        if self.current_selecting > bottomRow() then
            self.current_selecting = bottomRow()
        end
    elseif Input.is("up", key) then
        self.current_selecting = self.current_selecting - 1

        if self.current_selecting < 1 then
            self.current_selecting = 1
        end
    elseif Input.is("down", key) then
        self.current_selecting = self.current_selecting + 1

        if self.current_selecting > getEndRow() then
            self.current_selecting = getEndRow()
        end
    end
    
    local limit = self:getLimit(self.list)
    local min_scroll = math.max(1, self.current_selecting - (limit - 1))
    local max_scroll = math.min(math.max(1, getEndRow() - (limit - 1)), self.current_selecting)
    self.scroll_y[self.list] = Utils.clamp(self.scroll_y[self.list], min_scroll, max_scroll)
end

function LightStorageMenu:drawStorage(list)
    local x = (list * 302) - 234
    local y = 78
    for i = self.scroll_y[list], math.min(self:getStorage(list).max, self.scroll_y[list] + (self:getLimit(list) - 1)) do
        local offset = i - self.scroll_y[list]
        
        local item = Game.inventory:getItem(self:getStorage(list), i)
        if item then
            -- Draw the item name
            Draw.setColor(COLORS["white"])
            love.graphics.setFont(self.font)
            love.graphics.print(item:getName(), x, y - 6 + offset * 32)
        else
            -- Draw a red line
            Draw.setColor(COLORS["red"])
            love.graphics.setLineWidth(1)
            love.graphics.setLineStyle("rough")
            love.graphics.line(x + 12, y + 16 + offset * 32, x + 192, y + 16 + offset * 32)
        end
    end
    
    -- Draw scroll arrows if needed
    if math.min(#self:getStorage(list) + 1, self:getStorage(list).max) > self:getLimit(list) then
        Draw.setColor(1, 1, 1)

        -- Move the arrows up and down only if we're in the spell selection state
        local sine_off = 0
        if self.list == list then
            sine_off = math.sin((Kristal.getTime()*30)/12) * 3
        end

        if self.scroll_y[list] > 1 then
            -- up arrow
            Draw.draw(self.arrow_sprite, 293 - 4 + (list-1) * 302, (72 + 25 - 3) - sine_off, 0, 1, -1)
        end
        if self.scroll_y[list] + self:getLimit(list) <= math.min(#self:getStorage(list) + 1, self:getStorage(list).max) then
            -- down arrow
            Draw.draw(self.arrow_sprite, 293 - 4 + (list-1) * 302, (72 + (32 * self:getLimit(list)) - 19) + sine_off)
        end
    end
end

function LightStorageMenu:draw()
    super.draw(self)

    Draw.setColor(COLORS["white"])
    love.graphics.setFont(self.font)
    -- local name = {self:getStorage(1).name, self:getStorage(2).name}
    -- for i = 1, #name do
        -- if name[i] ~= "BOX" then
            -- name[i] = "INVENTORY"
        -- end
    -- end
    Draw.printAlign(self:getStorage(1).name, 167, 30, "center")
    Draw.printAlign(self:getStorage(2).name, 469, 30, "center")

    if not Input.usingGamepad() then
        love.graphics.print("Press "..Input.getText("cancel").." to Finish", 200, 406)
    else
        love.graphics.print("Press", 200, 406)
        love.graphics.print(" to Finish", 310, 406)
        Draw.draw(Input.getTexture("cancel"), 281, 410, 0, 2, 2)
    end

    love.graphics.setLineWidth(1)
    love.graphics.setLineStyle("rough")
    love.graphics.line(324, 94, 324, 394)
    love.graphics.line(322, 94, 322, 394)

    self:drawStorage(1)
    self:drawStorage(2)
    
    Draw.setColor(Game:getSoulColor())
    Draw.draw(self.heart_sprite, self.list * 302 - 262, 82 + 32 * (self.current_selecting - self.scroll_y[self.list]), 0, 2, 2)
end

return LightStorageMenu