local Leafling, super = Class(Encounter)

function Leafling:init()
    super.init(self)

    self.text = "* Leafling floats by carefree."

    self.music = "rakuichi_buster_wip"
    self.background = true

    self:addEnemy("leafling", 544, 152)
    self:addEnemy("leafling", 574, 272)
end

function Leafling:onReturnToWorld(events)
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
end

return Leafling