local GoogleDino, super = Class(Encounter)

function GoogleDino:init()
    super.init(self)

    self.text = "* The no Wi-Fi pastime begins."

    self.music = "deltarune/rudebuster_boss"

    self.background = true

    self:addEnemy("googledino")
	
	self.flee = false
	
    self.boss_rush = false
	
    if Game:getFlag("googledino_defeated") == true then
        self.boss_rush = true
    end
end

function GoogleDino:createSoul(x, y)
    return BlueSoul(x, y)
end

function GoogleDino:createBackground()
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

return GoogleDino
