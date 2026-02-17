local Rudinn, super = Class(Encounter)

function Rudinn:init()
    super.init(self)

    self.text = "* Rudinn drew near!"
	if Game:getFlag("firstRudinnText", 0) >= 1 then
		self.text = "* A different Rudinn from last time drew near!"
	end
	if Game:getFlag("firstRudinnText", 0) == 2 then
		self.text = "* Assumedly another different Rudinn appeared!"
	end

    self.music = "battle"
    self.background = true

    self:addEnemy("rudinn")
end

-- TODO: Glowshard functions in enemies
function Rudinn:onGlowshardUse(item, user)
    local _lines = ""
    for _, enemy in ipairs(Game.battle.enemies) do
        if enemy.id == "rudinn" then
			_lines = _lines .. "* " .. enemy.name .. " became enraptured!\n"
			enemy:addMercy(100)
		end
    end
    Game.inventory:removeItem(item)
    return {
        "* "..user.chara.name.." used the GLOWSHARD!",
        _lines,
        "* The GLOWSHARD disappeared!"
    }
end

-- TODO: Manual functions in enemies
function Rudinn:onManualUse(item, user)
    local _lines = ""
    for _, enemy in ipairs(Game.battle.enemies) do
        if enemy.id == "rudinn" then
            _lines = _lines .. "* " .. enemy.name .. " was [color:blue]bored to tears[color:reset]!\n"
            enemy:setAnimation("tired")
            enemy:setTired(true)
            enemy.dialogue_override = "Hey can\nyou read\nit more fast?"
        end
    end
    return {
        "* "..user.chara.name.." read the MANUAL!",
        _lines
    }
end

function Rudinn:onReturnToWorld(events)
	-- Rudinn encounter text easter egg
	if Game.world.map.id == "floorcard/first_rudinn" then
		Game:setFlag("firstRudinnText", Game:getFlag("firstRudinnText", 0) + 1)
	end
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

return Rudinn