---@class DarkItemMenu : DarkItemMenu
local DarkItemMenu, super = Utils.hookScript(DarkItemMenu)

function DarkItemMenu:getSelectedItem()
    if Game.inventory:hasItem("oddstone") and self.selected_item == 13 then
        return Game.inventory:getItemByID("oddstone")
    end
    return super.getSelectedItem(self)
end

function DarkItemMenu:updateSelectedItem()
    if not Game.world.menu or (Game.world.menu ~= self.parent) then -- will be true if an item creates a new menu
        return
    end
    local items = self:getCurrentStorage()
    if Game.inventory:hasItem("oddstone") and #items == 0 then
        self.item_selected_x = 1
        self.item_selected_y = 8
        self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
        local odd_item = Registry.createItem("oddstone")
        Game.world.menu:setDescription(odd_item:getDescription(), true)
    elseif #items == 0 then
        self.state = "MENU"
        Game.world.menu:setDescription("", false)
    else
        if self.selected_item > #items then
            self.item_selected_x = (#items - 1) % 2 + 1
            self.item_selected_y = math.floor((#items - 1) / 2) + 1
            if Game.inventory:hasItem("oddstone") then
                self.item_selected_x = 1
                self.item_selected_y = 8
            end
            self.selected_item = (2 * (self.item_selected_y - 1) + self.item_selected_x)
        elseif self.selected_item < 1 then
            self.item_selected_x = 1
            self.item_selected_y = 1
            self.selected_item = 1
        end
        if items[self.selected_item] then
            Game.world.menu:setDescription(items[self.selected_item]:getDescription(), true)
        elseif self.item_selected_x == 1 and self.item_selected_y == 8 then
            local odd_item = Registry.createItem("oddstone")
            Game.world.menu:setDescription(odd_item:getDescription(), true)
        else
            Game.world.menu:setDescription("", true)
        end
    end
end

function DarkItemMenu:draw()
    super.draw(self)

    if Game.inventory:hasItem("oddstone") then
        local odd_item = Game.inventory:getItemByID("oddstone")
        -- Draw the item shadow
        Draw.setColor(PALETTE["world_text_shadow"])
        local name = odd_item:getWorldMenuName()
        love.graphics.print(name, 54 + 2, 40 + (7 * 30) + 2)

        if self.state == "MENU" then
            Draw.setColor(PALETTE["world_gray"])
        else
            if odd_item.usable_in == "world" or odd_item.usable_in == "all" then
                Draw.setColor(PALETTE["world_text"])
            else
                Draw.setColor(PALETTE["world_text_unusable"])
            end
        end
        love.graphics.print(name, 54, 40 + (7 * 30))
    end
end

return DarkItemMenu