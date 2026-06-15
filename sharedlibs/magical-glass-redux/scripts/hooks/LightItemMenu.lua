local LightItemMenu, super = HookSystem.hookScript(LightItemMenu)

function LightItemMenu:init()
    super.init(self)

    self.arrow_sprite = Assets.getTexture("ui/page_arrow_down")
    self.scroll_y = 1
    self.party_select_bg = UIBox(-37, 242, 372, 52)
    self.party_select_bg.visible = false
    self.party_select_bg.layer = -1
    self.party_selecting = 1
    self:addChild(self.party_select_bg)
end

function LightItemMenu:update()
    if self.state == "ITEMOPTION" then
        if Input.pressed("cancel") then
            self.state = "ITEMSELECT"

            return
        end

        local old_selecting = self.option_selecting

        if Input.pressed("left") then
            self.option_selecting = self.option_selecting - 1
        end
        if Input.pressed("right") then
            self.option_selecting = self.option_selecting + 1
        end

        self.option_selecting = MathUtils.clamp(self.option_selecting, 1, 3)

        if self.option_selecting ~= old_selecting then
            self.ui_move:stop()
            self.ui_move:play()
        end

        if Input.pressed("confirm") then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            if self.option_selecting == 1 and (item.usable_in == "world" or item.usable_in == "all") and not (item.target == "enemy" or item.target == "enemies") then
                self.party_selecting = 1
                if #Game.party > 1 and item.target == "ally" then
                    self.ui_select:stop()
                    self.ui_select:play()
                    self.party_select_bg.visible = true
                    self.state = "PARTYSELECT"
                else
                    self:useItem(item)
                end
            elseif self.option_selecting == 2 then
                item:onCheck()
            elseif self.option_selecting == 3 then
                self:dropItem(item)
            end
        end
    elseif self.state == "PARTYSELECT" then
        if Input.pressed("cancel") then
            self.party_select_bg.visible = false
            self.state = "ITEMOPTION"

            return
        end

        local old_selecting = self.party_selecting

        if Input.pressed("right") then
            if Mod.libs["moreparty"] then
                local selected_party, success = Mod.libs["moreparty"]:partySelectHorizontal(self.party_selecting, true, true)
                if success then
                    self.party_selecting = selected_party
                else
                    self.party_selecting = self.party_selecting + 1
                end
            else
                self.party_selecting = self.party_selecting + 1
            end
        end

        if Input.pressed("left") then
            if Mod.libs["moreparty"] then
                local selected_party, success = Mod.libs["moreparty"]:partySelectHorizontal(self.party_selecting, false, true)
                if success then
                    self.party_selecting = selected_party
                else
                    self.party_selecting = self.party_selecting - 1
                end
            else
                self.party_selecting = self.party_selecting - 1
            end
        end

        if Mod.libs["moreparty"] then
            if Input.pressed("up") then
                self.party_selecting = Mod.libs["moreparty"]:partySelectVectical(self.party_selecting, true)
            end

            if Input.pressed("down") then
                self.party_selecting = Mod.libs["moreparty"]:partySelectVectical(self.party_selecting, false)
            end
        end

        self.party_selecting = MathUtils.clamp(self.party_selecting, 1, #Game.party)

        if self.party_selecting ~= old_selecting then
            self.ui_move:stop()
            self.ui_move:play()
        end

        if Input.pressed("confirm") then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            self:useItem(item)
        end
    else
        local old_selecting_item = self.item_selecting

        super.update(self)

        if self.state == "ITEMSELECT" then
            if self.item_selecting ~= old_selecting_item then
                local item_limit = self:getItemLimit()
                local min_scroll = math.max(1, self.item_selecting - (item_limit - 1))
                local max_scroll = math.min(math.max(1, Game.inventory:getItemCount(self.storage) - (item_limit - 1)), self.item_selecting)
                self.scroll_y = MathUtils.clamp(self.scroll_y, min_scroll, max_scroll)
            end
        end
    end
end

function LightItemMenu:draw()
    love.graphics.setFont(self.font)

    local inventory = Game.inventory:getStorage(self.storage)

    local items = {}
    local item_limit = self:getItemLimit()
    for index, item in ipairs(inventory) do
        table.insert(items, item)
    end

    if self.state == "PARTYSELECT" then
        local function party_box_area()
            local party_box = self.party_select_bg
            love.graphics.rectangle("fill", party_box.x - 24, party_box.y - 24, party_box.width + 48, party_box.height + 48)
        end
        love.graphics.stencil(party_box_area, "replace", 1)
        love.graphics.setStencilTest("equal", 0)
    end

    for i = self.scroll_y, math.min(#items, self.scroll_y + (item_limit - 1)) do
        local item = items[i]
        local offset = i - self.scroll_y

        if (item.usable_in == "world" or item.usable_in == "all") and not (item.target == "enemy" or item.target == "enemies") then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_text_unusable"])
        end
        love.graphics.print(item:getName(), 20, 4 + (offset * 32))
    end

    Draw.setColor(PALETTE["world_text"])
    -- Draw scroll arrows if needed
    if #items > item_limit then
        Draw.setColor(1, 1, 1)

        -- Move the arrows up and down only if we're in the item selection state
        local sine_off = 0
        if self.state == "ITEMSELECT" then
            sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
        end

        if self.scroll_y > 1 then
            -- up arrow
            Draw.draw(self.arrow_sprite, 294 - 4, (4 + 25 - 3) - sine_off, 0, 1, -1)
        end
        if self.scroll_y + item_limit <= #items then
            -- down arrow
            Draw.draw(self.arrow_sprite, 294 - 4, (4 + (32 * item_limit) - 19) + sine_off)
        end
    end

    -- Draw scrollbar if needed (unless the item limit is 2, in which case the scrollbar is too small)
    if self.state == "ITEMSELECT" and item_limit > 2 and #items > item_limit then
        local scrollbar_height = (item_limit - 2) * 32 + 7
        Draw.setColor(0.25, 0.25, 0.25)
        love.graphics.rectangle("fill", 294, 4 + 30, 6, scrollbar_height)
        local percent = (self.scroll_y - 1) / (#items - item_limit)
        Draw.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 294, 4 + 30 + math.floor(percent * (scrollbar_height - 6)), 6, 6)
    end
    love.graphics.setStencilTest()

    if self.state ~= "PARTYSELECT" then
        local item = Game.inventory:getItem(self.storage, self.item_selecting)
        if (item.usable_in == "world" or item.usable_in == "all") and not (item.target == "enemy" or item.target == "enemies") then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        love.graphics.print("USE", 20, 284)
        Draw.setColor(PALETTE["world_text"])
        love.graphics.print("INFO", 116, 284)
        love.graphics.print("DROP", 230, 284)
    end

    Draw.setColor(Game:getSoulColor())
    if self.state == "ITEMSELECT" then
        Draw.draw(self.heart_sprite, -4, 12 + 32 * (self.item_selecting - self.scroll_y), 0, 2, 2)
    elseif self.state == "ITEMOPTION" then
        if self.option_selecting == 1 then
            Draw.draw(self.heart_sprite, -4, 292, 0, 2, 2)
        elseif self.option_selecting == 2 then
            Draw.draw(self.heart_sprite, 92, 292, 0, 2, 2)
        elseif self.option_selecting == 3 then
            Draw.draw(self.heart_sprite, 206, 292, 0, 2, 2)
        end
    elseif self.state == "PARTYSELECT" then
        local item = Game.inventory:getItem(self.storage, self.item_selecting)
        Draw.setColor(PALETTE["world_text"])

        local z = Mod.libs["moreparty"] and Mod.libs["moreparty"]:getPartyPerRowAmount()

        Draw.printAlign("Use " .. item:getName() .. " on", 150, 231, "center")

        for i, party in ipairs(Game.party) do
            if i <= z then
                love.graphics.print(party:getShortName(), 63 - (math.min(#Game.party, z) - 2) * 70 + (i - 1) * 122, 269)
            else
                love.graphics.print(party:getShortName(), 63 - (math.min(#Game.party - z, z) - 2) * 70 + (i - 1 - z) * 122, 269 + 38)
            end
        end

        Draw.setColor(Game:getSoulColor())
        for i, party in ipairs(Game.party) do
            if i == self.party_selecting then
                if i <= z then
                    Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party, z) - 2) * 70 + (i - 1) * 122, 277, 0, 2, 2)
                else
                    Draw.draw(self.heart_sprite, 39 - (math.min(#Game.party - z, z) - 2) * 70 + (i - 1 - z) * 122, 277 + 38, 0, 2, 2)
                end
            end
        end
    end

    Object.draw(self)
end

function LightItemMenu:getItemLimit()
    return 8
end

function LightItemMenu:useItem(item)
    local result
    if item.target == "ally" then
        result = item:onWorldUse(Game.party[self.party_selecting])
    else
        result = item:onWorldUse(Game.party)
    end

    if result then
        if item:hasResultItem() then
            Game.inventory:replaceItem(item, item:createResultItem())
        else
            Game.inventory:removeItem(item)
        end
    end
end

return LightItemMenu