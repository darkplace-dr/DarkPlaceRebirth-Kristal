--[[
Utils.hook(LightItemMenu, "init", function(orig, self)
    orig(self)

    -- States: ITEMSELECT, ITEMOPTION, PARTYSELECT
    self.party_selecting = 1

    if MagicalGlass:getConfig("lightItemMenuPartySelectConfirm") then
        self.party_select_confirm = true
    else
        self.party_select_confirm = false
    end

    self.party_select_bg = UIBox(-36, 242, 372, 52)
    self.party_select_bg.visible = false
    self.party_select_bg.layer = -1
    self:addChild(self.party_select_bg)
end)

Utils.hook(LightItemMenu, "useItem", function(orig, self, item, member)
    local result
    if item.target == "ally" then
        result = item:onWorldUse(Game.party[member])
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
end)

Utils.hook(LightItemMenu, "update", function(orig, self)
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

        -- this wraps in deltatraveler lmao
        self.option_selecting = Utils.clamp(self.option_selecting, 1, 3)

        if self.option_selecting ~= old_selecting then
            self.ui_move:stop()
            self.ui_move:play()
        end

        if Input.pressed("confirm") then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            if self.option_selecting == 1 and (item.usable_in == "world" or item.usable_in == "all") then
                if #Game.party > 1 and item.target == "ally" then
                    self.ui_select:stop()
                    self.ui_select:play()
                    self.party_select_bg.visible = true
                    self.party_selecting = 1
                    self.state = "PARTYSELECT"
                elseif self.party_select_confirm and #Game.party > 1 and item.target == "party" then
                    self.ui_select:stop()
                    self.ui_select:play()
                    self.party_select_bg.visible = true
                    self.party_selecting = "all"
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

        if self.party_selecting ~= "all" then
            local old_selecting = self.party_selecting

            if Input.pressed("right") and self.party_selecting < #Game.party then
                self.party_selecting = self.party_selecting + 1
            end
    
            if Input.pressed("left") and self.party_selecting > 1 then
                self.party_selecting = self.party_selecting - 1
            end

            if self.party_selecting ~= old_selecting then
                self.ui_move:stop()
                self.ui_move:play()
            end
        end

        if Input.pressed("confirm") then
            local item = Game.inventory:getItem(self.storage, self.item_selecting)
            self:useItem(item, self.party_selecting)
        end
    else
        orig(self)
    end
end)

Utils.hook(LightItemMenu, "draw", function(orig, self)
    love.graphics.setFont(self.font)

    local inventory = Game.inventory:getStorage(self.storage)

    for index, item in ipairs(inventory) do
        if (item.usable_in == "world" or item.usable_in == "all") and not (item.target == "enemy" or item.target == "enemies") then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_text_unusable"])
        end

        if self.state == "PARTYSELECT" then
            Draw.pushScissor()
            Draw.scissorPoints(0, 0, 300, 220)
            love.graphics.print(item:getName(), 20, -28 + (index * 32))
            Draw.popScissor()
        else
            love.graphics.print(item:getName(), 20, -28 + (index * 32))
        end
    end

    if self.state ~= "PARTYSELECT" then
        local item = Game.inventory:getItem(self.storage, self.item_selecting)
        if (item.usable_in == "world" or item.usable_in == "all") and not (item.target == "enemy" or item.target == "enemies") then
            Draw.setColor(PALETTE["world_text"])
        else
            Draw.setColor(PALETTE["world_gray"])
        end
        love.graphics.print("USE" , 20 , 284)
        Draw.setColor(PALETTE["world_text"])

        love.graphics.print("INFO", 116, 284)
        love.graphics.print("DROP", 230, 284)
    end

    Draw.setColor(Game:getSoulColor())
    if self.state == "ITEMSELECT" then
        Draw.draw(self.heart_sprite, -4, -20 + (32 * self.item_selecting), 0, 2, 2)
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

        love.graphics.printf("Use " .. item:getName() .. " on...", -50, 233, 400, "center")

        -- "fuck it, i'm hardcoding it" -me
        if #Game.party == 2 then
            for i, member in ipairs(Game.party) do
                love.graphics.print(member:getName(), ((i - 1) * 122) + 68, 270)
            end
            Draw.setColor(Game:getSoulColor())
            for i,_ in ipairs(Game.party) do
                if i == self.party_selecting or self.party_selecting == "all" then
                    Draw.draw(self.heart_sprite, ((i - 1) * 122) + 35, 277, 0, 2)
                end
            end
        elseif #Game.party == 3 then
            for i, member in ipairs(Game.party) do
                love.graphics.print(member:getName(), ((i - 1) * 122) - 2, 270)
            end
            Draw.setColor(Game:getSoulColor())
            for i,_ in ipairs(Game.party) do
                if i == self.party_selecting or self.party_selecting == "all" then
                    Draw.draw(self.heart_sprite, ((i - 1) * 122) - 35, 277, 0, 2)
                end
            end
        end
    end

    LightItemMenu.__super.draw(self)
end)

Utils.hook(LightItemMenu, "useItem", function(orig, self, item)
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
end)
--]]