local Pebblin, super = Class(Encounter)

function Pebblin:init()
    super.init(self)

    self.text = "* Pebblin blocks the way!"

    self.music = "battle"
    self.background = true

    self:addEnemy("pebblin")
end

function Pebblin:onBattleEnd()
    super.onBattleEnd(self)

    if not Game:getFlag("cliffside_enc_peblin") then
        Game:setFlag("cliffside_enc_peblin", true)
        Game.world:spawnNPC("cat", 340, 60)
        Game.world:getCharacter("pebblin"):remove()
    end
end

return Pebblin