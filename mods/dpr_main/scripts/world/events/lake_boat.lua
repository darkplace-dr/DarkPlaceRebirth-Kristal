local LakeBoat, super = Class(Event, "lake_boat")

function LakeBoat:updateBoat()
    if Game:getFlag("lakeboat_repaired") then
        self:setSprite("world/events/boat/idle")
        self.flagAnim = "idle"
    else
        self:setSprite("world/events/boat/broken")
        self.flagAnim = "broken"
    end
end

function LakeBoat:updateRide(cutscene)
    if self.boarding then
        Game.world.music:pause()
        self.music = Music("not_acid_lake")
        print("marker = " .. self.properties.marker)
        local boatMarker_X, boatMarker_Y = cutscene:getMarker(self.properties.marker)
        print(boatMarker_X)
        print(boatMarker_Y)
        self:slideTo(boatMarker_X, boatMarker_Y, 1)
    else
        Game.world.music:play()
        self.music:remove()
    end
end

function LakeBoat:init(data)
    super.init(self, data)
    
    self.boarding = false
    self.active = false
    self.solid = true
    self.finished = false
    self.properties = data.properties or {}
    self:setScale(2)
    self:setOrigin(0.5, 1)
    self:updateBoat()
end

function LakeBoat:update()
    super.update(self)
end

function LakeBoat:draw()
    super.draw(self)

    love.graphics.draw(Assets.getTexture("world/events/boat/flag_" .. self.flagAnim),12,-16,0,2,2)
end

function LakeBoat:onInteract(player, dir)
---@diagnostic disable-next-line: param-type-mismatch
    Game.world:startCutscene(function(cutscene)
        if Game:getFlag("lakeboat_repaired") then
            if self.finished then
                Assets.playSound("jump")
                cutscene:wait(1)
                self.boarding = not self.boarding
                self:updateRide(cutscene)
            else
                cutscene:text("* Coming soon...\n(if i feel like it)")
            end
        else
            cutscene:text("* Seems like this boat has seen better days...")
            local resolution = Game:getFlag("ken_quest_resolution")
            if resolution == 2 then
                cutscene:text("* You have the feeling this will stay broken forever...")
            else
                local repairItem = "bowl_hat"
                local hasBowl = Game.inventory:hasItem(repairItem)
                if hasBowl then
                    cutscene:text("* Use the bowl to repair it?")
                    local choice
                    if Game:getFlag("FUN") == 69 then
                        choice = cutscene:choicer({"Yes", "No", "it snew"})
                    else
                        choice = cutscene:choicer({"Yes", "No"})
                    end
                    if choice == 1 then
                        Assets.playSound("item")
                        Game.inventory:removeItem(repairItem)
                        Game:setFlag("lakeboat_repaired", true)
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
                    cutscene:text("* You could try to repair it with something made of wood")
                end
            end
        end
    end)
    return true
end

return LakeBoat