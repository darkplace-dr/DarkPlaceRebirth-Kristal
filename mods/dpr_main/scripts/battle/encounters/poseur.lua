local Poseur, super = Class(Encounter)

function Poseur:init()
    super.init(self)

    self.text = "* Poseur strikes a pose!"

    if Game:isDessMode() then
        self.music = "batterup"
    else
        self.music = "battleut"
    end
    self.background = true

    self:addEnemy("poseur")
end

function Poseur:createBackground()
    if self.background then
        if Game:isDessMode() then
            return Game.battle:addChild(StarsBG({1, 1, 1}))
        else
            return super.createBackground(self)
        end
    end
end

function Poseur:onReturnToWorld(events)
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

return Poseur