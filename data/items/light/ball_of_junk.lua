local item, super = Class(Item, "light/ball_of_junk")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Ball of Junk"

    -- Item type (item, key, weapon, armor)
    self.type = "key"
    -- Whether this item is for the light world
    self.light = true

    -- Item description text (unused by light items outside of debug menu)
    self.description = "A small ball of accumulated things in your pocket."

    -- Light world check text
    self.check = "A small ball\nof accumulated things in your\npocket."

    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil

end

function item:onWorldUse()
    Game.world:startCutscene(function(cutscene) 

        local dark_items = 0
        local slots_to_convert = {}
        local first_item = nil
        -- Check inventory for any dark items
        for i, item in ipairs(Game.inventory:getStorage("items")) do
            if not item.light then
                table.insert(slots_to_convert, i)
                dark_items = dark_items + 1
                -- If this is the first one, store its name
                if not first_item then first_item = item:getName() end
            end
        end
        cutscene:text("* You looked at the junk ball in\nadmiration." .. (dark_items == 0 and "[wait:5]\n* Nothing happened." or ""))
        if dark_items > 0 then
            if dark_items == 1 then
                cutscene:text("* You could probably add your [color:yellow]" .. first_item .. "[color:reset] into it.")
            else
                cutscene:text("* You could probably add some\nmore of your items into it.")
            end
            cutscene:text("* You think about how you [color:yellow]won't\nbe able to get " .. (dark_items == 1 and "it" or "them") .. " back out[color:reset]\nif you do...")
            cutscene:text("* But " .. (dark_items == 1 and "it" or "they") .. " might be more useful\nin the Dark World anyway.")
            cutscene:text("* Add your [color:yellow]" .. (dark_items == 1 and first_item or "DARK ITEMS") .. "[color:reset] to your\n[color:yellow]BALL OF JUNK[color:reset]?")
            local choice = cutscene:choicer({"Yes", "No"})
            if choice == 1 then
                if dark_items == 1 then
                    -- If there's only one, transfer the item into the dark inventory as if we got it from a chest
                    local success, result_text = Game.inventory:tryGiveItem(Game.inventory:getStorage("items")[slots_to_convert[1]])
                    if success then Game.inventory:removeItem(Game.inventory:getStorage("items")[slots_to_convert[1]]) end
                    cutscene:text(result_text)
                else
                    -- If there's more than one, we need to transfer each item individually, then update the light inventory to remove any empty slots.
                    local items_converted = 0
                    for i, item in ipairs(slots_to_convert) do

                        local success, result_text = Game.inventory:tryGiveItem(Game.inventory:getStorage("items")[item])
                        if success then
                            items_converted = items_converted + 1
                            Game.inventory:getStorage("items")[item] = "Removed Item"
                        else
                            break -- Inventory is full; stop here
                        end

                    end
                    if items_converted == 0 then -- Couldn't transfer any
                        cutscene:text("* (Your [color:yellow]BALL OF JUNK[color:reset] is too big\nto take any items.)")
                    elseif items_converted < dark_items then -- Transferred some, but not all
                        cutscene:text("* (Your [color:yellow]BALL OF JUNK[color:reset] became too big to take all of your items.)")
                    else
                        cutscene:text("* (Your [color:yellow]DARK ITEMS[color:reset] were added to your [color:yellow]BALL OF JUNK[color:reset].)")
                    end
                    -- Remove empty item slots
                    for i = 1, Game.inventory.storages.items.max do
                        if Game.inventory.storages.items[i] == "Removed Item" then table.remove(Game.inventory.storages.items, i) end
                    end
                end

            end
            
        end

    end)

    --Game.world:showText("* You looked at the junk ball in\nadmiration.[wait:5]\n* Nothing happened.")
    return false
end

function item:onToss()
    Game.world:startCutscene(function(cutscene)
        if Game.chapter == 1 then
            cutscene:text("* You really didn't want to throw\nit away.")
        else
            cutscene:text("* You took it from your pocket.[wait:5]\n"..
                          "* You have a [color:yellow]very,[wait:5] very,[wait:5] bad\n"..
                            "feeling[color:reset] about throwing it away.")
        end
        cutscene:text("* Throw it away anyway?")

        local dropped
        if Game.chapter == 1 then
            dropped = cutscene:choicer({"No", "Yes"}) == 2
        else
            dropped = cutscene:choicer({"Yes", "No"}) == 1
        end

        if dropped then
            for k,storage in pairs(Game.inventory:getDarkInventory().storages) do
                if storage.id ~= "key_items" and storage.id ~= "storage" then
                    for i = 1, storage.max do
                        storage[i] = nil
                    end
                end
            end
            Game.inventory:removeItem(self)

            Assets.playSound("bageldefeat")
            cutscene:text("* Hand shaking,[wait:5] you dropped the\nball of junk on the ground.")
            cutscene:text("* It broke into pieces.")
            cutscene:text("* You felt bitter.")
        else
            cutscene:text("* You felt a feeling of relief.")
        end
    end)
    return false
end

function item:onCheck()
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* \""..self:getName().."\" - "..self:getCheck())

        local comment

        if Game.inventory:getDarkInventory():hasItem("dark_candy") then
            comment = "* It smells like scratch'n'sniff marshmallow stickers."
        end

        comment = Kristal.callEvent(KRISTAL_EVENT.onJunkCheck, self, comment) or comment

        if comment then
            cutscene:text(comment)
        end
    end)
end

function item:getCheck()
    local check = super.getCheck(self)
    if Game.chapter == 1 then
        check = "A small ball\nof accumulated things."
    end

    return check
end

return item