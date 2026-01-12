local Electrodasher, super = Class(Encounter)

function Electrodasher:init()
    super.init(self)

    self.text = "* Electrodasher drove in!"

    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "battle"
        self.background = true
    end
	self.speed_up = false
    self:addEnemy("electrodasher")
    --self:addEnemy("electrodasher")
end

function Electrodasher:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end
end

function Electrodasher:onReturnToWorld(events)
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

function Electrodasher:createSoul(x, y, color)
	local soul = Soul(x, y, color)
	if self.speed_up then
		soul.speed = 6
	elseif self.slow_down then
		soul.speed = 2
	end
    return soul
end

return Electrodasher