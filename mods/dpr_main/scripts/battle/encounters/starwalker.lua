local Starwalker, super = Class(Encounter)

function Starwalker:init()
    super.init(self)

    self.text = "* Star walker has changed forms...\n* [color:yellow]TP[color:reset] Gain reduced outside of [color:yellow]Fallen Stars![color:reset]"

    self.starwalker = self:addEnemy("starwalker", 530, 238)

    -- music by nyako! give credit if used!
    self.music = "starwalker"

    self.reduced_tension = true

    self.no_end_message = false
	
	self.flee = false

    self.boss_rush = false
	
    if Game:getFlag("starwalker_defeated") == true then
        self.boss_rush = true
    end
end

function Starwalker:createBackground()
    if self.background then
        if Game:isDessMode() and not self.boss_rush then
            return Game.battle:addChild(StarsBG({1, 1, 1}))
        elseif self.boss_rush == true then
            return Game.battle:addChild(DojoBG({1, 1, 1}))
        else
            return super.createBackground(self)
        end
    end
end

function Starwalker:isAutoHealingEnabled(target)
    return false
end

function Starwalker:canSwoon(target)
    if (target.chara.id == "kris") then
        return false
    end
    return true
end

function Starwalker:update()
    super.update(self)

    for _, enemy in pairs(Game.battle.enemy_world_characters) do
        enemy:remove()
    end
end

function Starwalker:createSoul(x, y, color)
    if self.starwalker.blue or Game:isSpecialMode "BLUE" then
        return BlueSoul(x, y)
    end
    return Soul(x, y, color)
end

return Starwalker
