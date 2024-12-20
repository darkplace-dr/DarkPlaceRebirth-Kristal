local Pebblin, super = Class(Encounter)

function Pebblin:init()
    super.init(self)

    self.text = "* Pebblin blocks the way!"

    self.music = "battle"
    self.background = true

    self:addEnemy("pebblin")

    Game:setFlag("cliffside_enc_peblin", true)
end

return Pebblin