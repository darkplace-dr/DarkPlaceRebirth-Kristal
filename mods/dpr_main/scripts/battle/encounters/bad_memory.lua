local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* A bad memory approaches."

    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "battle"
        -- Enables the purple grid battle background
        self.background = true
    end

    -- Add the dummy enemy to the encounter
    self:addEnemy("bad_memory")

end

function Dummy:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end
end

function Dummy:onReturnToWorld(events)
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

return Dummy