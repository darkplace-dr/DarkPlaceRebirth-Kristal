local DarkInventory, super = HookSystem.hookScript(DarkInventory)

function DarkInventory:convertToLight()
    if not Kristal.getLibConfig("magical-glass", "item_conversion") then
        -- Prevent items conversion
        local new_inventory = LightInventory()

        local was_storage_enabled = new_inventory.storage_enabled
        new_inventory.storage_enabled = true

        for k, storage in pairs(self:getLightInventory().storages) do
            for i = 1, storage.max do
                if storage[i] then
                    if not new_inventory:addItemTo(storage.id, i, storage[i]) then
                        new_inventory:addItem(storage[i])
                    end
                end
            end
        end

        Kristal.callEvent(KRISTAL_EVENT.onConvertToLight, new_inventory)

        new_inventory.storage_enabled = was_storage_enabled

        Game.dark_inventory = self

        return new_inventory
    else
        return super.convertToLight(self)
    end
end

return DarkInventory