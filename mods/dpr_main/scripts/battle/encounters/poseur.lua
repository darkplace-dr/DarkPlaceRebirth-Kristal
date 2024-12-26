local Poseur, super = Class(Encounter)

function Poseur:init()
    super.init(self)

    self.text = "* Poseur strikes a pose!"

    if Game:isDessMode() then
        self.music = "batterup"
        self.background = false
	    self.hide_world = true
    else
        self.music = "battleut"
        self.background = true
    end

    self:addEnemy("poseur")
end

function Poseur:onBattleInit()
    if Game:isDessMode() then
        self.bg = StarsBG({1, 1, 1})
        Game.battle:addChild(self.bg)
    end
end

return Poseur