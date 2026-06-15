local RudinnRanger, super = Class(Encounter)

function RudinnRanger:init()
    super.init(self)

    self.text = "* Rudinn Ranger came sparkling \ninto view!"

    self.music = "battle"
    self.background = true

    self:addEnemy("rudinnranger")
    self:addEnemy("rudinnranger")
end

return RudinnRanger