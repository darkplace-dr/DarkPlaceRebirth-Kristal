local LightInventory, super = HookSystem.hookScript(LightInventory)

function LightInventory:getDarkInventory()
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        -- Don't give the ball of junk
        return Game.dark_inventory
    else
        return super.getDarkInventory(self)
    end
end

function LightInventory:convertToDark()
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        local new_inventory = DarkInventory()

        local was_storage_enabled = new_inventory.storage_enabled
        new_inventory.storage_enabled = true

        for k, storage in pairs(self:getDarkInventory().storages) do
            for i = 1, storage.max do
                if storage[i] then
                    if not new_inventory:addItemTo(storage.id, i, storage[i]) then
                        new_inventory:addItem(storage[i])
                    end
                end
            end
        end

        Kristal.callEvent(KRISTAL_EVENT.onConvertToDark, new_inventory)

        new_inventory.storage_enabled = was_storage_enabled

        Game.light_inventory = self

        return new_inventory
    else
        return super.convertToDark(self)
    end
end

function LightInventory:tryGiveItem(item, ignore_dark)
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        if Game.inventory:hasItem("light/ball_of_junk") then
            return super.tryGiveItem(self, item, ignore_dark)
        else
            if type(item) == "string" then
                item = Registry.createItem(item)
            end
            if ignore_dark or item.light then
                return Inventory.tryGiveItem(self, item, ignore_dark)
            else
                local dark_inv = self:getDarkInventory()
                local result = dark_inv:addItem(item)
                if result then
                    return true, "* ([color:yellow]" .. item:getName() .. "[color:reset] was added to your [color:yellow]DARK ITEMs[color:reset].)"
                else
                    return false, "* (You have too many [color:yellow]DARK ITEMs[color:reset] to take [color:yellow]" .. item:getName() .. "[color:reset].)"
                end
            end
        end
    else
        return super.tryGiveItem(self, item, ignore_dark)
    end
end

return LightInventory