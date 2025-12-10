local TeleitemPedestal, super = Class(Event, "teleitem_pedestal")

function TeleitemPedestal:init(data)
    super.init(self, data)
    
    self.item = ""
    self.active = false
    self:setScale(2)
    self:setOrigin(0.5, 1)
    self:setSprite("world/events/pillar")
    self.solid = true
end

function TeleitemPedestal:update()
    super.update(self)
end

function TeleitemPedestal:draw()
    super.draw(self)

    if self.active then
        love.graphics.setColor(love.math.random(0.0,1),love.math.random(0.0,1),love.math.random(0.0,1),0.2)
        love.graphics.draw(Assets.getTexture("world/events/glow"),4)
        love.graphics.setColor(1,1,1,1)
    end
end

function TeleitemPedestal:onInteract(player, dir)
    local darkInventory = Game.inventory:getDarkInventory()
    local items = darkInventory.stored_items
    Game.world:startCutscene(function(cutscene)
        for item,info in pairs(items) do
            -- print("item = " .. v)
            -- print("storage = " .. v.storage)
            -- print("index = " .. v.index)
            -- local item = Registry.createItem(itemName)
            if type(item) == "table" then
                if item.pedestalPreUse or item.pedestalUse or item.pedestalUsed then
                    -- print("pedestal item found")
                    Assets.playSound("celestial_hit")

                    if item.pedestalPreUse then
                        -- print("Preuse")
                        item:pedestalPreUse(cutscene)
                    end

                    self.active = true
                    cutscene:text("* (Your [color:yellow]" .. item.name .. "[color:reset] glided towards the pedestal!)")
                    cutscene:wait(1)
                    Game.world.music:pause()

                    if item.pedestalUse then
                        -- print("Use")
                        item:pedestalUse(cutscene)
                    end

                    self.active = false

                    if item.pedestalUsed then
                        -- print("Used")
                        item:pedestalUsed(cutscene)
                    end

                    Game.world.music:play()
                    return
                end
            end
        end
        cutscene:text("* (Seems like you got ... [wait:1]\n   nothing special...)")
    end)
end

return TeleitemPedestal