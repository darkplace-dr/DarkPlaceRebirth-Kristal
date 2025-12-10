-- This is a recreation of the light item menu using the UI system to add a few features.
local LightItemMenu, super = Class(Object)

function LightItemMenu:init()
    super.init(self, 212, 76, 298, 342) -- 314
    self.font = Assets.getFont("main")

    self.selected_item = 0

    self.party_selecting = 1

    self.storage = Game.inventory:getStorage("items")

    --local inventory = Game.inventory:getStorage(self.storage)

    --local soul = Game.stage:addChild(EasingSoul(0,0))


    self.bg = UIBox(0, 0, self.width, self.height)
    self.box = BoxComponent(FixedSizing(298))
    self.box.x = -32
    self.box.y = -32
    
    self:addChild(self.bg)
    self:addChild(self.box)
    self.box.box.visible = false

    self.menu_storageselect = BasicMenuComponent(FixedSizing(298))
    self.menu_storageselect.horizontal = true
    self.menu_storageselect:setLayout(HorizontalLayout({ gap = 0, align = "space-evenly" }))
    self.menu_storageselect:setMargins(-15,0,0,0)

    self.item_pages = {
        {storage = "items", name = "ITEM"},
        {storage = "key_items", name = "KEY"}
    }

    for i, page in ipairs(self.item_pages) do
        local index = i
        local storage = page.storage
        local option = self.menu_storageselect:addChild(SoulMenuItemComponent(Text(page.name), function () 
            if #Game.inventory.storages[page.storage] > 0 then
                Assets.playSound("ui_select")
                self:createItemList(Game.inventory:getStorage(storage))
                self.menu_storageselect:setUnfocused()
                self.menu_itemselect:setFocused()
            else
                Assets.playSound("ui_cant_select")
            end
        end))
        
        function option:onHovered(hovered, from_focused)
            self.selected = hovered
            self.children[1]:setColor(COLORS.white)
            if hovered and not from_focused then
                Assets.playSound("ui_move")
                Game.world.menu.box.storage = Game.inventory:getStorage(storage)
            end
        end
        function option:onSelected()
            if #Game.inventory.storages[page.storage] > 0 then self.children[1]:setColor(COLORS.yellow) end
            if self.callback then
                self:callback()
            end
        end
    end

    self.menu_storageselect:setCancelCallback(function ()
        Game.world.menu.state = "MAIN"
        self:remove()
    end)
    
    self.box:addChild(self.menu_storageselect)
    self.menu_storageselect:setFocused()

    self.menu_itemoption = BasicMenuComponent(FixedSizing(298))
    self.menu_itemoption.horizontal = true
    self.menu_itemoption:setLayout(HorizontalLayout({ gap = 0, align = "space-evenly" }))

    local usebutton = self.menu_itemoption:addChild(SoulMenuItemComponent(Text("USE"), function ()
        local item = Game.inventory:getItem(self.storage, self.selected_item)

        if (item.usable_in == "world" or item.usable_in == "all") then
            if #Game.party > 1 and item.target == "ally" then
                Assets.playSound("ui_select")
                self.menu_partyselect:setFocused()
                self.party_select_bg.visible = true
                --Game.world:showHealthBars()
            elseif #Game.party > 1 and item.target == "party" then
                -- Assets.playSound("ui_select")
                self.party_selecting = 1
                self:useItem(item)
            else
                self.party_selecting = 1
                self:useItem(item)
            end
        end
    end))
    function usebutton:onSelected()
        if self.callback then
            self:callback()
        end
    end
    local infobutton = self.menu_itemoption:addChild(SoulMenuItemComponent(Text("INFO"), function ()
        local item = Game.inventory:getItem(self.storage, self.selected_item)
        item:onCheck()
        self:remove()
    end))
    function infobutton:onSelected()
        if self.callback then
            self:callback()
        end
    end
    local dropbutton = self.menu_itemoption:addChild(SoulMenuItemComponent(Text("DROP"), function ()
        local item = Game.inventory:getItem(self.storage, self.selected_item)
        self:dropItem(item)
        self:remove()
    end))
    function dropbutton:onSelected()
        if self.callback then
            self:callback()
        end
    end

    self.box:addChild(self.menu_itemoption)
    self.menu_itemoption:setMargins(-15, 308, 0, 0) -- -15, 280, 0, 0
    self.menu_itemoption.visible = false


    self.menu_itemoption:setCancelCallback(function ()
        self.selected_item = 0
        self.menu_itemoption:setUnfocused()
        self.menu_itemselect:setFocused()
    end)

    self.party_select_bg = UIBox(-37, 242, 372, 52)
    self.party_select_bg.visible = false
    self:addChild(self.party_select_bg)


    self.menu_partyselect = nil
    self.menu_partyselect = BasicMenuComponent(FixedSizing(298))
    self.menu_partyselect.horizontal = true
    self.menu_partyselect:setLayout(HorizontalLayout({ gap = 0, align = "space-evenly" }))

    for i in ipairs(Game.party) do
        local index = i
        self.menu_partyselect:addChild(SoulMenuItemComponent(Text(Game.party[i].name), function ()
            self.party_selecting = index
            local item = Game.inventory:getItem(self.storage, self.selected_item)
            self:useItem(item)
            --Game.world.healthbar:transitionOut()
        end))
    end

    self.menu_partyselect:setCancelCallback(function ()
        self.party_select_bg.visible = false
        self.menu_partyselect:setUnfocused()
        self.menu_itemoption:setFocused()
        self.menu_partyselect:setSelected(1)
        --Game.world.healthbar:transitionOut()
    end)

    --self.item_count_bg = UIBox(-156,(not Game.world.menu.top and 270 or 38), 94, 25)
    --self:addChild(self.item_count_bg)

    self.party_select_bg:addChild(self.menu_partyselect)
    --self.party_select_bg.layer = self.item_count_bg.layer + 0.1
    self.menu_partyselect.x = 20
    self.menu_partyselect.y = 25



end

function LightItemMenu:createItemList(storage)
    self.storage = storage
    self.menu_itemselect = BasicMenuComponent(FixedSizing(290), FixedSizing(256), { hold = true })
    self.menu_itemselect:setLayout(VerticalLayout({ gap = 0, align = "start" }))
    self.menu_itemselect:setOverflow("scroll")
    self.menu_itemselect:setScrollType("scroll")
    self.menu_itemselect:setMargins(0,40,0,0)
    self.item = {}

    for index, item in ipairs(storage) do
        local my_index = index
        self.item[index] = self.menu_itemselect:addChild(SoulMenuItemComponent(Text(item:getName()), function ()
            self.selected_item = my_index
            self.menu_itemselect:setUnfocused()
            self.menu_itemoption:setFocused()
        end))
    end

    if #self.item > 8 then
        self.menu_itemselect:setScrollbar(ScrollbarComponent({gutter = "fill", margins = {0, 0, 0, 0}, arrows = true}))
    end

    self.menu_itemoption.visible = true

    self.menu_itemselect:setCancelCallback(function ()
        self.menu_itemoption.visible = false
        self.menu_itemselect:close()
        self.menu_storageselect:setFocused()
    end)


    self.box:addChild(self.menu_itemselect)
end

function LightItemMenu:draw()
    super.draw(self)

    -- Draw items as plain text, when on the "storage select" part of the menu
    if TableUtils.contains(Input.component_stack, self.menu_storageselect) then
        Draw.setColor(COLORS.gray)
        for i, item in ipairs(self.storage) do
            if i > 8 then break end -- Can only fit 8 items, don't draw any more
            love.graphics.print(item:getName(), 28, 40 + 32 * (i-1))
        end
    end

    local font = love.graphics.getFont()
    love.graphics.setFont(Assets.getFont("main"))
    if self.party_select_bg.visible then
        local item = Game.inventory:getItem(self.storage, self.selected_item)
        love.graphics.printf("Use " .. item:getName() .. " on", -45, 233, 400, "center")


        --[[
        if item.heal_amount then
            love.graphics.setFont(Assets.getFont("small"))
            local menu_items = {}
            menu_items = self.menu_partyselect:getMenuItems()
            for i, chara in ipairs(Game.party) do
                local draw_x = menu_items[i].x - 155
                local draw_y = menu_items[i].y + 300
                love.graphics.printf(chara.lw_health .. "/" .. chara.lw_stats.health, draw_x, draw_y, 400, "center")
            end
        end
        --]]
    end
    --love.graphics.setFont(Assets.getFont("main"))

    --love.graphics.printf(#self.item .. "/" .. Game.inventory.storages["items"].max, -305, (not Game.world.menu.top and 265 or 33), 400, "center")

    love.graphics.setFont(font)
end

function LightItemMenu:useItem(item)
    local result
    if item.target == "ally" then
        result = item:onWorldUse(Game.party[self.party_selecting])
    elseif item.target == "party" or item.target == "none" then
        result = item:onWorldUse(Game.party)
    end
        
    if result then
        if item:hasResultItem() then
            Game.inventory:replaceItem(item, item:createResultItem())
        else
            Game.inventory:removeItem(item)
        end
    end
    self:remove()
end

function LightItemMenu:dropItem(item)
    local result = item:onToss()

    if result ~= false then
        Game.inventory:removeItem(item)
    end
end

return LightItemMenu
