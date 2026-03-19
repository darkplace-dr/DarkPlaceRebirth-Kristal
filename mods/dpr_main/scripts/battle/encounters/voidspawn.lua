local Voidspawn, super = Class(Encounter)

function Voidspawn:init()
    super.init(self)

    self.text = "* You've been cornered by Voidspawn.\n* [color:yellow]TP[color:reset] Gain reduced outside of [color:yellow]???[color:reset]"

    self.music = "titan_spawn"
    self.background = true

    self.reduced_tension = true
    self.light_radius = 48

    self:addEnemy("voidspawn")
    self.flee = false
end

function Voidspawn:onTurnEnd()
    super.onTurnEnd(self)
	self.light_radius = 48
end

return Voidspawn