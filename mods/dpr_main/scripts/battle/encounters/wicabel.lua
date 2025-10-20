local Wicabel, super = Class(Encounter)

function Wicabel:init()
    super.init(self)

    self.text = "* Wicabel clangs in your way!"

    self.music = "ch4_battle"
    self.background = true

    self:addEnemy("wicabel")
end

--[[function Wicabel:onReturnToWorld(events)
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

return Wicabel