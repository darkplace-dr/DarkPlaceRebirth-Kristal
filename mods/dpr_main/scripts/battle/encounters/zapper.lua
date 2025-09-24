local Zapper, super = Class(Encounter)

function Zapper:init()
    super.init(self)

    self.text = "* Zapper blocked the way!"

    self.music = "battle"
    self.background = true

    self:addEnemy("zapper", 529, 235)
end

--[[function Zapper:onReturnToWorld(events)
    -- check whether the enemies were killed
    if Game.battle.killed then
        -- run this code for each event in the table
        for _,event in ipairs(events) do
            for _,event in ipairs(event:getGroupedEnemies(true)) do
                -- set a 'dont_load' flag to true for the event,
                -- which is a special flag that will prevent the event from loading
                event:setFlag("dont_load", true)
            end
        end
    end
end]]

return Zapper