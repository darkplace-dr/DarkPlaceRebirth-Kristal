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

local function specialItem(item, cutscene)
    if item == "fluffy_bandana" then
        Assets.playSound("charjoined")
        Game:getQuest("delivering_a_bandana"):addProgress(1)
        cutscene:text("[voice:none][noskip](* You completed the quest)[wait:6]")
    end
end

function TeleitemPedestal:onInteract(player, dir)
    local specialItems = {"fluffy_bandana"}
    local item
    for _,v in pairs(specialItems) do
        if Game.inventory:hasItem(v) then
            Assets.playSound("celestial_hit")
            Game.inventory:removeItem(v)
            self.active = true
            item = v
            break
        end
    end
---@diagnostic disable-next-line: param-type-mismatch
    Game.world:startCutscene(function(cutscene)
        if self.active then
            cutscene:text("(* Your " .. item .. " glided towards the pedestal!)")
            cutscene:wait(2)
            Game.world.music:pause()
            specialItem(item, cutscene)
            self.active = false
            Game.world.music:play()
        else
            cutscene:text("(* Seems like you got ... [wait:1]\n nothing special...)")
        end
    end)
    return true
end

return TeleitemPedestal