local arlee, super = Class(Encounter)

function arlee:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* buy my products"

    -- Battle music ("battle" is rude buster)
    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "arleesveryoriginalbattletheme"
        -- Enables the purple grid battle background
        self.background = true
    end

    -- Add the arlee enemy to the encounter
    self:addEnemy("arlee", 480, 270)

    --- Uncomment this line to add another!
    --self:addEnemy("arlee")


end

function arlee:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end
end

function arlee:onReturnToWorld(events)
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

return arlee