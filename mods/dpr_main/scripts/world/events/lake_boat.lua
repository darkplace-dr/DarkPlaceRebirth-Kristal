local LakeBoat, super = Class(Event, "lake_boat")

function LakeBoat:init(data)
    super.init(self, data)

    local properties = data.properties or {}
    self.properties = properties
    
    self.boarding = false
    self.active = false
    self.solid = true
    self.finished = false
    self.repairitem = properties["repairitem"] or "bowl_hat"
    self.sound = properties["sound"] or "jump"
    self.offsetX = properties["offsetX"] or 0
    self.offsetY = properties["offsetY"] or 8

    self.testing = properties["test"]
    self.obj = properties["sail"] or properties["object"] or properties["obj"]

    self:setScale(2)
    self:setOrigin(0.5, 1)
end

function LakeBoat:onAdd(parent)
    super.onAdd(self, parent)

    self.startX, self.startY = self.x, self.y
    self.dockX, self.dockY = self.startX, self.startY
    self.targetX, self.targetY = LakeBoat:getMarker(self.obj)

    if self:getFlag("repaired") then
        self:updateBoat()
    end
end

function LakeBoat:onRemove(parent)
    super.onRemove(self, parent)

    if self.boarding == true then
        self.boarding = false
        self.onboard = false
        if self.player then
            self.player.boat = nil
        end
        self:updateRide()
    end
end

function LakeBoat:onInteract(player, dir)
---@diagnostic disable-next-line: param-type-mismatch
    Game.world:startCutscene(function(cutscene)
        self.cutscene = cutscene
        if self:getFlag("repaired") then
            if self.finished or self.testing then
                if self.boarding == true then return end
                self.boarding = not self.boarding
                self:updateRide(cutscene)
            else
                cutscene:text("* Coming soon...\n(if i feel like it)")
            end
            return true
        end
        cutscene:text("* Seems like this boat has seen better days...")
        local repairItem = self.repairitem
        local hasBowl = Game.inventory:hasItem(repairItem)
        if hasBowl then
            cutscene:text("* Use the " .. repairItem .. " to repair it?")
            local choice
            if Game:getFlag("FUN") == 69 then
                choice = cutscene:choicer({"Yes", "No", "it snew"})
            else
                choice = cutscene:choicer({"Yes", "No"})
            end
            if choice == 1 then
                Assets.playSound("funnyfelineboat_discovery")
                Game.inventory:removeItem(repairItem)
                self:setFlag("repaired", true)
                self:updateBoat()
                cutscene:wait(1)
                cutscene:text("* You repaired the boat sucessfully.")
                Assets.playSound("ominous")
            elseif choice == 2 then
                cutscene:text("* You decide to leave it as it is.")
            else
                cutscene:text("...")
                cutscene:text("what?...")
            end
        else
            -- Flavour text
            if repairitem == "bowl_hat" then
                local resolution = Game:getFlag("ken_quest_resolution")
                if resolution == 2 then
                    cutscene:text("* You have the feeling this will stay broken forever...")
                else
                    cutscene:text("* You could try to repair it with something made of wood")
                end
            else
                cutscene:text("* You don't have " .. repairItem .. " needed to repair it")
            end
        end
    end)
    return false
end

function LakeBoat:updateBoat()
    if self:getFlag("repaired") then
        self:setSprite("world/events/boat/idle")
        self.flagAnim = "idle"
    else
        self:setSprite("world/events/boat/broken")
        self.flagAnim = "broken"
    end
end

function LakeBoat:getMarker(obj)
    if obj.id then
        local x, y = Game.world.map:getMarker(obj.id)
        return x, y
    end
    return obj.x, obj.y
end

function LakeBoat:getTarget()
    if not self.boarding then
        return self.dockX, self.dockY
    else
        return self.targetX, self.targetY
    end
end

function LakeBoat:jumpBoat(cutscene, player, boat, ptarget)
    ptarget = ptarget or boat
    local bmX, bmY = boat.x, boat.y
    if bmX == self.x and bmY == self.y then
        bmX, bmY = self.startX, self.startY
    else
        -- self.startX, self.startY = bmX, bmY
    end
    local pmX, pmY = ptarget.x, ptarget.y
    local distance = MathUtils.dist(player.x,player.y,pmX,pmY)
    local time = 20
    -- cutscene:wait(self:slideTo(bmX, bmY, time/2, "in-cubic"))
    self.x = bmX + self.offsetX
    self.y = bmY + self.offsetY
    -- self.x = bmX
    -- self.y = bmY
    local party = TableUtils.merge({Game.world.player}, Game.world.followers)
    for index, chara in ipairs(party) do
        cutscene:jumpTo(chara, pmX, pmY, time, distance * 0.003, "jump_ball", "landed")
    end
    cutscene:wait(distance * 0.005)
end

---@param cutscene WorldCutscene|nil
function LakeBoat:updateRide(cutscene)
    if not cutscene then
        cutscene = self.cutscene or Game.world:startCutscene(function() end)
    end

    Assets.playSound(self.sound)
    self.player = Game.world.player
    local player = self.player
    if self.boarding then
        self.solid = false
        Game.world.music:pause()
        local obj = self.obj
        -- print("marker = " .. id)
        local bmX, bmY = self:getTarget()
        -- print(bmX)
        -- print(bmY)
        self:jumpBoat(cutscene, player, {x = bmX, y = bmY})
        player.boat = self
        self.music = Music("not_acid_lake")
        self.onboard = player
        cutscene:enableMovement()
        cutscene:during(function()
            self:update()
        end)
        cutscene:wait(function()
            if not self.onboard then
                return true
            end
        end)
        -- print(self.update and "yes" or "not")
    else
        self.solid = true
        Game.world.music:play()
        self.music:remove()
        local targetX, targetY = self:getTarget()
        local ptargetX, ptargetY = self.ptarget_x, self.ptarget_y
        self:jumpBoat(cutscene, player, {x = targetX, y = targetY}, {x = ptargetX, y = ptargetY})
        player.boat = nil
    end
end

function LakeBoat:update()
    super.update(self)
    -- print("Something")

    -- print(self.onboard and "something" or "nothing")
    if self.onboard then
        self.x = self.onboard.x + self.offsetX
        self.y = self.onboard.y + self.offsetY
        -- print("x: " .. self.x)
        -- print("y: " .. self.y)
    end
end

function LakeBoat:draw()
    super.draw(self)

    love.graphics.draw(Assets.getTexture("world/events/boat/flag_" .. (self.flagAnim or "idle")),12,-16,0,2,2)
end

return LakeBoat