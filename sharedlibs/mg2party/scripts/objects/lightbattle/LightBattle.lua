local LightBattle, super = Class("LightBattle", true)

function LightBattle:postInit(state, encounter)
    super.postInit(self, state, encounter)
    self.tension_bar = self:addChild(TensionBar(-25, 40))
end

return LightBattle